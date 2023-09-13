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

typedef BuildSizingWidgets = SizingWidgets Function(ColumnCtx columnCtx);
// @Has()
// typedef CreateWx = CreateValue<Wx>;

typedef LinearDimensions = ({
  Dimension main,
  Dimension crossExtra,
});

@Has()
typedef CreateLinearWx = Wx Function(Dimension extraCrossDimension);

@Compose()
abstract class AssignDimensionBits
    implements HasAssignDimension // , HasAssignedDimension
{}

@Compose()
abstract class DimensionHolder
    implements AssignDimensionBits, HasAssignedDimension {}

@Compose()
abstract class SizingWidgetBits
    implements HasIntrinsicDimension, HasCreateLinearWx {}

sealed class SizingWidget implements SizingWidgetBits {}

@Compose()
abstract class RigidWidget implements SizingWidget, SizingWidgetBits {}

sealed class SoftWidget implements SizingWidget, HasAssignDimension {}

@Compose()
abstract class GrowingWidget implements AssignDimensionBits, SizingWidgetBits, SoftWidget {}

typedef WxGrowBuilder = Wx Function(GrowDimensions grow);

@Compose()
abstract class ShrinkingWidget implements AssignDimensionBits, SizingWidgetBits, SoftWidget {}

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
  final rigidWidgets = <RigidWidget>[];
  final growingWidgets = <GrowingWidget>[];
  var shrinkingWidgets = <ShrinkingWidget>[];

  for (final widget in sizingWidgets) {
    switch (widget) {
      case RigidWidget():
        rigidWidgets.add(widget);
      case GrowingWidget():
        growingWidgets.add(widget);
      case ShrinkingWidget():
        shrinkingWidgets.add(widget);
    }
  }

  final rigidTotal = rigidWidgets.sumByDouble((e) => e.intrinsicDimension);
  final growingTotal = growingWidgets.sumByDouble((e) => e.intrinsicDimension);

  final minDimension = rigidTotal + growingTotal;

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

DimensionHolder createDimensionHolder({
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

RigidWidget rigidWidgetWx({
  @ext required LinearCtx linearCtx,
  @ext required Wx wx,
  AxisAlignment crossAxisAlignment = AxisAlignment.center,
}) {
  final crossAxis = linearCtx.crossAxis();
  final wxCross = wx.sizeAxisDimension(
    axis: crossAxis,
  );
  return linearRigid(
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



