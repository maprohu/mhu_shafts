part of '../rect.dart';

SharingBoxes rectMessageSharingBoxes({
  @ext required RectCtx rectCtx,
  required String message,
}) {
  return rectMessageSharingBox(
    rectCtx: rectCtx,
    message: message,
  ).toSingleElementIterable;
}

SharingBox rectMessageSharingBox({
  @ext required RectCtx rectCtx,
  required String message,
}) {
  final monoTextCtx = rectCtx.defaultMonoTextCtx();
  return monoTextCtx.monoTextCtxSharingBox(
    string: message,
  );
}
