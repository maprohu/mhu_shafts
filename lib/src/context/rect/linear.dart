part of '../rect.dart';

Wx wxRectColumnExact({
  @ext required RectCtx rectCtx,
  required Iterable<Wx> children,
}) {
  return wxColumn(
    children: children,
    size: rectCtx.size,
  );
}

@Compose()
abstract class LinearCtx implements RectCtx, OrientedBox {}

LinearCtx createLinearCtx({
  @ext required RectCtx rectCtx,
  @ext required Axis axis,
}) {
  return ComposedLinearCtx.rectCtx(
    rectCtx: rectCtx,
    axis: axis,
  );
}

LinearCtx rowCtx({
  @ext required RectCtx rectCtx,
}) {
  return createLinearCtx(
    rectCtx: rectCtx,
    axis: Axis.horizontal,
  );
}

LinearCtx columnCtx({
  @ext required RectCtx rectCtx,
}) {
  return createLinearCtx(
    rectCtx: rectCtx,
    axis: Axis.vertical,
  );
}

Wx wxLinearWidgets({
  @ext required LinearCtx linearCtx,
  @ext required SizingWidgets widgets,
  bool fill = true,
}) {
  final crossAxis = linearCtx.crossAxis();
  final result = performWidgetLayout(
    sizingWidgets: widgets,
    availableSpace: linearCtx.orientedMainDimension(),
  );

  Wx render(
    double? extraSpace,
  ) {
    final intrinsicCrossSizes = widgets.map((sw) {
      return (
        sizingWidget: sw,
        intrinsicCrossSize:
            sw.createLinearWx(0).sizeAxisDimension(axis: crossAxis),
      );
    }).toList();
    final maxCrossSize =
        intrinsicCrossSizes.map((e) => e.intrinsicCrossSize).maxOrNull ?? 0;
    final children = [
      for (final item in intrinsicCrossSizes)
        item.sizingWidget.createLinearWx(
          maxCrossSize - item.intrinsicCrossSize,
        ),
      if (fill && extraSpace != null)
        wxEmpty(
          size: linearCtx
              .orientedBoxWithMainDimension(
                dimension: extraSpace,
              )
              .orientedBoxWithCrossDimension(
                dimension: maxCrossSize,
              )
              .size,
        ),
    ];
    return wxLinear(
      children: children,
      axis: linearCtx.axis,
      size: linearCtx.size,
    );
  }

  switch (result) {
    case LayoutDoesNotFit():
      return linearCtx.wxPlaceholder();
    case LayoutExactFit():
      return render(null);
    case LayoutFitWithExtra():
      return render(result.extra);
  }
}

SolidWidget linearSolid({
  @ext required LinearCtx linearCtx,
  required CreateLinearWx builder,
}) {
  final intrinsicDimension =
      builder(0).size.sizeAxisDimension(axis: linearCtx.axis);
  return ComposedSolidWidget(
    intrinsicDimension: intrinsicDimension,
    createLinearWx: builder,
  );
}

GrowingWidget linearGrow({
  @ext required LinearCtx linearCtx,
  required WxGrowBuilder builder,
}) {
  final intrinsicDimension = builder(
    mainExtra: 0,
    crossExtra: 0,
  ).size.sizeAxisDimension(
        axis: linearCtx.axis,
      );
  final holder = dimensionHolder();
  return ComposedGrowingWidget.dimensionHolder(
    dimensionHolder: holder,
    intrinsicDimension: intrinsicDimension,
    createLinearWx: (extraCrossDimension) {
      return builder(
        mainExtra: holder.assignedDimension() - intrinsicDimension,
        crossExtra: extraCrossDimension,
      );
    },
  );
}

GrowingWidget linearGrowEmpty({
  @ext required LinearCtx linearCtx,
}) {
  return linearCtx.linearGrow(
    builder: ({
      required crossExtra,
      required mainExtra,
    }) {
      return Size.zero
          .sizeWithAxisDimension(
            axis: linearCtx.axis,
            dimension: mainExtra,
          )
          .sizeWithAxisDimension(
            axis: linearCtx.crossAxis(),
            dimension: crossExtra,
          )
          .wxEmpty();
    },
  );
}

SizingWidget linearPadding({
  @ext required LinearCtx linearCtx,
  required EdgeInsets edgeInsets,
  required SizingWidget Function(LinearCtx paddingCtx) builder,
}) {
  final innerCtx = linearCtx
      .rectWithSize(
        size: edgeInsets.deflateSize(linearCtx.size),
      )
      .createLinearCtx(
        axis: linearCtx.axis,
      );

  final innerWidget = builder(innerCtx);

  final paddingMainAxisDimension = edgeInsets.edgeInsetsAxisDimension(
    axis: linearCtx.axis,
  );

  final intrinsicDimension =
      innerWidget.intrinsicDimension + paddingMainAxisDimension;

  DimensionHolder holder(DimensionHolder holder) {
    return ComposedDimensionHolder(
      assignDimension: (value) =>
          holder.assignDimension(value + paddingMainAxisDimension),
      assignedDimension: () =>
          holder.assignedDimension() - paddingMainAxisDimension,
    );
  }

  Wx createWx(Dimension crossExtra) =>
      innerWidget.createLinearWx(crossExtra).wxPadding(
            edgeInsets: edgeInsets,
          );

  switch (innerWidget) {
    case SolidWidget():
      return ComposedSolidWidget(
        intrinsicDimension: intrinsicDimension,
        createLinearWx: createWx,
      );
    case GrowingWidget():
      return ComposedGrowingWidget.dimensionHolder(
        dimensionHolder: holder(innerWidget),
        intrinsicDimension: intrinsicDimension,
        createLinearWx: createWx,
      );
    case ShrinkingWidget():
      return ComposedShrinkingWidget.dimensionHolder(
        dimensionHolder: holder(innerWidget),
        intrinsicDimension: intrinsicDimension,
        createLinearWx: createWx,
      );
  }
}

SolidWidget linearDivider({
  @ext required LinearCtx linearCtx,
  required Dimension thickness,
}) {
  return linearCtx.linearSolid(
    builder: (extraCrossDimension) {
      return wxRectDivider(
        rectCtx: linearCtx.rectWithSize(
          size: linearCtx
              .orientedBoxWithCrossDimension(
                dimension: extraCrossDimension,
              )
              .size,
        ),
        layoutAxis: linearCtx.axis,
        thickness: thickness,
      );
    },
  );
}
