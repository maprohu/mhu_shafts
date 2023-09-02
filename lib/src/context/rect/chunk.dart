part of '../rect.dart';

SharingBox chunkedListRectVerticalSharingBox({
  @ext required RectCtx rectCtx,
  required List<WxRectBuilder> items,
  required double itemHeight,
}) {
  final themeWrap = rectCtx.renderCtxThemeWrap();
  return rectCtx.chunkedRectVerticalSharingBox(
    itemHeight: itemHeight,
    itemCount: items.length,
    startAt: 0,
    itemBuilder: (index, rectCtx) {
      return items[index].call(rectCtx);
    },
    dividerThickness: themeWrap.menuItemsDividerThickness,
  );
}

SharingBox chunkedRectVerticalSharingBox({
  @ext required RectCtx rectCtx,
  required double itemHeight,
  required int itemCount,
  required int startAt,
  required Wx Function(int index, RectCtx rectCtx) itemBuilder,
  required double? dividerThickness,
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
      itemCount * itemHeight + (itemCount - 1) * (dividerThickness ?? 0);
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
  required double? dividerThickness,
  SharingBox? emptyBx,
}) {
  final double effectiveDividerThickness = dividerThickness ?? 0;
  final themeWrap = rectCtx.renderObj.themeWrap;
  Wx page({
    required RectCtx rectCtx,
    required int startAt,
    required int count,
    required bool stretch,
  }) {
    int dividerCount = count - 1;

    var itemBits = rectCtx.rectWithHeight(height: itemHeight);

    Wx itemsWx(Size size) {
      final divider = dividerThickness != null
          ? rectCtx.wxRectVerticalLayoutDivider(
              thickness: dividerThickness,
            )
          : null;
      return wxColumn(
        children: integers(from: startAt)
            .take(count)
            .map(
              (index) => itemBuilder(index, itemBits),
            )
            .iterableSeparatedByNullable(
              separator: divider,
            )
            .toList(),
        size: size,
      );
    }

    if (stretch) {
      itemBits = itemBits.rectWithHeight(
        height: (rectCtx.height - (dividerCount * effectiveDividerThickness)) /
            count,
      );

      return itemsWx(rectCtx.size);
    } else {
      return itemsWx(
        rectCtx.size.withHeight(
          dividerCount * effectiveDividerThickness + itemHeight * count,
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
    dividerThickness: effectiveDividerThickness,
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
          dividerThickness: effectiveDividerThickness,
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
              height: themeWrap.chunkedFooterPaddingSizer.callOuterHeight(),
            )
            .wxEmpty(),
      ],
    );
  }
}
