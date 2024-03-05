import 'package:flutter/material.dart';
import 'package:inventory_prototype/vector2.dart';

extension SizeExtension on Size {
  Vector2 toVector2() => Vector2(width, height);
}
