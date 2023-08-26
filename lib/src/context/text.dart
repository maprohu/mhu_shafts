import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../bx/text.dart';
import '../wx/wx.dart';
import 'text.dart' as $lib;

part 'text.g.has.dart';

part 'text.g.dart';

part 'text/mono.dart';

part 'text/span.dart';

@Compose()
abstract class TextCtx implements RectCtx, HasTextStyle {}

TextCtx createTextCtx({
  @ext required RectCtx rectCtx,
  required TextStyle textStyle,
}) {
  return ComposedTextCtx.rectCtx(
    rectCtx: rectCtx,
    textStyle: textStyle,
  );
}

Wx wxTextAlign({
  @Ext() required TextCtx textCtx,
  required String text,
  required Alignment alignmentGeometry,
}) {
  return textCtx.wxText(
    text: text,
    vertical: AxisAlignment(value: alignmentGeometry.y),
    horizontal: AxisAlignment(value: alignmentGeometry.x),
  );
}

Wx wxTextHorizontal({
  @Ext() required TextCtx textCtx,
  required String text,
  AxisAlignment horizontal = AxisAlignment.left,
}) {
  return wxText(
    textCtx: textCtx,
    text: text,
    vertical: null,
    horizontal: horizontal,
  );
}

Wx wxText({
  @Ext() required TextCtx textCtx,
  required String text,
  required AxisAlignment? vertical,
  required AxisAlignment? horizontal,
}) {
  final textStyle = textCtx.textStyle;
  final maxWidth = textCtx.sizeWidth();
  final splitMarker = textCtx.renderObj.themeWrap.textSplitMarker;

  final textSpan = TextSpan(
    text: text,
    style: textStyle,
  );

  final textSpanSize = textSpan.textSpanSize();

  if (textSpanSize.width <= maxWidth) {
    return wxSizedBox(
      size: textSpanSize,
      widget: RichText(
        text: textSpan,
        softWrap: false,
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    ).wxAlign(
      size: textCtx.size,
      vertical: vertical,
      horizontal: horizontal,
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

    return wxRow(
      children: [
        wxSizedBox(
          size: halfSize,
          widget: halfWidget(start: true),
        ),
        split,
        wxSizedBox(
          size: halfSize,
          widget: halfWidget(start: false),
        ),
      ],
      size: textSpanSize.withWidth(maxWidth),
    ).wxAlign(
      size: textCtx.size,
      vertical: vertical,
      horizontal: horizontal,
    );
  }
}

Size textSpanSize({
  @Ext() required TextSpan textSpan,
}) {
  final TextPainter textPainter = TextPainter(
    text: textSpan,
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
  return textPainter.size;
}
