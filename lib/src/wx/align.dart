part of 'wx.dart';

@Has()
class AxisAlignment {
  final double value;

  const AxisAlignment({
    required this.value,
  }) : assert(value >= -1.0 && value <= 1.0);

  static const start = AxisAlignment(value: -1);
  static const center = AxisAlignment(value: 0);
  static const end = AxisAlignment(value: 1);

  static const left = start;
  static const top = start;
  static const right = end;
  static const bottom = end;
}

typedef AlignmentMargin = ({
  double start,
  double end,
});

Alignment axisAlignmentGeometry({
  @extHas required Axis axis,
  @extHas required AxisAlignment axisAlignment,
}) {
  return switch (axis) {
    Axis.horizontal => Alignment(
        axisAlignment.value,
        0,
      ),
    Axis.vertical => Alignment(
        0,
        axisAlignment.value,
      ),
  };
}

Alignment alignmentGeometryWithAxis({
  @Has() required Alignment alignmentGeometry,
  @extHas required Axis axis,
  @extHas required AxisAlignment axisAlignment,
}) {
  return switch (axis) {
    Axis.horizontal => Alignment(
        axisAlignment.value,
        alignmentGeometry.y,
      ),
    Axis.vertical => Alignment(
        alignmentGeometry.x,
        axisAlignment.value,
      ),
  };
}

Wx wxAlignVertical({
  @Ext() required Wx wx,
  @extHas required Size size,
  AxisAlignment axisAlignment = AxisAlignment.center,
}) {
  return wxAlign(
    wx: wx,
    size: size,
    vertical: axisAlignment,
    horizontal: null,
  );
}

Wx wxAlign({
  @Ext() required Wx wx,
  @extHas required Size size,
  required AxisAlignment? vertical,
  required AxisAlignment? horizontal,
}) {
  if (vertical != null && horizontal != null) {
    final sizeDifference = size - wx.size;
    if (sizeDifference >= Offset.zero) {
      return wxSizedBox(
        widget: Align(
          alignment: Alignment(
            horizontal.value,
            vertical.value,
          ),
          child: wx.widget,
        ),
        size: size,
      );
    } else {
      return size.wxPlaceholder();
    }
  }

  if (vertical != null) {
    wx = wxAlignAxis(
      wx: wx,
      size: size,
      axis: Axis.vertical,
      axisAlignment: vertical,
    );
  }

  if (horizontal != null) {
    wx = wxAlignAxis(
      wx: wx,
      size: size,
      axis: Axis.horizontal,
      axisAlignment: horizontal,
    );
  }

  return wx;
}

Wx wxAlignAxis({
  @Ext() required Wx wx,
  required Size size,
  required Axis axis,
  required AxisAlignment axisAlignment,
}) {
  final outerDimension = size.sizeAxisDimension(axis: axis);
  final innerDimension = wx.sizeAxisDimension(axis: axis);
  final resultSize = wx.sizeWithAxisDimension(
    axis: axis,
    dimension: outerDimension,
  );
  final extraSpace = outerDimension - innerDimension;
  if (extraSpace < 0) {
    return resultSize.wxPlaceholder();
  } else {
    return sizedBoxAxis(
      child: Align(
        alignment: axisAlignmentGeometry(
          axis: axis,
          axisAlignment: axisAlignment,
        ),
        child: wx.widget,
      ),
      axis: axis,
      dimension: outerDimension,
    ).createWx(
      size: resultSize,
    );
  }
}
