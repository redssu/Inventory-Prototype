import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/controllers/horizontally_edge_teleporting_controller.dart';
import 'package:inventory_prototype/enviroment/entities/random_emoji_entity.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item.dart';
import 'package:inventory_prototype/inventory/items/cloud_item.dart';
import 'package:inventory_prototype/vector2.dart';

class CloudEntity extends RandomEmojiEntity {
  CloudEntity({
    required Vector2 position,
  }) : super(
          emoji: ["🌤️", "🌥️", "⛅️", "⛅️", "🌦️", "🌧️", "🌨️", "🌩️"],
          size: const Size(45, 50),
          firstPosition: position,
          controller: HorizontallyEdgeTeleportingController(
            speed: Random().nextInt(20) + 20,
          ),
        );

  @override
  InventoryItem getItem() => CloudItem(emoji: emoji);
}
