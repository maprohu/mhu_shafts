part of '../text.dart';

class TextStyleWrap with MixTextStyle {
  late final textHeight = mdiTextSize('M', textStyle).height;
}

TextStyleWrap textStyleWrap({
  @ext required TextStyle textStyle,
}) {
  return TextStyleWrap()..textStyle = textStyle;
}
