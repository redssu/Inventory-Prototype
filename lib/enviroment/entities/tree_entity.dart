import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/controllers/standing_controller.dart';
import 'package:inventory_prototype/enviroment/entities/emoji_entity.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item.dart';
import 'package:inventory_prototype/inventory/items/tree_item.dart';
import 'package:inventory_prototype/vector2.dart';

class TreeEntity extends EmojiEntity {
  TreeEntity({
    required Vector2 position,
  }) : super(
          emoji: "🌳",
          size: const Size(100, 100),
          firstPosition: position,
          controller: StandingController(),
        );

  @override
  InventoryItem getItem() => TreeItem();
}
