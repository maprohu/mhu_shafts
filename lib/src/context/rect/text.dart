part of '../rect.dart';

SharingBoxes rectMonoTextSharingBoxes({
  @ext required RectCtx rectCtx,
  required String text,
}) {
  return rectMonoTextSharingBox(
    rectCtx: rectCtx,
    text: text,
  ).toSingleElementIterable;
}

SharingBox rectMonoTextSharingBox({
  @ext required RectCtx rectCtx,
  required String text,
}) {
  final monoTextCtx = rectCtx.defaultMonoTextCtx();
  return monoTextCtx.monoTextCtxSharingBox(
    string: text,
  );
}
