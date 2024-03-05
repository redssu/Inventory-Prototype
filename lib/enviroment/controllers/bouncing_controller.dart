import 'package:inventory_prototype/enviroment/controllers/entity_controller.dart';
import 'package:inventory_prototype/enviroment/entities/base_entity.dart';
import 'package:inventory_prototype/vector2.dart';

class BouncingController extends EntityController {
  double speed;
  Vector2 direction = Vector2.random()..normalize();

  BouncingController({required this.speed});

  @override
  void update({required double deltaTime, required BaseEntity controlledEntity}) {
    super.update(deltaTime: deltaTime, controlledEntity: controlledEntity);

    position = position + (direction * speed * deltaTime);

    if (_isAtHorizontalEdge()) {
      direction = Vector2(-direction.x, direction.y);
    }

    if (_isAtVerticalEdge()) {
      direction = Vector2(direction.x, -direction.y);
    }
  }

  bool _isAtHorizontalEdge() {
    return position.x < 0 || position.x + controlledEntity.size.width > environmentSettings.size.width;
  }

  bool _isAtVerticalEdge() {
    return position.y < 0 || position.y + controlledEntity.size.height > environmentSettings.size.height;
  }
}
