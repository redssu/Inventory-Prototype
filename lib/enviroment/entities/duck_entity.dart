import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/controllers/random_bouncing_controller.dart';
import 'package:inventory_prototype/enviroment/entities/emoji_entity.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item.dart';
import 'package:inventory_prototype/inventory/items/duck_item.dart';
import 'package:inventory_prototype/vector2.dart';

class DuckEntity extends EmojiEntity {
  DuckEntity({
    required Vector2 position,
  }) : super(
          emoji: "🦆",
          size: const Size(60, 60),
          firstPosition: position,
          controller: RandomBouncingController(
            speed: 130,
          ),
        );

  @override
  InventoryItem getItem() => DuckItem();
}
