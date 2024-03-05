import 'package:flutter/material.dart';
import 'package:inventory_prototype/main.dart';
import 'package:inventory_prototype/vector2.dart';

class InventoryGrid {
  final int rows;
  final int columns;

  final Size cellSize;
  final int cellSpacing;

  final Offset inventoryPosition;
  final bool centered;

  final int trashCanSpacing;
  final Size trashCanSize;

  const InventoryGrid({
    required this.rows,
    required this.columns,
    this.cellSpacing = 16,
    this.cellSize = const Size(64, 64),
    this.inventoryPosition = const Offset(0, 0),
    this.centered = false,
    this.trashCanSpacing = 72,
    this.trashCanSize = const Size(72, 72),
  })  : assert(rows > 0),
        assert(columns > 0),
        assert(cellSpacing >= 0);

  int get totalWidth => (cellSize.width.toInt() * columns) + (cellSpacing * (columns - 1));
  int get totalHeight => (cellSize.height.toInt() * rows) + (cellSpacing * (rows - 1));

  int get cellsCount => rows * columns;

  Vector2 get inventoryCalculatedPosition => centered
      ? Vector2(
          (kScreenWidth / 2) - (totalWidth / 2) + inventoryPosition.dx,
          (kScreenHeight / 2) - (totalHeight / 2) + inventoryPosition.dy,
        )
      : Vector2(inventoryPosition.dx, inventoryPosition.dy);

  Vector2 get trashCanCalculatedPosition => Vector2(
        inventoryCalculatedPosition.x + totalWidth + trashCanSpacing,
        inventoryCalculatedPosition.y + (totalHeight / 2) - (trashCanSize.longestSide / 2),
      );
}
