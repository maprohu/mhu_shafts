part of 'wx.dart';

typedef WxWidthBuilder = Wx Function(double width);

Wx wxFillLeft({
  @extHas required Size size,
  required WxWidthBuilder left,
  required Iterable<Wx> right,
}) {
  return wxFillAxisDirection(
    size: size,
    axisDirection: AxisDirection.left,
    fixed: right,
    fill: left,
  );
}

Wx wxFillRight({
  @extHas required Size size,
  required Iterable<Wx> left,
  required WxWidthBuilder right,
}) {
  return wxFillAxisDirection(
    size: size,
    axisDirection: AxisDirection.right,
    fixed: left,
    fill: right,
  );
}

Wx wxFillBottom({
  @extHas required Size size,
  required Iterable<Wx> top,
  required Wx Function(double height) bottom,
}) {
  return wxFillAxisDirection(
    size: size,
    axisDirection: AxisDirection.down,
    fixed: top,
    fill: bottom,
  );
}

Wx wxFillTop({
  @extHas required Size size,
  required Wx Function(double height) top,
  required Iterable<Wx> bottom,
}) {
  return wxFillAxisDirection(
    size: size,
    axisDirection: AxisDirection.up,
    fixed: bottom,
    fill: top,
  );
}

Wx wxFillAxisDirection({
  required Size size,
  required AxisDirection axisDirection,
  required Iterable<Wx> fixed,
  required Wx Function(double dimension) fill,
}) {
  final axis = axisDirectionToAxis(axisDirection);

  final reversed = axisDirectionIsReversed(axisDirection);
  final availableSpace = size.axis(axis);

  final fixedTotalDimension = fixed.totalHasSizeAxis(axis: axis);
  final fillDimension = availableSpace - fixedTotalDimension;
  if (fillDimension.isNegative) {
    return size.wxPlaceholder();
  }

  final fillWx = fill(fillDimension);

  final boxes = reversed
      ? [
          fillWx,
          ...fixed,
        ]
      : [
          ...fixed,
          fillWx,
        ];

  return wxLinear(
    children: boxes,
    axis: axis,
    size: size,
  );
}
