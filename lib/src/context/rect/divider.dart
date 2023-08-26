part of '../rect.dart';

Wx wxRectDivider({
  @ext required RectCtx rectCtx,
  required Axis layoutAxis,
  required double thickness,
}) {
  return wxDivider(
    rectSize: rectCtx.size,
    layoutAxis: layoutAxis,
    thickness: thickness,
    themeWrap: rectCtx.themeWrapRender(),
  );
}

Wx wxRectVerticalLayoutDivider({
  @ext required RectCtx rectCtx,
  required double thickness,
}) {
  return wxRectDivider(
    rectCtx: rectCtx,
    layoutAxis: Axis.vertical,
    thickness: thickness,
  );
}

Wx wxRectHorizontalLayoutDivider({
  @ext required RectCtx rectCtx,
  required double thickness,
}) {
  return wxRectDivider(
    rectCtx: rectCtx,
    layoutAxis: Axis.horizontal,
    thickness: thickness,
  );
}
