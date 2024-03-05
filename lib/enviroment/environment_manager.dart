import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/dtos/environment_settings.dart';
import 'package:inventory_prototype/enviroment/entities/base_entity.dart';
import 'package:inventory_prototype/inventory/inventory_manager.dart';

class EnvironmentManager {
  /// Whether to show the bounding boxes of the entities
  static const bool showBBoxes = false;

  /// The environment settings
  final EnvironmentSettings settings;

  /// The inventory manager
  final InventoryManager inventoryManager;

  /// The entities in the environment
  final List<BaseEntity> entites;

  const EnvironmentManager({
    required this.settings,
    required this.inventoryManager,
    this.entites = const [],
  });

  /// Initialize the environment
  void init() {
    for (final BaseEntity entity in entites) {
      entity.init(settings);
    }
  }

  /// Update the environment with the given [deltaTime]
  void update(double deltaTime) {
    for (final BaseEntity entity in entites) {
      entity.update(deltaTime);
    }
  }

  /// Render the environment
  List<Widget> build(BuildContext context) {
    return entites.map((BaseEntity entity) {
      return Positioned(
        top: entity.controller.position.y,
        left: entity.controller.position.x,
        child: GestureDetector(
          onTap: () {
            entity.onClick(this);
          },
          child: Container(
            width: entity.size.width,
            height: entity.size.height,
            decoration: BoxDecoration(
              border: showBBoxes
                  ? Border.all(
                      color: Colors.red,
                      width: 2,
                    )
                  : null,
            ),
            child: entity.render(context),
          ),
        ),
      );
    }).toList();
  }
}
