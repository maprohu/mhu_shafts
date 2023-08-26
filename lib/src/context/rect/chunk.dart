part of '../rect.dart';

SharingBox chunkedRectVerticalSharingBox({
  @ext required RectCtx rectCtx,
  required double itemHeight,
  required int itemCount,
  required int startAt,
  required Wx Function(int index, RectCtx rectCtx) itemBuilder,
  required double dividerThickness,
  SharingBox? emptyBx,
}) {
  if (itemCount == 0) {
    return emptyBx ??
        ComposedSharingBox(
          intrinsicDimension: 0,
          wxDimensionBuilder: (dimension) => rectCtx
              .rectWithHeight(
                height: dimension,
              )
              .wxEmpty(),
        );
  }
  final intrinsicHeight =
      itemCount * itemHeight + (itemCount - 1) * dividerThickness;
  return ComposedSharingBox(
    intrinsicDimension: intrinsicHeight,
    wxDimensionBuilder: (dimension) {
      return wxChunkedRectVertical(
        rectCtx: rectCtx.rectWithHeight(
          height: dimension,
        ),
        itemHeight: itemHeight,
        itemCount: itemCount,
        startAt: startAt,
        itemBuilder: itemBuilder,
        dividerThickness: dividerThickness,
      );
    },
  );
}

Wx wxChunkedRectVertical({
  required RectCtx rectCtx,
  required double itemHeight,
  required int itemCount,
  required int startAt,
  required Wx Function(int index, RectCtx rectCtx) itemBuilder,
  required double dividerThickness,
  SharingBox? emptyBx,
}) {
  final themeWrap = rectCtx.renderObj.themeWrap;
  Wx page({
    required RectCtx rectCtx,
    required int startAt,
    required int count,
    required bool stretch,
  }) {
    int dividerCount = count - 1;

    var itemBits = rectCtx.rectWithHeight(height: itemHeight);

    final divider = rectCtx.wxRectVerticalLayoutDivider(
      thickness: dividerThickness,
    );
    Wx itemsWx(Size size) {
      return wxColumn(
        children: integers(from: startAt)
            .take(count)
            .map(
              (index) => itemBuilder(index, itemBits),
            )
            .separatedBy(divider)
            .toList(),
        size: size,
      );
    }

    if (stretch) {
      itemBits = itemBits.rectWithHeight(
        height: (rectCtx.height - (dividerCount * dividerThickness)) / count,
      );

      return itemsWx(rectCtx.size);
    } else {
      return itemsWx(
        rectCtx.size.withHeight(
          dividerCount * dividerThickness + itemHeight * count,
        ),
      ).wxAlignAxis(
        size: rectCtx.size,
        axis: Axis.vertical,
        axisAlignment: AxisAlignment.top,
      );
    }
  }

  if (itemCount == 0) {
    return rectCtx.wxEmpty();
  }

  final fitCount = itemFitCount(
    available: rectCtx.height,
    itemSize: itemHeight,
    dividerThickness: dividerThickness,
  );

  if (itemCount == fitCount) {
    return page(
      rectCtx: rectCtx,
      startAt: 0,
      count: itemCount,
      stretch: true,
    );
  } else if (itemCount < fitCount) {
    return page(
      rectCtx: rectCtx,
      startAt: 0,
      count: itemCount,
      stretch: false,
    );
  } else {
    return rectCtx.wxRectFillTop(
      top: (rectCtx) {
        final fitCount = itemFitCount(
          available: rectCtx.height,
          itemSize: itemHeight,
          dividerThickness: dividerThickness,
        );

        startAt = min(startAt, itemCount - fitCount);

        return page(
          rectCtx: rectCtx,
          startAt: startAt,
          count: fitCount,
          stretch: true,
        );
      },
      bottom: [
        rectCtx.wxRectHorizontalLayoutDivider(
          thickness: themeWrap.chunkedFooterDividerThickness,
        ),
        rectCtx
            .rectWithHeight(
              height: themeWrap.chunkedFooterOuterHeight,
            )
            .wxEmpty(),
      ],
    );
  }
}
