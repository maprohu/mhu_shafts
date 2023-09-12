part of '../shaft.dart';

ShaftContent constantStringTextShaftContent({
  @ext required String text,
}) {
  return (rectCtx) {
    return rectCtx
        .createColumnCtx()
        .textRow(
          textStyleWrap: rectCtx.defaultTextCtx().textStyleWrap,
          text: text,
        )
        .toSingleElementIterable;
  };
}
