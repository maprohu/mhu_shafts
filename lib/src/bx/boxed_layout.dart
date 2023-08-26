part of 'boxed.dart';

double bxTotalWidth({
  @Ext() required Iterable<Bx> boxes,
}) {
  return boxes.bxTotalAxis(
    axis: Axis.horizontal,
  );
}

double bxTotalAxis({
  @Ext() required Iterable<Bx> boxes,
  required Axis axis,
}) {
  return boxes.sumByDouble((item) => item.size.axis(axis));
}

Bx bxPlaceholder({
  required Size size,
}) {
  return Bx.leaf(
    size: size,
    widget: const Placeholder(),
  );
}


Bx bxFillLeft({
  required Size size,
  required Bx Function(double width) left,
  required Iterable<Bx> right,
}) {
  return bxFillAxisDirection(
    size: size,
    axisDirection: AxisDirection.left,
    fixed: right,
    fill: left,
  );
}

Bx bxFillBottom({
  required Size size,
  required Iterable<Bx> top,
  required Bx Function(double height) bottom,
}) {
  return bxFillAxisDirection(
    size: size,
    axisDirection: AxisDirection.down,
    fixed: top,
    fill: bottom,
  );
}

Bx bxFillAxisDirection({
  required Size size,
  required AxisDirection axisDirection,
  required Iterable<Bx> fixed,
  required Bx Function(double dimension) fill,
}) {
  final axis = axisDirectionToAxis(axisDirection);

  final reversed = axisDirectionIsReversed(axisDirection);
  final availableSpace = size.axis(axis);

  final fixedTotalDimension = fixed.bxTotalAxis(axis: axis);
  final fillDimension = availableSpace - fixedTotalDimension;
  if (fillDimension.isNegative) {
    return bxPlaceholder(size: size);
  }

  final fillBx = fill(fillDimension);

  final boxes = reversed
      ? [
          fillBx,
          ...fixed,
        ]
      : [
          ...fixed,
          fillBx,
        ];

  return bxFlex(
    boxes: boxes,
    axis: axis,
    size: size,
  );
}

Bx bxFlex({
  required List<Bx> boxes,
  required Axis axis,
  required Size size,
}) {
  return switch (axis) {
    Axis.horizontal => Bx.row(columns: boxes, size: size),
    Axis.vertical => Bx.col(rows: boxes, size: size),
  };
}

