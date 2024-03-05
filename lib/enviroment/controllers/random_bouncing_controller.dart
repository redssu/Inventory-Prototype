import 'dart:math';

import 'package:inventory_prototype/enviroment/controllers/bouncing_controller.dart';
import 'package:inventory_prototype/enviroment/entities/base_entity.dart';
import 'package:inventory_prototype/vector2.dart';

class RandomBouncingController extends BouncingController {
  int frameCount = 0;

  RandomBouncingController({required double speed}) : super(speed: speed);

  @override
  void update({required double deltaTime, required BaseEntity controlledEntity}) {
    super.update(deltaTime: deltaTime, controlledEntity: controlledEntity);

    frameCount++;

    if (frameCount % 60 == 0) {
      direction = Vector2.fromDegree(direction.degree + ((0.5 - Random().nextDouble()) * 45).toInt()).normalize();
    }
  }
}
