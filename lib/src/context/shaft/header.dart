part of '../shaft.dart';

TextCtx shaftHeaderLabelText({
  @ext required RectCtx rectCtx,
}) {
  return createTextCtx(
    rectCtx: rectCtx,
    textStyleWrap: rectCtx.renderCtxThemeWrap().shaftHeaderTextStyleWrap,
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
