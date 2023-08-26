part of '../text.dart';

TextSpan createTextSpan(
  @ext String text,
  @extHas TextStyle textStyle,
) {
  return TextSpan(
    text: text,
    style: textStyle,
  );
}

RichText createRichText({
  @ext required TextSpan textSpan,
}) {
  return RichText(
    text: textSpan,
    softWrap: false,
    overflow: TextOverflow.visible,
    maxLines: 1,
  );
}
