import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item_managed.dart';
import 'package:inventory_prototype/inventory/enums/inventory_item_orientation.dart';
import 'package:inventory_prototype/vector2.dart';

class InventoryDragInfo with ChangeNotifier {
  final InventoryItemManaged managedItem;

  Vector2 mousePosition;

  final Map<InventoryItemOrientation, Vector2> cellOffsets;
  Vector2 get cellOffset => cellOffsets[managedItem.orientation]!;

  InventoryDragInfo({
    required this.managedItem,
    required this.cellOffsets,
    this.mousePosition = const Vector2.zero(),
  });

  void updatePosition(Offset position) {
    mousePosition = Vector2(position.dx, position.dy);
    notifyListeners();
  }
}
