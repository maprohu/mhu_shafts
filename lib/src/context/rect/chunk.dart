part of '../rect.dart';

typedef PageSize = int;
typedef PageCount = int;

@Has()
typedef PageCountVar = ReadWriteValue<PageCount?>;
@Has()
typedef PageCountCallback = void Function(PageCount? pageCount);
typedef PageCountHolder = LateFinal<PageCount>;

typedef PageDimension = ({
  PageSize size,
  PageCount count,
});

Iterable<int> chunkIndices({
  required int itemCount,
  required PageSize pageSize,
  required PageNumber pageNumber,
}) {
  final from = pageSize * pageNumber;
  final rest = itemCount - from;
  assert(rest > 0);
  return integers(
    from: from,
  ).take(
    min(rest, pageSize),
  );
}

SizingWidget chunkedListSizingWidget({
  @ext required ColumnCtx columnCtx,
  required List<WxRectBuilder> items,
  required Dimension itemDimension,
  required SizingWidget emptySizingWidget,
  PagerBits? pagerBits,
}) {
  final themeWrap = columnCtx.renderCtxThemeWrap();
  return columnCtx.chunkedSizingWidget(
    itemDimension: itemDimension,
    itemCount: items.length,
    pagerBits: pagerBits,
    itemBuilder: (index, rectCtx) {
      return items[index].call(rectCtx);
    },
    dividerThickness: themeWrap.menuItemsDividerThickness,
    emptySizingWidget: emptySizingWidget,
  );
}

SizingWidget chunkedSizingWidget({
  @ext required ColumnCtx columnCtx,
  PagerBits? pagerBits,
  required Dimension itemDimension,
  required int itemCount,
  required Wx Function(int index, RectCtx rectCtx) itemBuilder,
  required double? dividerThickness,
  required SizingWidget emptySizingWidget,
}) {
  final effectivePagerBits =
      pagerBits ?? columnCtx.singleChunkedContentPagerBits();
  if (itemCount == 0) {
    effectivePagerBits.pageCountVar.writeValue(0);
    return emptySizingWidget;
  }

  final themeWrap = columnCtx.renderCtxThemeWrap();

  final intrinsicHeight =
      itemCount * itemDimension + (itemCount - 1) * (dividerThickness ?? 0);

  final pageDimensionHolder = SingleAssign<PageDimension?>.withDefault(
    callback: (value) =>
        effectivePagerBits.pageCountVar.writeValue(value?.count),
    defaultValue: null,
  );

  Wx createFooter() {
    final pagerOpener = mshShaftOpenerOf<PagerShaftFactory>(
      identifierAnyData: anyPagerKeyLift.lower(
        effectivePagerBits.pagerKey,
      ),
    );
    return columnCtx.wxLinearWidgets(
      widgets: [
        columnCtx.linearDivider(
          thickness: themeWrap.chunkedFooterDividerThickness,
        ),
        columnCtx.linearPadding(
          edgeInsets: themeWrap.chunkedFooterPaddingSizer.edgeInsets,
          builder: columnCtx.rigidPaddingBuilder$((deflatedCtx) {
            final row = deflatedCtx.createRowCtx();

            final pageCount = pageDimensionHolder.value?.count ?? 1;
            final effectivePageNumber = min(
              effectivePagerBits.pageNumberVar.watchValue(),
              pageCount - 1,
            );

            return row.wxLinearWidgets(widgets: [
              row
                  .wxAim(
                    watchAction: pagerOpener
                        .openShaftAction(shaftCtx: row)
                        .constantCall(),
                  )
                  .rigidWidgetWx(
                    linearCtx: row,
                  ),
              row.defaultTextShrinkingWidget(
                text: [
                  "$effectivePageNumber",
                  "[$pageCount]",
                ].join(" "),
              ),
            ]);
          }),
        )
      ],
      fill: false,
    ).wxDecorateShaftOpener(
      shaftOpener: pagerOpener,
      shaftCtx: columnCtx,
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
    final footerHeight = columnCtx.runWxSizing$(
      () => createFooter().sizeHeight(),
    );
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

  final holder = createDimensionHolder(
    onAssignDimension: (assignedHeight) {
      pageDimensionHolder.value = pageDimension(assignedHeight);
    },
  );

  return ComposedShrinkingWidget.assignDimensionBits(
    assignDimensionBits: holder,
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
        required Iterable<int> indices,
      }) sync* {
        final itemCtx =
            assignedCtx.linearWithMainDimension(dimension: itemDimension);

        final result = indices.map(
          (index) => itemBuilder(index, itemCtx).rigidWidgetWx(
            linearCtx: assignedCtx,
          ),
        );

        yield* result.iterableSeparatedByNullable(
          separator: dividerThickness?.let(assignedCtx.linearDivider$),
        );

        yield assignedCtx.linearGrowEmpty();
      }

      if (pageDimension.count < 2) {
        return assignedCtx.wxLinearWidgets(
          widgets: items(
            indices: integers().take(itemCount),
          ).toList(),
        );
      }
      final effectivePageNumber = min(
        pageDimension.count - 1,
        effectivePagerBits.pageNumberVar.readValue(),
      );
      return assignedCtx.wxLinearWidgets(
        widgets: [
          ...items(
            indices: chunkIndices(
              itemCount: itemCount,
              pageSize: pageDimension.size,
              pageNumber: effectivePageNumber,
            ),
          ),
          createFooter().rigidWidgetWx(
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
