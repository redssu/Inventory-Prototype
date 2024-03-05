import 'package:inventory_prototype/enviroment/controllers/entity_controller.dart';
import 'package:inventory_prototype/enviroment/entities/base_entity.dart';
import 'package:inventory_prototype/vector2.dart';

class EdgeTeleportingController extends EntityController {
  static const int safeEdgeMargin = 5;

  double speed;
  Vector2 direction = Vector2.random()..normalize();

  EdgeTeleportingController({required this.speed});

  @override
  void update({required double deltaTime, required BaseEntity controlledEntity}) {
    super.update(deltaTime: deltaTime, controlledEntity: controlledEntity);

    position = position + (direction * speed * deltaTime);

    if (_isAtLeftEdge()) {
      position = Vector2(environmentSettings.size.width - controlledEntity.size.width - safeEdgeMargin, position.y);
    }

    if (_isAtRightEdge()) {
      position = Vector2(safeEdgeMargin, position.y);
    }

    if (_isAtTopEdge()) {
      position = Vector2(position.x, environmentSettings.size.height - controlledEntity.size.height - safeEdgeMargin);
    }

    if (_isAtBottomEdge()) {
      position = Vector2(position.x, safeEdgeMargin);
    }
  }

  bool _isAtLeftEdge() {
    return position.x < 0;
  }

  bool _isAtRightEdge() {
    return position.x + controlledEntity.size.width > environmentSettings.size.width;
  }

  bool _isAtTopEdge() {
    return position.y < 0;
  }

  bool _isAtBottomEdge() {
    return position.y + controlledEntity.size.height > environmentSettings.size.height;
  }
}
