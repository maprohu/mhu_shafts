part of '../shaft.dart';

@Compose()
abstract class PagerBits
    implements HasPageCountVar, HasPageNumberVar, HasPagerKey {}

class PagerShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    late final PagerKey pagerKey =
        shaftCtx.shaftObj.shaftIdentifierObj.shaftIdentifierData;

    late final pageCount = shaftCtx.shaftCtxOnLeft().shaftPageCount(
          pagerKey: pagerKey,
        );
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Pager"),
      callShaftContent: () {
        return (columnCtx) => pagerShaftContent(
              columnCtx: columnCtx,
              pageCount: pageCount,
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
}) sync* {
  if (pageCount == null || pageCount < 2) {
    yield columnCtx.defaultTextRow(text: "PageCount: $pageCount");
    return;
  }

  final themeWrap = columnCtx.renderCtxThemeWrap();

  RigidWidget item({
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
    );
  }

  final itemHeight = columnCtx.runWxSizing$(
    () => item(
      text: "X",
      aimAction: () {},
      selected: false,
    ).intrinsicDimension,
  );

  final dividerThickness = themeWrap.pagerDividerThickness;

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

        if (fitCount >= pageCount) {
          return rectCtx.defaultTextCtx().wxTextAlign(text: "all fits");
        }

        return rectCtx.defaultTextCtx().wxTextAlign(text: "not all fits");
      },
    ),
  );
}
