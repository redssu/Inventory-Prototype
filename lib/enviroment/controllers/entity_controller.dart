import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/dtos/environment_settings.dart';
import 'package:inventory_prototype/enviroment/entities/base_entity.dart';
import 'package:inventory_prototype/vector2.dart';

typedef MoveFunction = void Function(Vector2 position);

abstract class EntityController {
  /// The environment settings
  late final EnvironmentSettings environmentSettings;

  /// The controlled entity
  late BaseEntity controlledEntity;

  /// The position of the controlled entity
  late Vector2 position;

  /// Initialize the Controller
  @mustCallSuper
  void init({
    required BaseEntity controlledEntity,
    required Vector2 position,
    required EnvironmentSettings environmentSettings,
  }) {
    this.controlledEntity = controlledEntity;
    this.position = position;
    this.environmentSettings = environmentSettings;
  }

  /// Update the Controller with the given delta time
  @mustCallSuper
  void update({
    required double deltaTime,
    required BaseEntity controlledEntity,
  }) {
    this.controlledEntity = controlledEntity;
  }
}
