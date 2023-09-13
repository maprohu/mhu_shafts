part of '../shaft.dart';

@Compose()
abstract class PagerBits
    implements HasPageCountVar, HasPageNumberVar, HasPagerKey {}

class PagerShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    late final PagerKey pagerKey =
        shaftCtx.shaftObj.shaftIdentifierObj.shaftIdentifierData;

    late final shaftOnLeft = shaftCtx.shaftCtxOnLeft();

    late final pageCount = shaftOnLeft.shaftPageCount(
      pagerKey: pagerKey,
    );

    late final pageNumberVar = shaftOnLeft.shaftPageNumberVar(
      pagerKey: pagerKey,
    );

    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Pager"),
      callShaftContent: () {
        return (columnCtx) => pagerShaftContent(
              columnCtx: columnCtx,
              pageCount: pageCount,
              pageNumberVar: pageNumberVar,
            );
      },
      callShaftInterface: voidShaftInterface,
      callParseShaftIdentifier:
          anyPagerKeyLift.anyMsgLiftCallParseShaftIdentifier(),
      callLoadShaftEphemeralData: shaftWithoutEphemeralData,
      callShaftDataPersistence: shaftWithoutDataPersistence,
    );
  }
}

SizingWidgets pagerShaftContent({
  required ColumnCtx columnCtx,
  required PageCount? pageCount,
  required PageNumberVar pageNumberVar,
}) sync* {
  if (pageCount == null || pageCount < 2) {
    yield columnCtx.defaultTextRow(text: "PageCount: $pageCount");
    return;
  }

  final themeWrap = columnCtx.renderCtxThemeWrap();
  final currentPageNumber = min(
    pageCount - 1,
    pageNumberVar.watchValue(),
  );

  Wx item({
    required VoidCall aimAction,
    required String text,
    required bool selected,
  }) {
    return aimTextRow(
      columnCtx: columnCtx,
      watchAimAction: aimAction.constantCall(),
      text: text,
      textStyleWrap: themeWrap.pagerItemTextStyleWrap,
      backgroundColor: selected ? themeWrap.pagerSelectedBackgroundColor : null,
      edgeInsets: themeWrap.pagerItemPadding,
    ).createLinearWx(0);
  }

  final itemHeight = columnCtx.runWxSizing$(
    () => item(
      text: "X",
      aimAction: () {},
      selected: false,
    ).sizeHeight(),
  );

  final dividerThickness = themeWrap.pagerDividerThickness;

  final dividerWx = dividerThickness?.let(columnCtx.wxLinearDividerStretch$);

  final intrinsicDimension = itemsWithDividersDimension(
    itemCount: pageCount,
    itemDimension: itemHeight,
    dividerThickness: dividerThickness,
  );

  final holder = createDimensionHolder();
  yield ComposedShrinkingWidget.assignDimensionBits(
    assignDimensionBits: holder,
    intrinsicDimension: intrinsicDimension,
    createLinearWx: columnCtx.assignedRectWxStretched(
      holder: holder,
      builder: (rectCtx) {
        final fitCount = itemFitCount(
          available: holder.assignedDimension(),
          itemSize: itemHeight,
          dividerThickness: dividerThickness,
        );

        Wx build(Iterable<int> indices) => wxLinear(
              children: indices
                  .map(
                    (pageIndex) => item(
                      aimAction: () {
                        pageNumberVar.writeValue(pageIndex);
                      },
                      text: pageIndex.toString(),
                      selected: currentPageNumber == pageIndex,
                    ),
                  )
                  .iterableSeparatedByNullable(
                    separator: dividerWx,
                  ),
              axis: Axis.vertical,
              size: null,
            ).wxAlignVertical(
              size: rectCtx.size,
              axisAlignment: AxisAlignment.top,
            );
        if (fitCount >= pageCount) {
          return build(
            integers().take(pageCount),
          );
        }

        final indices = SomeInts(from: 0, until: pageCount);
        final indicesTrimmed = indices.intsShrinkSymmetric$(1);

        final currentIndex = SomeInts.single(currentPageNumber);
        final aroundCurrent = currentIndex.intsGrowSymmetric$(1);

        final jumpsAround = intsIntersect(
          a: indicesTrimmed,
          b: aroundCurrent,
        );
        final jumpsBefore = Ints.inclusive(
          from: indices.first,
          to: aroundCurrent.first,
        );
        final jumpsAfter = Ints.inclusive(
          from: aroundCurrent.last,
          to: indices.last,
        );

        final aroundList = jumpsAround.intsIterable().toList();

        final fixedCount = 2 + aroundList.length;

        final remainingCount = fitCount - fixedCount;

        final beforeTotal = jumpsBefore.intsShrinkSymmetric$(1).intsCount();
        final afterTotal = jumpsAfter.intsShrinkSymmetric$(1).intsCount();

        final beforeAfterTotal = beforeTotal + afterTotal;

        final beforeRatio = beforeTotal / beforeAfterTotal;

        final beforeSlots = (remainingCount * beforeRatio).round();
        final afterSlots = remainingCount - beforeSlots;

        Iterable<int> distribute({
          required Ints ints,
          required int count,
        }) sync* {
          if (ints case SomeInts()) {
            final step = ints.intsCount() / (count + 1);

            for (int i = 1; i <= count; i++) {
              yield (ints.from + (i * step)).round();
            }
          }
        }

        return build([
          0,
          ...distribute(
            ints: jumpsBefore,
            count: beforeSlots,
          ),
          ...jumpsAround.intsIterable(),
          ...distribute(
            ints: jumpsAfter,
            count: afterSlots,
          ),
          pageCount - 1,
        ]);
      },
    ),
  );
}
