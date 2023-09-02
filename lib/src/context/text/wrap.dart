part of '../text.dart';

@Has()
typedef TextHeight = double;

@Has()
@Compose()
abstract class TextStyleWrap implements HasTextStyle, HasCallTextHeight {}

TextStyleWrap wrapTextStyle({
  @ext required TextStyle textStyle,
}) {
  late final textHeight = mdiTextSize('M', textStyle).height;
  return ComposedTextStyleWrap(
    textStyle: textStyle,
    callTextHeight: () => textHeight,
  );
}

TextStyle textStyleUnwrap({
  @extHas required TextStyleWrap textStyleWrap,
}) {
  return textStyleWrap.textStyle;
}

TextStyleWrap textStyleWrapWithColor({
  @ext required TextStyleWrap textStyleWrap,
  required Color color,
}) {
  return textStyleWrap.textStyleWrapWithTextStyle(
    textStyleWrap.textStyle.copyWith(
      color: color,
    ),
  );
}

TextStyleWrap textStyleWrapWithFontSize({
  @ext required TextStyleWrap textStyleWrap,
  required double fontSize,
}) {
  return textStyleWrap.textStyle
      .copyWith(
        fontSize: fontSize,
      )
      .wrapTextStyle();
}
