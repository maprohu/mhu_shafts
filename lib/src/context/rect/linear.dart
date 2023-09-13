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

@Compose()
abstract class RowCtx implements LinearCtx, RectCtx {}

@Compose()
abstract class ColumnCtx implements LinearCtx, RectCtx {}

LinearCtx createLinearCtx({
  @ext required RectCtx rectCtx,
  @ext required Axis axis,
}) {
  return ComposedLinearCtx.rectCtx(
    rectCtx: rectCtx,
    axis: axis,
  );
}

LinearCtx linearWithAxisDimension({
  @ext required LinearCtx linearCtx,
  required Axis axis,
  required Dimension dimension,
}) {
  return linearCtx.linearCtxWithSize(
    linearCtx.size.sizeWithAxisDimension(
      axis: axis,
      dimension: dimension,
    ),
  );
}

LinearCtx linearWithMainDimension({
  @ext required LinearCtx linearCtx,
  required Dimension dimension,
}) {
  return linearCtx.linearWithAxisDimension(
    axis: linearCtx.axis,
    dimension: dimension,
  );
}

LinearCtx linearWithAssignedDimension({
  @ext required LinearCtx linearCtx,
  required HasAssignedDimension dimensionHolder,
}) {
  return linearCtx.linearWithMainDimension(
    dimension: dimensionHolder.assignedDimension(),
  );
}

RowCtx asRowCtx({
  @ext required LinearCtx linearCtx,
}) {
  switch (linearCtx) {
    case RowCtx():
      return linearCtx;
    default:
      assert(linearCtx.axis == Axis.horizontal);
      return ComposedRowCtx.linearCtx(
        linearCtx: linearCtx,
      );
  }
}

ColumnCtx asColumnCtx({
  @ext required LinearCtx linearCtx,
}) {
  switch (linearCtx) {
    case ColumnCtx():
      return linearCtx;
    default:
      assert(linearCtx.axis == Axis.vertical);
      return ComposedColumnCtx.linearCtx(
        linearCtx: linearCtx,
      );
  }
}

LinearCtx linearWithCrossDimension({
  @ext required LinearCtx linearCtx,
  required Dimension dimension,
}) {
  return linearCtx.linearWithAxisDimension(
    axis: linearCtx.crossAxis(),
    dimension: dimension,
  );
}

RowCtx createRowCtx({
  @ext required RectCtx rectCtx,
}) {
  return ComposedRowCtx.rectCtx(
    rectCtx: rectCtx,
    axis: Axis.horizontal,
  );
}

ColumnCtx createColumnCtx({
  @ext required RectCtx rectCtx,
}) {
  return ComposedColumnCtx.rectCtx(
    rectCtx: rectCtx,
    axis: Axis.vertical,
  );
}

Wx wxLinearWidgets({
  @ext required LinearCtx linearCtx,
  @ext required SizingWidgets widgets,
  bool fill = true,
  AxisAlignment? crossAxisAlignment,
}) {
  final crossAxis = linearCtx.crossAxis();
  final result = performWidgetLayout(
    sizingWidgets: widgets,
    availableSpace: linearCtx.orientedMainDimension(),
  );

  Wx render(
    double? extraSpace,
  ) {
    final intrinsicCrossSizes = linearCtx.runWxSizing$(
      () => widgets.map(
        (sw) {
          return (
            sizingWidget: sw,
            intrinsicCrossSize:
                sw.createLinearWx(0).sizeAxisDimension(axis: crossAxis),
          );
        },
      ).toList(),
    );
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
    var wx = wxLinear(
      children: children,
      axis: linearCtx.axis,
      size: fill
          ? linearCtx
              .orientedBoxWithCrossDimension(dimension: maxCrossSize)
              .size
          : null,
    );

    if (crossAxisAlignment != null) {
      wx = wx.wxAlignAxis(
        size: linearCtx.size,
        axis: linearCtx.crossAxis(),
        axisAlignment: crossAxisAlignment,
      );
    }

    return wx;
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

GrowingWidget linearGrow({
  @ext required LinearCtx linearCtx,
  required WxGrowBuilder builder,
}) {
  final intrinsicDimension = linearCtx.runWxSizing$(
    () => builder((
      main: 0,
      cross: 0,
    )).size.sizeAxisDimension(
          axis: linearCtx.axis,
        ),
  );
  final holder = createDimensionHolder();
  return ComposedGrowingWidget.assignDimensionBits(
    assignDimensionBits: holder,
    intrinsicDimension: intrinsicDimension,
    createLinearWx: (extraCrossDimension) {
      return builder((
        main: holder.assignedDimension() - intrinsicDimension,
        cross: extraCrossDimension,
      ));
    },
  );
}

GrowingWidget linearGrowEmpty({
  @ext required LinearCtx linearCtx,
}) {
  return linearCtx.linearGrow(
    builder: (grow) {
      return Size.zero
          .sizeWithAxisDimension(
            axis: linearCtx.axis,
            dimension: grow.main,
          )
          .sizeWithAxisDimension(
            axis: linearCtx.crossAxis(),
            dimension: grow.cross,
          )
          .wxEmpty();
    },
  );
}

CreateLinearWx createLinearWxStretched({
  @ext required LinearCtx linearCtx,
  required Call<Wx> createWx,
}) {
  Wx assertWx() {
    final wx = createWx();
    assert(
      linearCtx.assertOrientedCrossRoughlyEqual(size: wx.size),
    );
    return wx;
  }

  return (extraCrossDimension) {
    assert(
      assertDoubleRoughlyEqual(extraCrossDimension, 0),
    );
    return assertWx();
  };
}

CreateLinearWx assignedRectWxStretched({
  @ext required LinearCtx linearCtx,
  required HasAssignedDimension holder,
  required WxRectBuilder builder,
}) {
  return linearCtx.createLinearWxStretched(
    createWx: () {
      return builder(
        linearCtx.linearWithMainDimension(
          dimension: holder.assignedDimension(),
        ),
      );
    },
  );
}
