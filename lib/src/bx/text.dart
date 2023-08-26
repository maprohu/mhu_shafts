import 'package:flutter/material.dart';
import 'package:mhu_shafts/src/bx/boxed.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

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

  Bx leaf([Size? size]) => Bx.leaf(
        size: size ?? this.size,
        widget: RichText(
          text: this,
        ),
      );
}

Size mdiTextSize(String text, TextStyle style) {
  return TextSpan(
    text: text,
    style: style,
  ).size;
}

Bx textBx({
  required String text,
  required TextStyle style,
}) {
  final textSpan = TextSpan(
    text: text,
    style: style,
  );

  return Bx.leaf(
    size: textSpan.size,
    widget: RichText(
      text: textSpan,
    ),
  );
}

Bx bxFlexibleText({
  required double maxWidth,
  required String text,
  required TextStyle style,
  required Bx Function(double height) splitMarker,
}) {
  final textSpan = TextSpan(
    text: text,
    style: style,
  );

  final textSpanSize = textSpan.size;

  if (textSpanSize.width <= maxWidth) {
    return Bx.leaf(
      size: textSpanSize,
      widget: RichText(
        text: textSpan,
        softWrap: false,
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    );
  } else {
    final split = splitMarker(textSpanSize.height);
    final splitWidth = split.width;
    final halfWidth = (maxWidth - split.width) / 2;

    final halfSize = textSpanSize.withWidth(halfWidth);

    final colorsAndStops = halfWidth < splitWidth
        ? (
            colors: [Colors.transparent, Colors.white],
            stops: [0.0, 1.0],
          )
        : (
            colors: [Colors.transparent, Colors.transparent, Colors.white],
            stops: [0.0, halfWidth / (halfWidth + splitWidth), 1.0],
          );

    Widget halfWidget({
      required bool start,
    }) {
      final widget = ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: start ? Alignment.centerLeft : Alignment.centerRight,
          child: RichText(
            text: textSpan,
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ),
      );

      var (begin, end) = (Alignment.centerLeft, Alignment.centerRight);
      if (!start) {
        (begin, end) = (end, begin);
      }

      return ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: begin,
            end: end,
            colors: colorsAndStops.colors,
            stops: colorsAndStops.stops,
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut,
        child: widget,
      );
    }

    return Bx.row(
      columns: [
        Bx.leaf(
          size: halfSize,
          widget: halfWidget(start: true),
        ),
        split,
        Bx.leaf(
          size: halfSize,
          widget: halfWidget(start: false),
        ),
      ],
      size: textSpanSize.withWidth(maxWidth),
    );
  }
}
