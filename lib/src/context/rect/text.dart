part of '../rect.dart';

SharingBoxes rectMonoTextSharingBoxes({
  @ext required RectCtx rectCtx,
  required String text,
}) {
  return rectMonoTextSharingBox(
    rectCtx: rectCtx,
    text: text,
  ).toSingleElementIterable;
}

SharingBox rectMonoTextSharingBox({
  @ext required RectCtx rectCtx,
  required String text,
}) {
  final monoTextCtx = rectCtx.defaultMonoTextCtx();
  return monoTextCtx.monoTextCtxSharingBox(
    string: text,
  );
}

ShrinkingWidget textShrinkingWidget({
  @ext required RowCtx rowCtx,
  @ext required TextStyleWrap textStyleWrap,
  required String text,
  Alignment alignment = Alignment.centerLeft,
}) {
  final textSpan = textStyleWrap.createTextSpan(text);

  final size = textSpan.textSpanSize();

  final holder = dimensionHolder();

  return ComposedShrinkingWidget.dimensionHolder(
    dimensionHolder: holder,
    intrinsicDimension: size.width,
    createLinearWx: (extraCrossDimension) {
      return rowCtx
          .linearWxRect(
            dimensionHolder: holder,
            intrinsicSize: size,
            extraCrossDimension: extraCrossDimension,
          )
          .createTextCtx(textStyleWrap: textStyleWrap)
          .wxTextAlign(
            text: text,
            alignmentGeometry: alignment,
          );
    },
  );
}

Size linearWxSize({
  @ext required HasAxis linearCtx,
  required HasAssignedDimension dimensionHolder,
  required Size intrinsicSize,
  required Dimension extraCrossDimension,
}) {
  return Size.zero
      .sizeWithAxisDimension(
        axis: linearCtx.axis,
        dimension: dimensionHolder.assignedDimension(),
      )
      .sizeWithAxisDimension(
        axis: linearCtx.axis.flip,
        dimension: intrinsicSize.sizeAxisDimension(
              axis: linearCtx.axis.flip,
            ) +
            extraCrossDimension,
      );
}

RectCtx linearWxRect({
  @ext required LinearCtx linearCtx,
  required HasAssignedDimension dimensionHolder,
  required Size intrinsicSize,
  required Dimension extraCrossDimension,
}) {
  return linearCtx.rectWithSize(
    size: linearCtx.linearWxSize(
      dimensionHolder: dimensionHolder,
      intrinsicSize: intrinsicSize,
      extraCrossDimension: extraCrossDimension,
    ),
  );
}

SolidWidget defaultTextRow({
  @ext required ColumnCtx columnCtx,
  AxisAlignment horizontal = AxisAlignment.left,
  required String text,
}) {
  return columnCtx.textRow(
    textStyleWrap: columnCtx.defaultTextCtx().textStyleWrap,
    text: text,
  );
}

SolidWidget textRow({
  @ext required ColumnCtx columnCtx,
  AxisAlignment horizontal = AxisAlignment.left,
  @ext required TextStyleWrap textStyleWrap,
  required String text,
}) {
  final textCtx = columnCtx.createTextCtx(textStyleWrap: textStyleWrap);

  return columnCtx.solidWidgetStretchedWx(
    createWx: () {
      return wxTextHorizontal(
        textCtx: textCtx,
        text: text,
        horizontal: horizontal,
      );
    },
  );
}
