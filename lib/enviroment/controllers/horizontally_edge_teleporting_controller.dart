import 'package:inventory_prototype/enviroment/controllers/edge_teleporting_controller.dart';
import 'package:inventory_prototype/enviroment/entities/base_entity.dart';
import 'package:inventory_prototype/vector2.dart';

class HorizontallyEdgeTeleportingController extends EdgeTeleportingController {
  HorizontallyEdgeTeleportingController({required double speed}) : super(speed: speed);

  @override
  void update({required double deltaTime, required BaseEntity controlledEntity}) {
    super.update(deltaTime: deltaTime, controlledEntity: controlledEntity);

    direction = Vector2(direction.x, 0);
  }
}
