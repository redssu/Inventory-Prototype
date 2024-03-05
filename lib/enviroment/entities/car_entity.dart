import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/controllers/horizontally_bouncing_controller.dart';
import 'package:inventory_prototype/enviroment/entities/emoji_entity.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item.dart';
import 'package:inventory_prototype/inventory/items/car_item.dart';
import 'package:inventory_prototype/vector2.dart';

class CarEntity extends EmojiEntity {
  CarEntity({
    required Vector2 position,
  }) : super(
          emoji: "🏎️",
          size: const Size(45, 50),
          firstPosition: position,
          controller: HorizontallyBouncingController(
            speed: 200,
          ),
        );

  @override
  InventoryItem getItem() => CarItem();
}
