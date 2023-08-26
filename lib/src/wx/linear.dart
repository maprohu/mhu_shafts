part of 'wx.dart';

Iterable<Widget> wxWidgets({
  @Ext() required Iterable<Wx> children,
}) {
  return children.map((e) => e.widget);
}

Wx wxLinear({
  required Iterable<Wx> children,
  required Axis axis,
  required Size? size,
}) {
  size ??= children.first.size.sizeWithAxisDimension(
    axis: axis,
    dimension: children.totalHasSizeAxis(axis: axis),
  );

  assert(
    doubleRoughlyEqual(
      children.totalHasSizeAxis(axis: axis),
      size.sizeAxisDimension(
        axis: axis,
      ),
    ),
  );

  assert(
    assertDoublesRoughlyEqual(
      children.map(
        (e) => e.sizeAxisDimension(
          axis: axis.flip,
        ),
      ),
    ),
  );

  return Flex(
    direction: axis,
    children: children.wxWidgets().toList(),
  ).createWx(
    size: size,
  );
}

Wx wxRow({
  required Iterable<Wx> children,
  required Size? size,
}) {
  return wxLinear(
    children: children,
    axis: Axis.horizontal,
    size: size,
  );
}

Wx wxColumn({
  required Iterable<Wx> children,
  required Size? size,
}) {
  return wxLinear(
    children: children,
    axis: Axis.vertical,
    size: size,
  );
}
