import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/controllers/entity_controller.dart';
import 'package:inventory_prototype/enviroment/entities/emoji_entity.dart';
import 'package:inventory_prototype/vector2.dart';

abstract class RandomEmojiEntity extends EmojiEntity {
  RandomEmojiEntity({
    required List<String> emoji,
    required Size size,
    required Vector2 firstPosition,
    required EntityController controller,
  }) : super(
          emoji: emoji[Random().nextInt(emoji.length)],
          size: size,
          firstPosition: firstPosition,
          controller: controller,
        );
}
