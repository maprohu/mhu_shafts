part of '../rect.dart';

SharingBox fixedSharingBoxRectVertical({
  @ext required RectCtx rectCtx,
  required Wx wx,
  AxisAlignment horizontalAlignment = AxisAlignment.left,
}) {
  return fixedVerticalSharingBox(
    wx.wxAlignAxis(
      size: rectCtx.size,
      axis: Axis.horizontal,
      axisAlignment: horizontalAlignment,
    ),
  );
}
