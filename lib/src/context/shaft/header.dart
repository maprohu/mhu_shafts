part of '../shaft.dart';

TextCtx shaftHeaderLabelText({
  @ext required RectCtx rectCtx,
}) {
  return createTextCtx(
    rectCtx: rectCtx,
    textStyle: rectCtx.renderObj.themeWrap.shaftHeaderTextStyle,
  );
}

Wx wxShaftHeaderLabelString({
  @ext required RectCtx rectCtx,
  required String label,
}) {
  return rectCtx.shaftHeaderLabelText().wxTextAlign(
        text: label,
        alignmentGeometry: Alignment.centerLeft,
      );
}
