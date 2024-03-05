import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/controllers/horizontally_bouncing_controller.dart';
import 'package:inventory_prototype/enviroment/entities/emoji_entity.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item.dart';
import 'package:inventory_prototype/inventory/items/moai_item.dart';
import 'package:inventory_prototype/vector2.dart';

class MoaiEntity extends EmojiEntity {
  MoaiEntity({
    required Vector2 position,
  }) : super(
          emoji: "🗿",
          size: const Size(45, 50),
          firstPosition: position,
          controller: HorizontallyBouncingController(
            speed: 10,
          ),
        );

  @override
  InventoryItem getItem() => MoaiItem();
}
