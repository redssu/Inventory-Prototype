import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/controllers/entity_controller.dart';
import 'package:inventory_prototype/enviroment/dtos/environment_settings.dart';
import 'package:inventory_prototype/enviroment/environment_manager.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_item.dart';
import 'package:inventory_prototype/vector2.dart';

abstract class BaseEntity {
  /// The size of the entity
  Size size = const Size(0, 0);

  /// The controller of the entity
  final EntityController controller;

  /// The first position of the entity
  final Vector2 firstPosition;

  BaseEntity({
    required this.size,
    required this.controller,
    required this.firstPosition,
  });

  /// Initialize the entity
  @mustCallSuper
  void init(EnvironmentSettings environmentSettings) {
    controller.init(
      controlledEntity: this,
      position: firstPosition,
      environmentSettings: environmentSettings,
    );
  }

  /// Update the entity with the given [deltaTime]
  @mustCallSuper
  void update(double deltaTime) {
    controller.update(deltaTime: deltaTime, controlledEntity: this);
  }

  /// Handle the click event
  @mustCallSuper
  void onClick(EnvironmentManager environmentManager) {
    environmentManager.inventoryManager.addItem(getItem());
    environmentManager.entites.remove(this);
  }

  /// Render the entity
  Widget render(BuildContext context);

  /// Get item representation of the entity
  InventoryItem getItem();
}
