import 'dart:ui';
import 'dart:math';

/// {@template math_util}
/// Provide some core math functions used by this library
/// {@endtemplate}
class MathUtil {
  /// default RNG
  static final random = Random();

  /// getRadians will calculate the radians of the angle between [0,1] vector and
  /// the vector of center -> point
  static double getRadians({required Offset center, required Offset point}) {
    /// determine the sign, if point is in I or II's quadrant, negative
    /// if it's in III or IV's quadrant, positive
    int sign = (point.dy - center.dy) > 0 ? 1 : -1;

    return sign * acos(
        (center.dx - point.dx) / sqrt(pow(point.dx - center.dx, 2)
            + pow(point.dy - center.dy, 2))
    );
  }
  static double getDistance({required Offset center, required Offset point}) {
    return sqrt(pow(point.dx - center.dx, 2) + pow(point.dy - center.dy, 2));
  }

  static int randInt(int max) {
    return random.nextInt(max);
  }

  static double randDouble(double max) {
    return random.nextDouble() * max;
  }
}