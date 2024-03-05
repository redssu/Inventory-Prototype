import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_grid.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item.dart';

abstract class EmojiItem extends InventoryItem {
  /// The color of the item
  final Color _color;
  @override
  Color get color => _color;

  /// The size of the item
  final Size _size;
  @override
  Size get size => _size;

  /// The emoji to render
  final String emoji;

  EmojiItem({
    required this.emoji,
    required Color color,
    required Size size,
  })  : assert(size.width >= 1 && size.height >= 1, 'Size must be at least 1x1'),
        _size = size,
        _color = color;

  /// Render the item
  @override
  Widget render(BuildContext context, InventoryGrid grid) {
    return Center(
      child: Text(
        emoji,
        style: TextStyle(fontSize: grid.cellSize.width * size.shortestSide * 0.85, height: -0.005),
      ),
    );
  }
}
