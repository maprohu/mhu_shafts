part of 'wx.dart';

@Has()
typedef IntrinsicDimension = double;

@Has()
typedef WxDimensionBuilder = Wx Function(double dimension);

@Compose()
abstract class SharingBox
    implements HasIntrinsicDimension, HasWxDimensionBuilder {}

SharingBox fixedSharingBox({
  required Wx wx,
  required Axis axis,
  AxisAlignment axisAlignment = AxisAlignment.start,
}) {
  return ComposedSharingBox(
    intrinsicDimension: wx.size.axis(axis),
    wxDimensionBuilder: (dimension) {
      return wxAlignAxis(
        wx: wx,
        size: wx.size.sizeWithAxisDimension(
          axis: axis,
          dimension: dimension,
        ),
        axis: axis,
        axisAlignment: axisAlignment,
      );
    },
  );
}

SharingBox fixedVerticalSharingBox(
  @ext Wx wx,
) {
  return fixedSharingBox(
    wx: wx,
    axis: Axis.vertical,
  );
}

SharingBox emptySharingBox({
  required Axis layoutAxis,
  required double crossAxisDimension,
}) {
  return ComposedSharingBox(
    intrinsicDimension: 0,
    wxDimensionBuilder: (dimension) {
      return wxEmpty(
        size: Size.zero
            .sizeWithAxisDimension(
              axis: layoutAxis,
              dimension: dimension,
            )
            .sizeWithAxisDimension(
              axis: layoutAxis.flip,
              dimension: crossAxisDimension,
            ),
      );
    },
  );
}

@Has()
typedef Index = int;

@Has()
typedef Dimension = double;

@Compose()
abstract class SharingSize implements HasIndex, HasIntrinsicDimension {}

@Compose()
abstract class SharedSize implements HasIndex, HasDimension {}

Map<int, double> distributeSharedSpace({
  required double space,
  required List<SharingSize> items,
}) {
  final itemCount = items.length;

  final quota = space / itemCount;

  final (positive: overQuota, negative: withinQuota) =
      items.partition((item) => item.intrinsicDimension > quota);

  if (withinQuota.isEmpty) {
    return {
      for (final item in overQuota) item.index: quota,
    };
  }

  final withinQuotaTotal =
      withinQuota.sumByDouble((item) => item.intrinsicDimension);

  final overQuotaSpace = space - withinQuotaTotal;

  return {
    ...distributeSharedSpace(
      space: overQuotaSpace,
      items: overQuota,
    ),
    for (final item in withinQuota) item.index: item.intrinsicDimension,
  };
}

Wx wxLinearShared({
  required Size size,
  required Axis axis,
  required Iterable<SharingBox> items,
  double? dividerThickness,
  required ThemeWrap themeWrap,
}) {
  final itemList = items.toList();

  if (itemList.isEmpty) {
    return wxEmpty(size: size);
  }

  final itemCount = itemList.length;

  final totalDividerThickness =
      dividerThickness == null ? 0 : ((itemCount - 1) * dividerThickness);

  final availableSpace = size.axis(axis) - totalDividerThickness;

  Iterable<Wx> Function(Iterable<Wx> items) addDividers =
      dividerThickness != null
          ? (items) {
              return items.separatedBy(
                wxDivider(
                  rectSize: size,
                  layoutAxis: axis,
                  thickness: dividerThickness,
                  themeWrap: themeWrap,
                ),
              );
            }
          : identity;

  final intrinsicDimensionTotal =
      items.sumByDouble((item) => item.intrinsicDimension);

  Wx linear(Iterable<Wx> items) {
    return wxLinear(
      axis: axis,
      children: items.toList(),
      size: size,
    );
  }

  if (intrinsicDimensionTotal <= availableSpace) {
    final fill = availableSpace - intrinsicDimensionTotal;

    return [
      ...items
          .map(
            (e) => e.wxDimensionBuilder(e.intrinsicDimension),
          )
          .let(addDividers),
      if (fill > 0)
        wxEmpty(
          size: size.sizeWithAxisDimension(
            axis: axis,
            dimension: fill,
          ),
        ),
    ].let(linear);
  } else {
    final sharedSizes = distributeSharedSpace(
      space: availableSpace,
      items: items
          .mapIndexed(
            (index, item) => ComposedSharingSize(
              index: index,
              intrinsicDimension: item.intrinsicDimension,
            ),
          )
          .toList(),
    );

    return itemList
        .mapIndexed(
          (index, element) => element.wxDimensionBuilder(
            sharedSizes[index]!,
          ),
        )
        .let(addDividers)
        .let(linear);
  }
}

typedef SharingBoxes = Iterable<SharingBox>;

typedef BuildSharingBoxes = SharingBoxes Function(RectCtx rectCtx);
