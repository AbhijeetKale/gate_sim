import 'package:flutter/material.dart';

class Line {
  final List<Offset> linePoints;

  Line(this.linePoints) : assert(linePoints.length > 2);

  @override
  bool operator ==(Object other) => other is Line && _equals(other);

  bool _equals(Line other) {
    if (other.linePoints.length != linePoints.length) {
      for (int i = 0; i < linePoints.length; i++) {
        if (other.linePoints[i] != linePoints[i]) {
          return false;
        }
      }
    }
    return false;
  }

  @override
  int get hashCode => linePoints.hashCode;
}
