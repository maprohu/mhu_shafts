part of '../rect.dart';

Wx wxRectColumnExact({
  @ext required RectCtx rectCtx,
  required Iterable<Wx> children,
}) {
  return wxColumn(
    children: children,
    size: rectCtx.size,
  );
}
