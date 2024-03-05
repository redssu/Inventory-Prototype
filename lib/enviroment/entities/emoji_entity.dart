import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/controllers/entity_controller.dart';
import 'package:inventory_prototype/enviroment/entities/base_entity.dart';
import 'package:inventory_prototype/vector2.dart';

abstract class EmojiEntity extends BaseEntity {
  /// The emoji to render
  final String emoji;

  EmojiEntity({
    required this.emoji,
    required Size size,
    required Vector2 firstPosition,
    required EntityController controller,
  }) : super(
          size: size,
          firstPosition: firstPosition,
          controller: controller,
        );

  /// Render the entity
  @override
  Widget render(BuildContext context) {
    return Center(
      child: Text(
        emoji,
        style: TextStyle(fontSize: size.height * 0.85, height: -0.005),
      ),
    );
  }
}
