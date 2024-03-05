import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_grid.dart';
import 'package:inventory_prototype/inventory/enums/inventory_item_orientation.dart';

abstract class InventoryItem {
  /// The size of the item
  Size get size;

  /// The color of the item
  Color get color;

  InventoryItemOrientation get defaultOrientation => size.width.toInt() > size.height.toInt()
      ? InventoryItemOrientation.horizontal
      : InventoryItemOrientation.vertical;

  InventoryItemOrientation get defaultOppositeOrientation => defaultOrientation == InventoryItemOrientation.horizontal
      ? InventoryItemOrientation.vertical
      : InventoryItemOrientation.horizontal;

  /// Whether the item can be rotated
  bool get canBeRotated => size.width.toInt() != size.height.toInt();

  /// The total number of cells occupied by the item
  int get totalOccupiedCells => size.width.toInt() * size.height.toInt();

  /// Render the content of the item in the inventory grid
  Widget render(BuildContext context, InventoryGrid grid);

  /// Build the item widget
  Widget build(BuildContext context, {required InventoryGrid grid, bool isDragged = false}) {
    return Opacity(
      opacity: isDragged ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isDragged
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(4, 4),
                  ),
                ]
              : [],
        ),
        child: render(context, grid),
      ),
    );
  }
}
