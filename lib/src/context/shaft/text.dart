part of '../shaft.dart';

ShaftContent constantStringTextShaftContent({
  @ext required String text,
}) {
  return (rectCtx) {
    return rectCtx
        .defaultTextCtx()
        .wxTextHorizontal(text: text)
        .fixedVerticalSharingBox()
        .toSingleElementIterable;
  };
}
