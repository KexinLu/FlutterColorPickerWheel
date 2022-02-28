import 'dart:ui';
import 'dart:math';

/// {@template math_util}
/// Provide some core math functions used by this library
/// {@endtemplate}
class MathUtil {
  /// default RNG
  static final _random = Random();

  /// getRadians will calculate the radians of
  /// the Theta (angle) between
  /// the {(0,0),(0,1)} vector
  /// the {center, point} vector
  ///
  /// This is calculated with u.v / ||u||*||v||
  /// where u is the vector pointing from center to point
  /// and u can be considered as <point.dx - center.dx, point.dy - center.dy>
  /// v is just <0,1>
  /// thus the dot product of u and v is (point.dx - center.dx) * 1 + 0 * (point.dy - center.dy)
  /// which results in point.dx - center.dx
  /// the denominator is  length(u) * length(v)
  /// while length(v) is 1, thus denominator is length(u)
  static double getRadians({required Offset center, required Offset point}) {
    /// determine the sign, if point is in I or II's quadrant, negative
    /// if it's in III or IV's quadrant, positive
    int sign = (point.dy - center.dy) > 0 ? 1 : -1;

    return sign * acos(
        (point.dx - center.dx) /
            sqrt(pow(point.dx - center.dx, 2) + pow(point.dy - center.dy, 2))
    );
  }

  /// Not used, comment out for now
  /// TODO: double check this function and see if it can be used
  /// static double getRadiansSwipe({required Offset center, required Offset point1, required point2}) {
  ///   return acos(
  ///       ((point1.dx - center.dx) * (point2.dy - center.dy) + (point1.dy - center.dy) * (point2.dx - center.dx))
  ///           /
  ///           (sqrt(pow(point1.dx - center.dx, 2) + pow(point1.dy - center.dy, 2))
  ///               +sqrt(pow(point2.dx - center.dx, 2) + pow(point2.dy - center.dy, 2))
  ///           )
  ///   );
  /// }

  /// Generates a non-negative random integer uniformly distributed in the range
  /// from 0, inclusive,
  /// to [max], exclusive.
  /// Implementation note: The default implementation supports [max] values
  /// between 1 and (1<<32) inclusive.
  /// A wrapper around the [Random.nextInt]
  static int randInt(int max) {
    return _random.nextInt(max);
  }

  /// Generates a non-negative random floating point value uniformly distributed
  /// in the range from 0.0, inclusive
  /// to [max] exclusive
  static double randDouble(double max) {
    return _random.nextDouble() * max;
  }
}