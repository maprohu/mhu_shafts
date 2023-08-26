import 'package:flutter/material.dart';

class Paddings {
  static EdgeInsets topLeft({
    required Size outer,
    required Size inner,
  }) {
    return EdgeInsets.only(
      right: outer.width - inner.width,
      bottom: outer.height - inner.height,
    );
  }

  static EdgeInsets centerLeft({
    required Size outer,
    required Size inner,
  }) {
    final vertical = (outer.height - inner.height) / 2;
    return EdgeInsets.only(
      right: outer.width - inner.width,
      top: vertical,
      bottom: vertical,
    );
  }

  static EdgeInsets top({
    required double outer,
    required double inner,
  }) {
    return EdgeInsets.only(
      bottom: outer - inner,
    );
  }

  static EdgeInsets left({
    required double outer,
    required double inner,
  }) {
    return EdgeInsets.only(
      right: outer - inner,
    );
  }

  static EdgeInsets centerY({
    required double outer,
    required double inner,
  }) {
    return EdgeInsets.symmetric(
      vertical: (outer - inner) / 2,
    );
  }

  static EdgeInsets centerX({
    required double outer,
    required double inner,
  }) {
    return EdgeInsets.symmetric(
      horizontal: (outer - inner) / 2,
    );
  }

  static EdgeInsets start({
    required Axis axis,
    required double outer,
    required double inner,
  }) {
    return switch (axis) {
      Axis.horizontal => left(
          outer: outer,
          inner: inner,
        ),
      Axis.vertical => top(
          outer: outer,
          inner: inner,
        ),
    };
  }
}

extension PaddingsEdgeInsetsX on EdgeInsets {
  bool get isZero => left == 0 && right == 0 && top == 0 && bottom == 0;
}
