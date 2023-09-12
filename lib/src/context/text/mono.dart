part of '../text.dart';

@Has()
typedef ColumnCount = int;
@Has()
typedef RowCount = int;

@Compose()
abstract class GridSize implements HasColumnCount, HasRowCount {}

@Compose()
@Has()
abstract class MonoTextStyle
    implements HasSize, HasTextStyle, HasTextStyleWrap {}

MonoTextStyle createMonoTextStyle({
  @ext required TextStyleWrap textStyleWrap,
}) {
  const _calcCount = 10000;
  final textStyle = textStyleWrap.textStyle;
  return ComposedMonoTextStyle(
    size: mdiTextSize(
      Iterable.generate(
        _calcCount,
        (_) => "M",
      ).join(),
      textStyle,
    ).let((s) {
      return Size(s.width / _calcCount, s.height);
    }),
    textStyleWrap: textStyleWrap,
    textStyle: textStyle,
  );
}

@Compose()
abstract class MonoTextCtx implements TextCtx, HasMonoTextStyle {}

MonoTextCtx createMonoTextCtx({
  @ext required RectCtx rectCtx,
  @ext required MonoTextStyle monoTextStyle,
}) {
  return ComposedMonoTextCtx.textCtx(
    textCtx: createTextCtx(
      rectCtx: rectCtx,
      textStyleWrap: monoTextStyle.textStyleWrap,
    ),
    monoTextStyle: monoTextStyle,
  );
}

int monoTextStyleMaxColumnCount({
  @ext required MonoTextStyle monoTextStyle,
  required double width,
}) {
  return width ~/ monoTextStyle.sizeWidth();
}

int monoTextStyleMaxRowCount({
  @ext required MonoTextStyle monoTextStyle,
  required double height,
}) {
  return height ~/ monoTextStyle.sizeHeight();
}

GridSize monoTextStyleMaxGridSize({
  @ext required MonoTextStyle monoTextStyle,
  @extHas required Size size,
}) {
  return ComposedGridSize(
    columnCount: monoTextStyle.monoTextStyleMaxColumnCount(
      width: size.width,
    ),
    rowCount: monoTextStyle.monoTextStyleMaxRowCount(
      height: size.height,
    ),
  );
}

GridSize monoTextCtxMaxGridSize({
  @ext required MonoTextCtx monoTextCtx,
}) {
  return monoTextCtx.monoTextStyle.monoTextStyleMaxGridSize(
    size: monoTextCtx.size,
  );
}

Wx wxMonoText({
  @ext required MonoTextCtx monoTextCtx,
  required String string,
}) {
  final style = monoTextCtx.monoTextStyle;

  final GridSize(
    columnCount: fitWidth,
    rowCount: fitHeight,
  ) = monoTextCtx.monoTextCtxMaxGridSize();

  final lines =
      string.slices(fitWidth).take(fitHeight).toList().orIfEmpty(const [""]);

  final lineSize = Size(
    style.width * fitWidth,
    style.height,
  );

  final lineCtx = monoTextCtx.monoTextCtxWithSize(lineSize);

  final linesSize = Size(
    style.width * fitWidth,
    style.height * lines.length,
  );

  final widget = Column(
    children: lines.map(
      (line) {
        final lineSpan = lineCtx.createTextSpan(line);
        return RichText(
          text: lineSpan,
          softWrap: false,
          maxLines: 1,
        );
      },
    ).toList(),
  );

  final wrapWx = widget.createWx(size: linesSize);

  return monoTextCtx.wxAlignGeometry(
    wx: wrapWx,
    alignmentGeometry: Alignment.topLeft,
  );
}

double calculateMonoTextStyleIntrinsicHeight({
  required MonoTextStyle monoTextStyle,
  required int stringLength,
  required width,
}) {
  final columnCount = monoTextStyle.monoTextStyleMaxColumnCount(
    width: width,
  );

  final intrinsicRowCount = (stringLength - 1) ~/ columnCount + 1;

  return monoTextStyle.sizeHeight() * intrinsicRowCount;
}

SizingWidget monoTextCtxSharingBox({
  @ext required MonoTextCtx monoTextCtx,
  required String string,
}) {
  final monoTextStyle = monoTextCtx.monoTextStyle;

  final columnCount = monoTextStyle.monoTextStyleMaxColumnCount(
    width: monoTextCtx.sizeWidth(),
  );

  final lines = string.slices(columnCount).toList().orIfEmpty(const [""]);

  final columnCtx = monoTextCtx.createColumnCtx();
  return columnCtx.chunkedSizingWidget(
    emptySizingWidget: columnCtx.textRow(
      textStyleWrap: monoTextCtx.renderCtxThemeWrap().defaultTextStyleWrap,
      text: "Empty string.",
    ),
    pageCountCallback: (_) {}, // TODO
    itemDimension: monoTextStyle.sizeHeight(),
    itemCount: lines.length,
    pageNumber: 0,
    itemBuilder: (index, rectCtx) {
      final text = lines[index];

      return monoTextCtx.monoTextCtxWithSize(rectCtx.size).wxTextAlign(
            text: text,
            alignmentGeometry: Alignment.centerLeft,
          );
    },
    dividerThickness: null,
  );
}
