part of '../rect.dart';

Wx wxRectFillRight({
  @ext required RectCtx rectCtx,
  required Iterable<Wx> left,
  required WxRectBuilder right,
}) {
  return rectCtx.wxFillRight(
    right: (width) {
      return right(
        rectCtx.rectWithWidth(
          width: width,
        ),
      );
    },
    left: left,
  );
}

Wx wxRectFillLeft({
  @ext required RectCtx rectCtx,
  required WxRectBuilder left,
  required Iterable<Wx> right,
}) {
  return rectCtx.wxFillLeft(
    left: (width) {
      return left(
        rectCtx.rectWithWidth(
          width: width,
        ),
      );
    },
    right: right,
  );
}

Wx wxRectFillBottom({
  @ext required RectCtx rectCtx,
  required Iterable<Wx> top,
  required WxRectBuilder bottom,
}) {
  return rectCtx.wxFillBottom(
    top: top,
    bottom: (height) {
      return bottom(
        rectCtx.rectWithHeight(
          height: height,
        ),
      );
    },
  );
}

Wx wxRectFillTop({
  @ext required RectCtx rectCtx,
  required WxRectBuilder top,
  required Iterable<Wx> bottom,
}) {
  return rectCtx.wxFillTop(
    bottom: bottom,
    top: (height) {
      return top(
        rectCtx.rectWithHeight(
          height: height,
        ),
      );
    },
  );
}
