import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_drag_info.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_grid.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item_managed.dart';
import 'package:inventory_prototype/inventory/enums/inventory_item_orientation.dart';
import 'package:inventory_prototype/inventory/exceptions/invalid_inventory_cell_index.dart';
import 'package:inventory_prototype/inventory/extensions/size_extension.dart';
import 'package:inventory_prototype/vector2.dart';

class InventoryManager with ChangeNotifier {
  /// The inventory grid definition.
  final InventoryGrid grid;

  /// Helper list of managed items to keep track of the cell index and the item itself.
  final List<InventoryItemManaged> _managedItems = [];

  /// List of cell indexes occupied by the [InventoryItemManaged].
  List<int> get _occupiedCellIndexes => _managedItems.expand((item) => _getItemOccupiedCells(item)).toList();

  /// List of cell indexes that are not occupied by any item.
  List<int> get _freeCellIndexes =>
      List.generate(grid.cellsCount, (index) => index).where((index) => !_occupiedCellIndexes.contains(index)).toList();

  /// List of items to easily query the contained [InventoryItem].
  List<InventoryItem> get items => _managedItems.map((e) => e.item).toList();

  /// Information about the currently dragged item.
  InventoryDragInfo? dragInfo;

  /// Constructor
  InventoryManager({required this.grid});

  // *** *** *** *** *** *** *** ***
  // ***      Public API         ***
  // *** *** *** *** *** *** *** ***

  /// Returns the relative position on screen of a cell by it's [index].
  Vector2 getCellPosition(int index) {
    _isCellIndexValid(index, throwException: true);

    final int rowIndex = index ~/ grid.columns;
    final int columnIndex = index % grid.columns;

    return grid.inventoryCalculatedPosition +
        Vector2(
          columnIndex * (grid.cellSize.width + grid.cellSpacing),
          rowIndex * (grid.cellSize.height + grid.cellSpacing),
        );
  }

  /// Returns the cell index by a given relative [position] on screen.
  int? getCellIndexFromPosition(Vector2 position) {
    final Vector2 relativePosition = position - grid.inventoryCalculatedPosition;

    final int rowIndex = (relativePosition.y / (grid.cellSize.height + grid.cellSpacing)).floor();
    final int columnIndex = (relativePosition.x / (grid.cellSize.width + grid.cellSpacing)).floor();

    if (rowIndex < 0 || rowIndex >= grid.rows) return null;
    if (columnIndex < 0 || columnIndex >= grid.columns) return null;

    final int cellIndex = _getCellIndexByRowAndColumn(rowIndex, columnIndex);
    final Vector2 cellPosition = getCellPosition(cellIndex);

    if (position.x > cellPosition.x + grid.cellSize.width) return null;
    if (position.y > cellPosition.y + grid.cellSize.height) return null;

    if (position.x < cellPosition.x) return null;
    if (position.y < cellPosition.y) return null;

    return cellIndex;
  }

  /// Adds an [item] to the inventory.
  ///
  /// The item will be placed in the first available space.
  /// If the item can be rotated, it will try place it in the default orientation and then in the opposite one.
  ///
  /// Note: This method does not move around other items to fit the new one.
  ///
  /// Returns `false` if the [item] could not be added.
  bool addItem(InventoryItem item) {
    if (_freeCellIndexes.length < item.totalOccupiedCells) return false;

    for (final int freeCellIndex in _freeCellIndexes) {
      if (_putItemAt(item, freeCellIndex, item.defaultOrientation)) return true;

      if (item.canBeRotated && _putItemAt(item, freeCellIndex, item.defaultOppositeOrientation)) return true;
    }

    return false;
  }

  /// Checks if the inventory contains an item that satisfies [test].
  ///
  /// You can set [itemCount] to check for more than one item at once.
  ///
  /// Returns `true` if the inventory contains at least [itemCount] items that satisfy [test].
  bool hasItemWhere(bool Function(InventoryItemManaged item) test, {int itemCount = 1}) {
    return _managedItems.where(test).length >= itemCount;
  }

  /// Removes items that satisfy [test] from the inventory.
  ///
  /// You can set [removeCount] to remove more than one item at once. `-1` means `all`.
  ///
  /// Returns `true` if all [removeCount] items were removed, returns `false` if there were not enough items to remove.
  bool removeItemWhere(bool Function(InventoryItemManaged item) test, {int removeCount = 1}) {
    final int itemCount = _managedItems.where(test).length;

    if (removeCount == -1) {
      removeCount = itemCount;
    }

    if (itemCount > removeCount) return false;

    _managedItems.removeWhere((InventoryItemManaged managedItem) {
      return test(managedItem) && removeCount-- > 0;
    });

    notifyListeners();

    return true;
  }

  /// Handles the [PointerDownEvent].
  void onPointerDown(PointerDownEvent event) {
    // 0x01 - left mouse button
    // 0x02 - right mouse button
    if (event.buttons & 0x01 == 0x01) {
      _onLeftClick(event);
    } else if (event.buttons & 0x02 == 0x02) {
      _onRightClick(event);
    }
  }

  /// Handles the [PointerHoverEvent].
  void onHover(PointerHoverEvent event) {
    if (dragInfo == null) return;

    dragInfo!.updatePosition(event.localPosition);
  }

  // *** *** *** *** *** *** *** ***
  // ***     Building methods    ***
  // *** *** *** *** *** *** *** ***

  /// Builds entire inventory widget.
  ///
  /// This widget should be placed in a [Stack] to be displayed correctly.
  List<Widget> build(BuildContext context) {
    return [
      ..._buildCells(context),
      ..._buildItems(context),
      _buildTrashCan(context),
      _buildDraggedItem(context),
    ];
  }

  /// Builds a list of [Widget]s that represent the inventory cells.
  List<Widget> _buildCells(BuildContext context) {
    return [
      for (var cellIndex = 0; cellIndex < grid.cellsCount; cellIndex++)
        Builder(
          builder: (context) {
            final Vector2 cellPosition = getCellPosition(cellIndex);

            return Positioned(
              top: cellPosition.y,
              left: cellPosition.x,
              child: _buildInventoryCell(),
            );
          },
        ),
    ];
  }

  /// Builds a single [Widget] that represents an inventory cell.
  Widget _buildInventoryCell() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      width: grid.cellSize.width,
      height: grid.cellSize.height,
    );
  }

  /// Builds a list of [Widget]s  to be displayed in the inventory.
  List<Widget> _buildItems(BuildContext context) {
    return _managedItems.map((InventoryItemManaged managedItem) {
      final Vector2 cellPosition = getCellPosition(managedItem.cellIndex);
      final Size itemRealSize = managedItem.getRealSize(grid);

      return Positioned(
        top: cellPosition.y,
        left: cellPosition.x,
        child: SizedBox(
          width: itemRealSize.width,
          height: itemRealSize.height,
          child: managedItem.item.build(context, grid: grid),
        ),
      );
    }).toList();
  }

  /// Builds a [Positioned] widget for the dragged item if there is one.
  Widget _buildDraggedItem(BuildContext context) {
    if (dragInfo == null) return const SizedBox();

    return ListenableBuilder(
      listenable: dragInfo!,
      builder: (context, snapshot) {
        final Size itemRealSize = dragInfo!.managedItem.getRealSize(grid);
        final Vector2 itemPosition = _calculateDraggedItemPosition();

        return Positioned(
          top: itemPosition.y,
          left: itemPosition.x,
          child: SizedBox(
            width: itemRealSize.width,
            height: itemRealSize.height,
            child: dragInfo!.managedItem.item.build(context, grid: grid, isDragged: true),
          ),
        );
      },
    );
  }

  /// Builds a [Positioned] widget for the trash can.
  Widget _buildTrashCan(BuildContext context) {
    return Positioned(
      top: grid.trashCanCalculatedPosition.y,
      left: grid.trashCanCalculatedPosition.x,
      child: Container(
        width: grid.trashCanSize.width,
        height: grid.trashCanSize.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.delete_outline,
          color: Colors.grey[800],
          size: grid.trashCanSize.height * 0.65,
        ),
      ),
    );
  }

  // *** *** *** *** *** *** *** ***
  // ***   Cell related methods  ***
  // *** *** *** *** *** *** *** ***

  /// Checks if given cell index is valid.
  /// Can throw an [InvalidInventoryCellIndex] exception if [throwException] is `true`.
  bool _isCellIndexValid(int index, {bool throwException = false}) {
    final bool isValid = index >= 0 && index < grid.cellsCount;

    if (throwException && !isValid) {
      throw InvalidInventoryCellIndex(
        cellIndex: index,
        minCellIndex: 0,
        maxCellIndex: grid.cellsCount - 1,
      );
    }

    return isValid;
  }

  /// Returns cell index by it's [row] and [column].
  int _getCellIndexByRowAndColumn(int row, int column) {
    final int index = row * grid.columns + column;

    _isCellIndexValid(index, throwException: true);

    return index;
  }

  // *** *** *** *** *** *** *** ***
  // ***   Item related methods  ***
  // *** *** *** *** *** *** *** ***

  /// Adds an [item] to the inventory at a given [cellIndex] and [orientation] if possible.
  bool _putItemAt(InventoryItem item, int cellIndex, InventoryItemOrientation orientation) {
    if (!_isCellIndexValid(cellIndex)) return false;
    if (!_canItemBePlaced(item, cellIndex, orientation)) return false;

    _managedItems.add(
      InventoryItemManaged(
        item: item,
        cellIndex: cellIndex,
        orientation: orientation,
      ),
    );

    notifyListeners();
    return true;
  }

  /// Adds an [item] to the inventory at a given [cellIndex] and [orientation] if possible.
  /// Different from [_putItemAt] as it tries to place any cell of item at given [cellIndex], not only the top-left one.
  ///
  /// Returns `true` if the item was added, `false` otherwise.
  bool _putItemAtWithOffset(InventoryItem item, int cellIndex, InventoryItemOrientation orientation) {
    if (!_isCellIndexValid(cellIndex)) return false;

    for (int j = 0; j < item.size.height; j++) {
      for (int i = 0; i < item.size.width; i++) {
        final int newCellIndex = cellIndex - (i + (j * grid.columns));

        if (_putItemAt(item, newCellIndex, orientation)) {
          return true;
        }
      }
    }

    return false;
  }

  /// Checks if a given [item] can be placed in a given [cellIndex] and [orientation].
  bool _canItemBePlaced(InventoryItem item, int cellIndex, InventoryItemOrientation orientation) {
    _isCellIndexValid(cellIndex, throwException: true);

    final InventoryItemManaged itemManaged = InventoryItemManaged(
      item: item,
      cellIndex: cellIndex,
      orientation: orientation,
    );

    if (!_isItemPositionValid(itemManaged)) return false;

    final List<int> newlyOccupiedCells = _getItemOccupiedCells(itemManaged);

    return newlyOccupiedCells.every((int newlyOccupiedIndex) => _freeCellIndexes.contains(newlyOccupiedIndex));
  }

  /// Returns the [InventoryItemManaged] that occupies the given [index].
  InventoryItemManaged? _getItemByCellIndex(int index) {
    _isCellIndexValid(index, throwException: true);

    return _managedItems.cast<InventoryItemManaged?>().firstWhere(
          (InventoryItemManaged? managedItem) => _getItemOccupiedCells(managedItem!).contains(index),
          orElse: () => null,
        );
  }

  /// Checks if the position of the item is valid - if it's not out of bounds.
  bool _isItemPositionValid(InventoryItemManaged managedItem) {
    for (int i = 0; i < managedItem.itemSize.width.toInt(); i++) {
      for (int j = 0; j < managedItem.itemSize.height.toInt(); j++) {
        final int columnIndex = (managedItem.cellIndex % grid.columns) + i;
        final int rowIndex = (managedItem.cellIndex ~/ grid.columns) + j;

        if (columnIndex < 0 || columnIndex >= grid.columns) return false;
        if (rowIndex < 0 || rowIndex >= grid.rows) return false;
      }
    }

    return true;
  }

  /// Returns the cell indexes occupied by given [managedItem].
  List<int> _getItemOccupiedCells(InventoryItemManaged managedItem) {
    final List<int> occupiedCells = [];

    for (int i = 0; i < managedItem.itemSize.width.toInt(); i++) {
      for (int j = 0; j < managedItem.itemSize.height.toInt(); j++) {
        final int cellIndex = managedItem.cellIndex + i + (j * grid.columns);

        if (cellIndex < 0 || cellIndex >= grid.cellsCount) continue;

        occupiedCells.add(cellIndex);
      }
    }

    return occupiedCells;
  }

  // *** *** *** *** *** *** *** ***
  // ***  Item dragging methods  ***
  // *** *** *** *** *** *** *** ***

  /// Picks up an item from inventory at the current mouse position.
  void _onMousePickupItem(PointerDownEvent event) {
    final Vector2 mousePosition = Vector2(event.localPosition.dx, event.localPosition.dy);

    final int? pointedCellIndex = getCellIndexFromPosition(mousePosition);
    if (pointedCellIndex == null) return;

    final InventoryItemManaged? managedItem = _getItemByCellIndex(pointedCellIndex);
    if (managedItem == null) return;

    _createDragInfo(pointedCellIndex, managedItem, mousePosition);
    removeItemWhere((item) => item.cellIndex == managedItem.cellIndex);

    notifyListeners();
  }

  /// Creates the drag info for the [managedItem] picked up from given [cellIndex] at [mousePosition].
  void _createDragInfo(int cellIndex, InventoryItemManaged managedItem, Vector2 mousePosition) {
    final Vector2 baseCellOffset = Vector2(
      ((cellIndex % grid.columns) - (managedItem.cellIndex % grid.columns)).toDouble(),
      ((cellIndex ~/ grid.columns) - (managedItem.cellIndex ~/ grid.columns)).toDouble(),
    );

    dragInfo = InventoryDragInfo(
      managedItem: managedItem,
      mousePosition: mousePosition,
      cellOffsets: {
        managedItem.orientation: baseCellOffset,
        managedItem.oppositeOrientation: const Vector2.zero(),
      },
    );
  }

  /// Drops the dragged item in inventory at the current mouse position.
  void _onMouseDropItem(PointerDownEvent event) {
    final Vector2 mousePosition = Vector2(event.localPosition.dx, event.localPosition.dy);
    final int? pointedCellIndex = getCellIndexFromPosition(mousePosition);

    if (pointedCellIndex == null) {
      /// If click was outside of the inventory, check if it was over the trash can
      if (mousePosition.x > grid.trashCanCalculatedPosition.x &&
          mousePosition.x < grid.trashCanCalculatedPosition.x + grid.trashCanSize.width &&
          mousePosition.y > grid.trashCanCalculatedPosition.y &&
          mousePosition.y < grid.trashCanCalculatedPosition.y + grid.trashCanSize.height) {
        dragInfo = null;
        notifyListeners();
      }

      return;
    }

    // Pointed cell - the cell of the inventory that the mouse is currently over
    // Base cell - the top left cell of the item
    // Offset cell - the cell of the item that was clicked when picking it up

    // Calculate the base cell
    final int baseCellIndex =
        pointedCellIndex - (dragInfo!.cellOffset.x.toInt() + (dragInfo!.cellOffset.y.toInt() * grid.columns));

    // Try to place the item at calculated base cell. [_putItemAt] will return true if the item was placed successfully
    if (_putItemAt(dragInfo!.managedItem.item, baseCellIndex, dragInfo!.managedItem.orientation)) {
      dragInfo = null;
      notifyListeners();
      return;
    }

    // If the base cell is occupied, try if item fits at given cell index assuming any other cell of the item
    if (_putItemAtWithOffset(dragInfo!.managedItem.item, pointedCellIndex, dragInfo!.managedItem.orientation)) {
      dragInfo = null;
      notifyListeners();
      return;
    }

    // If the item could not be placed at pointed cell, begin the swap procedure
    if (_occupiedCellIndexes.contains(pointedCellIndex)) {
      final InventoryItemManaged managedItem = _getItemByCellIndex(pointedCellIndex)!;

      removeItemWhere((item) => item.cellIndex == managedItem.cellIndex);

      // Try to put the dragged item at the cell of the item that was clicked
      if (_putItemAt(dragInfo!.managedItem.item, pointedCellIndex, dragInfo!.managedItem.orientation)) {
        // If it was successful, set the item that originally was there as the dragged item
        _createDragInfo(pointedCellIndex, managedItem, mousePosition);
      } else {
        // If it was not successful, put the original item back
        _putItemAt(managedItem.item, managedItem.cellIndex, managedItem.orientation);
      }
    }

    notifyListeners();
  }

  /// Calculates the position of the dragged item based on the mouse position and the cell offset.
  ///
  /// The mouse should be in the center of one of the cells of dragged item.
  Vector2 _calculateDraggedItemPosition() {
    final Vector2 cellOffset = dragInfo!.cellOffset;
    final Vector2 offsetCellPosition = Vector2(
      cellOffset.x * (grid.cellSize.width + grid.cellSpacing),
      cellOffset.y * (grid.cellSize.height + grid.cellSpacing),
    );

    final Vector2 cellCenterOffset = grid.cellSize.toVector2() / 2;

    return dragInfo!.mousePosition - (offsetCellPosition + cellCenterOffset);
  }

  /// Handles the mouse left button click.
  void _onLeftClick(event) {
    if (dragInfo != null) {
      _onMouseDropItem(event);
    } else {
      _onMousePickupItem(event);
    }
  }

  /// Handles the mouse right button click.
  void _onRightClick(event) {
    if (dragInfo == null) {
      return;
    }

    dragInfo!.managedItem.orientation = dragInfo!.managedItem.oppositeOrientation;
    notifyListeners();
  }
}
