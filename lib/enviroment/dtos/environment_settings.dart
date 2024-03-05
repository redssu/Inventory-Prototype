import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inventory_prototype/vector2.dart';

class EnvironmentSettings {
  static const int safeRandomMargin = 60;

  final Size size;

  const EnvironmentSettings({
    required this.size,
  });

  Vector2 randomPosition() {
    return Vector2(
      (size.width - safeRandomMargin * 2) * Random().nextDouble() + safeRandomMargin,
      (size.height - safeRandomMargin * 2) * Random().nextDouble() + safeRandomMargin,
    );
  }
}
