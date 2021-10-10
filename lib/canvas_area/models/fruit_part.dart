import 'dart:ui';

import 'gravitational_object.dart';

class FruitPart extends GravitationalObject {
  FruitPart(
      {required this.name,
      position,
      required this.width,
      required this.height,
      required this.isLeft,
      gravitySpeed = 0.0,
      additionalForce = const Offset(0, 0),
      rotation = 0.0})
      : super(
            name: name,
            position: position,
            gravitySpeed: gravitySpeed,
            additionalForce: additionalForce,
            rotation: rotation);
  String name;
  double width;
  double height;
  bool isLeft;
}
