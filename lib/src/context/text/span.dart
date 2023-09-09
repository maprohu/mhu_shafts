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

Size mdiTextSize(String text, TextStyle style) {
  return TextSpan(
    text: text,
    style: style,
  ).size;
}
extension SizedTextSpanX on TextSpan {
  Size get size {
    final TextPainter textPainter = TextPainter(
      text: this,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
    return textPainter.size;
  }

  Size wrapSize(double width) {
    final TextPainter textPainter = TextPainter(
      text: this,
      textDirection: TextDirection.ltr,
    )..layout(
      minWidth: 0,
      maxWidth: width,
    );
    return textPainter.size;
  }

}
