part of '../rect.dart';

Wx wxRectPadding({
  @ext required RectCtx rectCtx,
  required EdgeInsets padding,
  required WxRectBuilder builder,
}) {
  final innerSize = padding.deflateSize(rectCtx.size);

  if (innerSize.sizeIsNegative()) {
    return rectCtx.wxPlaceholder();
  }

  final childWx = builder(
    rectCtx.createRectCtx(
      size: innerSize,
    ),
  );

  assert(
    sizeRoughlyEqual(
      innerSize,
      childWx.size,
    ),
  );

  return Padding(
    padding: padding,
    child: childWx.widget,
  ).createWx(
    size: rectCtx.size,
  );
}
