import 'package:inventory_prototype/enviroment/controllers/bouncing_controller.dart';
import 'package:inventory_prototype/enviroment/entities/base_entity.dart';
import 'package:inventory_prototype/vector2.dart';

class HorizontallyBouncingController extends BouncingController {
  HorizontallyBouncingController({required double speed}) : super(speed: speed);

  @override
  void update({required double deltaTime, required BaseEntity controlledEntity}) {
    super.update(deltaTime: deltaTime, controlledEntity: controlledEntity);

    direction = Vector2(direction.x, 0);
  }
}
