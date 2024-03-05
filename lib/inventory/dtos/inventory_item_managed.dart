import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/enums/inventory_item_orientation.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_grid.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item.dart';

class InventoryItemManaged {
  final InventoryItem item;

  /// The orientation of the item
  InventoryItemOrientation orientation;
  InventoryItemOrientation get oppositeOrientation => orientation == InventoryItemOrientation.vertical
      ? InventoryItemOrientation.horizontal
      : InventoryItemOrientation.vertical;

  /// The index of the cell where the item is placed
  int cellIndex;

  InventoryItemManaged({
    required this.item,
    required this.cellIndex,
    InventoryItemOrientation? orientation,
  })  : assert(cellIndex >= 0),
        orientation = orientation ?? item.defaultOrientation;

  /// Returns size of the item (in cells) based on its orientation
  Size get itemSize => orientation == item.defaultOrientation ? item.size : item.size.flipped;

  /// Returns the size in pixels of the item in the inventory grid
  Size getRealSize(InventoryGrid grid) {
    return Size(
      itemSize.width * grid.cellSize.width + (itemSize.width - 1) * grid.cellSpacing,
      itemSize.height * grid.cellSize.height + (itemSize.height - 1) * grid.cellSpacing,
    );
  }
}
