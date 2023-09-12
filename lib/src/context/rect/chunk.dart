part of '../rect.dart';

typedef PageSize = int;
typedef PageCount = int;
typedef PageCountCallback = void Function(PageCount? pageCount);
typedef PageCountHolder = LateFinal<PageCount>;

typedef PageDimension = ({
  PageSize size,
  PageCount count,
});

SizingWidget chunkedListSizingWidget({
  @ext required ColumnCtx columnCtx,
  required List<WxRectBuilder> items,
  required Dimension itemDimension,
  required SizingWidget emptySizingWidget,
  PageCountCallback pageCountCallback = ignore1,
}) {
  final themeWrap = columnCtx.renderCtxThemeWrap();
  return columnCtx.chunkedSizingWidget(
    itemDimension: itemDimension,
    itemCount: items.length,
    pageNumber: 0,
    itemBuilder: (index, rectCtx) {
      return items[index].call(rectCtx);
    },
    dividerThickness: themeWrap.menuItemsDividerThickness,
    emptySizingWidget: emptySizingWidget,
    pageCountCallback: pageCountCallback,
  );
}

SizingWidget chunkedSizingWidget({
  @ext required ColumnCtx columnCtx,
  required Dimension itemDimension,
  required int itemCount,
  required int pageNumber,
  required Wx Function(int index, RectCtx rectCtx) itemBuilder,
  required double? dividerThickness,
  required SizingWidget emptySizingWidget,
  required PageCountCallback pageCountCallback,
}) {
  if (itemCount == 0) {
    pageCountCallback(0);
    return emptySizingWidget;
  }

  final themeWrap = columnCtx.renderCtxThemeWrap();

  final intrinsicHeight =
      itemCount * itemDimension + (itemCount - 1) * (dividerThickness ?? 0);

  final pageDimensionHolder = SingleAssign<PageDimension?>.withDefault(
    callback: (value) => pageCountCallback(value?.count),
    defaultValue: null,
  );
  Wx createFooter() {
    return columnCtx.wxLinearWidgets(
      widgets: [
        columnCtx.linearDivider(
          thickness: themeWrap.chunkedFooterDividerThickness,
        ),
        columnCtx.linearPadding(
          edgeInsets: themeWrap.chunkedFooterPaddingSizer.edgeInsets,
          builder: (deflatedCtx) {
            return deflatedCtx.asColumnCtx().textRow(
                  textStyleWrap: themeWrap.chunkedFooterTextStyleWrap,
                  text: "$pageNumber/${pageDimensionHolder.value}",
                );
          },
        )
      ],
      fill: false,
    );
  }

  PageDimension? pageDimension(Dimension assignedHeight) {
    final fitCount = itemFitCount(
      available: assignedHeight,
      itemSize: itemDimension,
      dividerThickness: dividerThickness,
    );

    if (fitCount == 0) {
      return null;
    }
    if (itemCount <= fitCount) {
      return (
        count: 1,
        size: fitCount,
      );
    }
    final footerHeight = createFooter().sizeHeight();
    final pagesFitCount = itemFitCount(
      available: assignedHeight - footerHeight,
      itemSize: itemDimension,
      dividerThickness: dividerThickness,
    );
    final pageCount = itemPageCount(
      itemCount: itemCount,
      fitCount: pagesFitCount,
    );
    if (pageCount == null) {
      return null;
    }
    return (
      count: pageCount,
      size: pagesFitCount,
    );
  }

  final holder = dimensionHolder(
    onAssignDimension: (assignedHeight) {
      pageDimensionHolder.value = pageDimension(assignedHeight);
    },
  );

  return ComposedShrinkingWidget.dimensionHolder(
    dimensionHolder: holder,
    intrinsicDimension: intrinsicHeight,
    createLinearWx: (extraCrossDimension) {
      assert(assertDoubleRoughlyEqual(extraCrossDimension, 0));

      final assignedCtx =
          columnCtx.linearWithAssignedDimension(dimensionHolder: holder);

      final pageDimension = pageDimensionHolder.value;

      if (pageDimension == null) {
        return assignedCtx.wxPlaceholder();
      }

      // return assignedCtx.defaultTextCtx().wxTextAlign(text: "chunks");

      SizingWidgets items({
        required int from,
        required int count,
      }) sync* {
        final itemCtx =
            assignedCtx.linearWithMainDimension(dimension: itemDimension);

        final result = integers(from: from).take(count).map(
              (index) => itemBuilder(index, itemCtx).solidWidgetWx(
                linearCtx: assignedCtx,
              ),
            );

        if (dividerThickness == null) {
          yield* result;
        } else {
          yield* result.separatedBy(
            assignedCtx.linearDivider(thickness: dividerThickness),
          );
        }

        yield assignedCtx.linearGrowEmpty();
      }

      if (pageDimension.count < 2) {
        return assignedCtx.wxLinearWidgets(
          widgets: items(
            from: 0,
            count: itemCount,
          ).toList(),
        );
      }
      final effectivePageNumber = min(
        pageDimension.count - 1,
        pageNumber,
      );
      return assignedCtx.wxLinearWidgets(
        widgets: [
          ...items(
            from: effectivePageNumber * pageDimension.size,
            count: pageDimension.size,
          ),
          createFooter().solidWidgetWx(
            linearCtx: assignedCtx,
          ),
        ],
      );
    },
  );
}

// Wx wxChunked({
//   required LinearCtx linearCtx,
//   required Dimension itemDimension,
//   required int itemCount,
//   required int pageNumber,
//   required Wx Function(int index, RectCtx rectCtx) itemBuilder,
//   required double? dividerThickness,
//   required PageCountHolder pageCountHolder,
// }) {
//   assert(itemCount > 0);
//
//   final double effectiveDividerThickness = dividerThickness ?? 0;
//   final themeWrap = linearCtx.renderObj.themeWrap;
//   Wx page({
//     required RectCtx rectCtx,
//     required int startAt,
//     required int count,
//     required bool stretch,
//   }) {
//     int dividerCount = count - 1;
//
//     var itemBits = rectCtx.rectWithAxisDimension(
//       axis: linearCtx.axis,
//       dimension: itemDimension,
//     );
//
//     Wx itemsWx(Size size) {
//       final divider = dividerThickness != null
//           ? rectCtx.wxRectDivider(
//               layoutAxis: linearCtx.axis,
//               thickness: dividerThickness,
//             )
//           : null;
//       return wxLinear(
//         axis: linearCtx.axis,
//         children: integers(from: startAt)
//             .take(count)
//             .map(
//               (index) => itemBuilder(index, itemBits),
//             )
//             .iterableSeparatedByNullable(
//               separator: divider,
//             )
//             .toList(),
//         size: size,
//       );
//     }
//
//     if (stretch) {
//       itemBits = itemBits.rectWithAxisDimension(
//         axis: linearCtx.axis,
//         dimension: (rectCtx.sizeHeight() -
//                 (dividerCount * effectiveDividerThickness)) /
//             count,
//       );
//
//       return itemsWx(rectCtx.size);
//     } else {
//       return itemsWx(
//         rectCtx.size.sizeWithAxisDimension(
//           axis: linearCtx.axis,
//           dimension:
//               dividerCount * effectiveDividerThickness + itemDimension * count,
//         ),
//       ).wxAlignAxis(
//         size: rectCtx.size,
//         axis: linearCtx.axis,
//         axisAlignment: AxisAlignment.start,
//       );
//     }
//   }
//
//   final fitCount = itemFitCount(
//     available: linearCtx.orientedMainDimension(),
//     itemSize: itemDimension,
//     dividerThickness: effectiveDividerThickness,
//   );
//
//   if (itemCount == fitCount) {
//     return page(
//       rectCtx: linearCtx,
//       startAt: 0,
//       count: itemCount,
//       stretch: true,
//     );
//   } else if (itemCount < fitCount) {
//     return page(
//       rectCtx: linearCtx,
//       startAt: 0,
//       count: itemCount,
//       stretch: false,
//     );
//   } else {
//     // final pagerOpener = mshShaftOpenerOf<PagerShaftFactory>(
//     //   identifierAnyData: pagerShaftIdentifier(
//     //     chunkedContentKey: chunkedContentKey,
//     //   ),
//     // );
//     return wxTextAlign(textCtx: linearCtx.defaultTextCtx(), text: "hello");
//     // linearCtx.wxLinearWidgets(
//     //   widgets: [
//     //     linearCtx.linearGrow(builder: (grow) {
//     //       return textShrinkingWidget(linearCtx: linearCtx, textStyleWrap: textStyleWrap, text: text)
//     //
//     //     },)
//     //
//     //   ],
//     // );
//     // return rectCtx.wxRectFillTop(
//     //   top: (rectCtx) {
//     //     final fitCount = itemFitCount(
//     //       available: rectCtx.height,
//     //       itemSize: itemHeight,
//     //       dividerThickness: effectiveDividerThickness,
//     //     );
//     //
//     //     final pageCount = itemCount ~/ fitCount;
//     //
//     //     pageNumber = min(pageCount - 1, pageNumber);
//     //
//     //     return page(
//     //       rectCtx: rectCtx,
//     //       startAt: pageNumber * fitCount,
//     //       count: fitCount,
//     //       stretch: true,
//     //     );
//     //   },
//     //   bottom: [
//     //     rectCtx.wxRectVerticalLayoutDivider(
//     //       thickness: themeWrap.chunkedFooterDividerThickness,
//     //     ),
//     //     rectCtx.wxRectPaddingSizer(
//     //       paddingSizer: themeWrap.chunkedFooterPaddingSizer,
//     //       builder: (rectCtx) {
//     //         return rectCtx.defaultTextCtx().wxTextHorizontal(
//     //               text: "$pageNumber",
//     //             );
//     //         ;
//     //       },
//     //     )
//     //     // .wxDecorateShaftOpener(
//     //     //   shaftOpener: pagerOpener,
//     //     //   shaftCtx: rectCtx,
//     //     // )
//     //   ],
//     // );
//   }
// }
