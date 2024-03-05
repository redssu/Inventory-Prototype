import 'dart:math';

class Vector2 {
  /// The x component of the vector.
  final double x;

  /// The y component of the vector.
  final double y;

  /// Returns the length of the vector.
  double get length => sqrt(x * x + y * y);

  /// Creates a vector from a x and y value.
  Vector2([num x = 0, num y = 0])
      : x = x.toDouble(),
        y = y.toDouble();

  /// Creates a vector from a zero value.
  const Vector2.zero()
      : x = 0,
        y = 0;

  /// Creates a vector from a random value.
  Vector2.random()
      : x = 2 * Random().nextDouble() - 1,
        y = 2 * Random().nextDouble() - 1;

  /// Creates a vector from a degree.
  Vector2.fromDegree(int degree)
      : x = cos(-degree * pi / 180),
        y = sin(-degree * pi / 180);

  /// Normalizes the vector.
  Vector2 normalize() {
    final double length = this.length;

    return Vector2(
      x / length,
      y / length,
    );
  }

  /// Sets the x component of the vector.
  Vector2 setX(num x) => Vector2(x, y);

  /// Sets the y component of the vector.
  Vector2 setY(num y) => Vector2(x, y);

  /// Returns the angle in degrees of this vector.
  int get degree => -(180 * atan2(y, x) / pi).round();

  /// Adds the other vector to this vector.
  operator +(Vector2 other) {
    return Vector2(x + other.x, y + other.y);
  }

  /// Substracts the other vector from this vector.
  operator -(Vector2 other) {
    return Vector2(x - other.x, y - other.y);
  }

  /// Multiplies the vector by a scalar.
  operator *(num scalar) {
    return Vector2(x * scalar, y * scalar);
  }

  /// Divides the vector by a scalar.
  operator /(num scalar) {
    return Vector2(
      (x ~/ scalar).toDouble(),
      (y ~/ scalar).toDouble(),
    );
  }

  /// Checks if the vector is equal to the other vector.
  @override
  operator ==(Object other) {
    return other is Vector2 && x == other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => "Vector2($x, $y)";
}
