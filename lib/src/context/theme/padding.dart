part of '../theme.dart';

@Has()
typedef OuterHeight = double;

@Has()
typedef InnerHeight = double;

@Compose()
abstract class PaddingSizer
    implements HasEdgeInsets, HasInnerHeight, HasCallOuterHeight {}

PaddingSizer createPaddingSizer({
  required EdgeInsets edgeInsets,
  required InnerHeight innerHeight,
}) {
  late final outerHeight = innerHeight + edgeInsets.vertical;
  return ComposedPaddingSizer(
    edgeInsets: edgeInsets,
    innerHeight: innerHeight,
    callOuterHeight: () => outerHeight,
  );
}

PaddingSizer themePaddingSizer({
  @ext required ThemeWrap themeWrap,
  EdgeInsets? edgeInsets,
  required InnerHeight innerHeight,
}) {
  edgeInsets ??= themeWrap.defaultPadding;
  return createPaddingSizer(
    edgeInsets: edgeInsets,
    innerHeight: innerHeight,
  );
}

PaddingSizer themeAimWithTextPaddingSizer({
  @ext required ThemeWrap themeWrap,
  EdgeInsets? edgeInsets,
  @ext required TextStyleWrap textStyleWrap,
}) {
  edgeInsets ??= themeWrap.defaultPadding;

  final innerHeight = themeWrap.themeAimWithTextHeight(
    textStyleWrap: textStyleWrap,
  );

  return createPaddingSizer(
    edgeInsets: edgeInsets,
    innerHeight: innerHeight,
  );
}

Wx wxRectPaddingSizer({
  @ext required RectCtx rectCtx,
  @ext required PaddingSizer paddingSizer,
  required WxRectBuilder builder,
}) {
  return rectCtx
      .rectWithHeight(
        height: paddingSizer.callOuterHeight(),
      )
      .wxRectPadding(
        padding: paddingSizer.edgeInsets,
        builder: builder,
      );
}
