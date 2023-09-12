part of '../layout.dart';

typedef GrowDimensions = ({
  Dimension main,
  Dimension cross,
});

@Has()
typedef FixedDimension = Dimension;

@Has()
typedef IntrinsicDimension = Dimension;

@Has()
typedef PerformLayout = VoidCall;

@Has()
typedef AssignDimension = WriteValue<Dimension>;

@Has()
typedef AssignedDimension = ReadValue<Dimension>;

@Has()
typedef SizingWidgets = Iterable<SizingWidget>;

// @Has()
// typedef CreateWx = CreateValue<Wx>;

@Has()
typedef CreateLinearWx = Wx Function(Dimension extraCrossDimension);

@Compose()
abstract class DimensionHolder
    implements HasAssignDimension, HasAssignedDimension {}

sealed class SizingWidget implements HasIntrinsicDimension, HasCreateLinearWx {}

@Compose()
abstract class SolidWidget implements SizingWidget {}

sealed class SoftWidget implements SizingWidget, HasAssignDimension {}

@Compose()
abstract class GrowingWidget implements DimensionHolder, SoftWidget {}

typedef WxGrowBuilder = Wx Function(GrowDimensions grow);

@Compose()
abstract class ShrinkingWidget implements DimensionHolder, SoftWidget {}

@freezed
sealed class LayoutResult with _$LayoutResult {
  const factory LayoutResult.doesNotFit() = LayoutDoesNotFit;

  const factory LayoutResult.exactFit() = LayoutExactFit;

  const factory LayoutResult.fitWithExtra({
    required Dimension extra,
  }) = LayoutFitWithExtra;
}

LayoutResult performWidgetLayout({
  required SizingWidgets sizingWidgets,
  required Dimension availableSpace,
}) {
  final solidWidgets = <SolidWidget>[];
  final growingWidgets = <GrowingWidget>[];
  var shrinkingWidgets = <ShrinkingWidget>[];

  for (final widget in sizingWidgets) {
    switch (widget) {
      case SolidWidget():
        solidWidgets.add(widget);
      case GrowingWidget():
        growingWidgets.add(widget);
      case ShrinkingWidget():
        shrinkingWidgets.add(widget);
    }
  }

  final solidTotal = solidWidgets.sumByDouble((e) => e.intrinsicDimension);
  final growingTotal = growingWidgets.sumByDouble((e) => e.intrinsicDimension);

  final minDimension = solidTotal + growingTotal;

  var softSpace = availableSpace - minDimension;

  if (softSpace < 0) {
    return const LayoutResult.doesNotFit();
  }

  LayoutResult success() {
    if (softSpace == 0) {
      return const LayoutResult.exactFit();
    } else {
      return LayoutResult.fitWithExtra(extra: softSpace);
    }
  }

  while (true) {
    if (shrinkingWidgets.isEmpty) {
      if (growingWidgets.isEmpty) {
        return success();
      }

      final growingCount = growingWidgets.length;

      final singleGrowingExtra = softSpace / growingCount;

      for (final growingWidget in growingWidgets) {
        growingWidget.assignDimension(
          growingWidget.intrinsicDimension + singleGrowingExtra,
        );
      }
      return const LayoutResult.exactFit();
    }

    final shrinkingCount = shrinkingWidgets.length;
    final shrinkingQuota = softSpace / shrinkingCount;

    final newShrinkingList = <ShrinkingWidget>[];

    var hasWithinQuota = false;
    for (final shrinkingWidget in shrinkingWidgets) {
      final intrinsic = shrinkingWidget.intrinsicDimension;
      if (intrinsic <= shrinkingQuota) {
        shrinkingWidget.assignDimension(intrinsic);
        softSpace -= intrinsic;
        hasWithinQuota = true;
      } else {
        newShrinkingList.add(shrinkingWidget);
      }
    }

    if (!hasWithinQuota) {
      for (final shrinkingWidget in shrinkingWidgets) {
        shrinkingWidget.assignDimension(shrinkingQuota);
      }
      softSpace = 0;
      shrinkingWidgets = [];
    } else {
      shrinkingWidgets = newShrinkingList;
    }
  }
}

DimensionHolder dimensionHolder({
  AssignDimension? onAssignDimension,
}) {
  late final Dimension dimension;
  return ComposedDimensionHolder(
    assignDimension: (value) {
      dimension = value;
      onAssignDimension?.call(value);
    },
    assignedDimension: () => dimension,
  );
}

SolidWidget solidWidgetWx({
  @ext required LinearCtx linearCtx,
  @ext required Wx wx,
  AxisAlignment crossAxisAlignment = AxisAlignment.center,
}) {
  final crossAxis = linearCtx.crossAxis();
  final wxCross = wx.sizeAxisDimension(
    axis: crossAxis,
  );
  return solidWidgetCreateWx(
    linearCtx: linearCtx,
    createLinearWx: (extraCrossDimension) {
      final totalCross = wxCross + extraCrossDimension;

      return wx.wxAlignAxis(
        size: wx.sizeWithAxisDimension(
          axis: crossAxis,
          dimension: totalCross,
        ),
        axis: crossAxis,
        axisAlignment: crossAxisAlignment,
      );
    },
  );
}

SolidWidget solidWidgetCreateWx({
  @ext required LinearCtx linearCtx,
  required CreateLinearWx createLinearWx,
}) {
  final wx = createLinearWx(0);
  return ComposedSolidWidget(
    intrinsicDimension: wx.sizeAxisDimension(
      axis: linearCtx.axis,
    ),
    createLinearWx: createLinearWx,
  );
}

SolidWidget solidWidgetStretchedWx({
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

  return ComposedSolidWidget(
    intrinsicDimension: assertWx().sizeAxisDimension(
      axis: linearCtx.axis,
    ),
    createLinearWx: (extraCrossDimension) {
      assert(
        assertDoubleRoughlyEqual(extraCrossDimension, 0),
      );
      return assertWx();
    },
  );
}
