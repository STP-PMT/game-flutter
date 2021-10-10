import 'dart:ui';

import 'gravitational_object.dart';

class Fruit extends GravitationalObject {
  Fruit(
      {required this.name,
      position,
      required this.width,
      required this.height,
      gravitySpeed = 0.0,
      additionalForce = const Offset(0, 0),
      rotation = 0.25})
      : super(
            name: name,
            position: position,
            gravitySpeed: gravitySpeed,
            additionalForce: additionalForce,
            rotation: rotation);
  String name;
  double width;
  double height;

  bool isPointInside(Offset point) {
    if (point.dx < position.dx) {
      return false;
    }

    if (point.dx > position.dx + width) {
      return false;
    }

    if (point.dy < position.dy) {
      return false;
    }

    if (point.dy > position.dy + height) {
      return false;
    }

    return true;
  }
}
