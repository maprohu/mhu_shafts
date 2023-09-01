import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/control.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/model.dart';
export 'package:mhu_shafts/src/context/window.dart';
import '../../proto.dart';
import '../layout.dart';
import '../wx/wx.dart';
import 'render.dart' as $lib;

part 'render.g.has.dart';

part 'render.g.dart';

part 'render.freezed.dart';

part 'render/aim.dart';

@Has()
class RenderObj with MixRenderCtx {
  late final windowStateMsg = renderCtx.dataObj.windowStateFw.watch();

  late final themeWrap = renderCtx.appObj.themeWrapFr.watch();
  late final themeMsg = themeWrap.themeMsg;

  late final controlWrap = renderCtx.dataObj.controlWrapFr.watch();

  late final screenSize = renderCtx.windowObj.screenSizeFr.watch();
  late final screenHeight = screenSize.height;
  late final screenWidthPixels = screenSize.width;

  late final topShaft = windowStateMsg.getEffectiveTopShaft();
  late final shaftIterableLeft =
      topShaft.finiteIterable((item) => item.parentOpt);
  late final shaftCount = shaftIterableLeft.length;
  late final maxShaftIndex = shaftCount - 1;

  late final shaftOnRightEnd = renderCtx.createShaftCtx(
    shaftMsg: topShaft,
    shaftOnRight: null,
  );

  late final shaftsDividerThickness = themeWrap.shaftsDividerThickness;
  late final availableScreenWidthPixels =
      screenWidthPixels + themeWrap.shaftsDividerThickness;

  late final shaftWidthUnitsFitCount = itemFitCount(
    available: availableScreenWidthPixels,
    itemSize: themeWrap.minShaftWidthPixels + themeWrap.shaftsDividerThickness,
    dividerThickness: themeWrap.shaftsDividerThickness,
  );

  late final visibleShafts = shaftOnRightEnd
      .shaftCtxLeftIterable()
      .takeWhile((e) => e.shaftObj.isVisible)
      .toList()
      .reversed
      .toIList();

  late final totalVisibleShaftWidthUnits = visibleShafts.sumBy(
    (e) => e.shaftObj.visibleWidthUnits,
  );

  late final visibleShaftUnitInPixels =
      availableScreenWidthPixels / totalVisibleShaftWidthUnits;

  late final HandlePressedKey? focusedHandler;

  late final aimsBuilder = createAimsBuilder(
    focusedHandler: focusedHandler,
  );

  late final aimsRegistry = aimsBuilder.aimRegistry;

  late final handlePressedKey = aimsBuilder.buildAims(
    controlAimKeysCollectionProvider(
      controlWrap: controlWrap,
    ),
  );
}

@Compose()
@Has()
abstract class RenderCtx implements WindowCtx, HasRenderObj {}

RenderCtx createRenderCtx({
  @Ext() required WindowCtx windowCtx,
}) {
  final renderObj = RenderObj();

  return ComposedRenderCtx.windowCtx(
    windowCtx: windowCtx,
    renderObj: renderObj,
  )..initMixRenderCtx(renderObj);
}

RenderedView watchRenderRenderedView({
  @extHas required RenderObj renderObj,
}) {
  final visibleShafts = renderObj.visibleShafts;

  final shaftsThatNeedFocus = visibleShafts
      .map((shaftCtx) {
        final shaftObj = shaftCtx.shaftObj;
        return shaftObj.shaftActions.callShaftFocusHandler();
      })
      .whereNotNull()
      .toList();

  switch (shaftsThatNeedFocus) {
    case []:
      renderObj.focusedHandler = null;
    case [final focusedShaft]:
      renderObj.focusedHandler = focusedShaft;
    case [..., final focusedShaft]:
      logger.w("multiple focused shafts: $shaftsThatNeedFocus");
      renderObj.focusedHandler = focusedShaft;
  }

  final shafts = visibleShafts
      .reversedIListIterable()
      .map((shaftCtx) {
        final shaftObj = shaftCtx.shaftObj;
        final shaftWidthPixels = renderObj.visibleShaftWidthPixels(
          units: shaftObj.visibleWidthUnits,
        );

        final rectCtx = shaftCtx.createRectCtx(
          size: Size(
            shaftWidthPixels,
            renderObj.screenHeight,
          ),
        );

        return rectCtx.renderShaft();
      })
      .toIList()
      .reversed
      .toIList();

  final handlePressedKey = renderObj.handlePressedKey;

  return RenderedView(
    shaftsLayout: ShaftsLayout(
      shafts: shafts,
      renderObj: renderObj,
    ),
    onKeyEvent: (keyEvent) {
      final pressedKey = keyEvent.keyEventToPressedKey();

      if (pressedKey != null) {
        handlePressedKey(pressedKey);
      }
    },
  );
}

WindowStateMsg getRenderStateMsg({
  @extHas required RenderObj renderObj,
}) {
  return renderObj.windowStateMsg;
}

double visibleShaftWidthPixels({
  @extHas required RenderObj renderObj,
  required ShaftWidthUnit units,
}) {
  return renderObj.visibleShaftUnitInPixels * units -
      renderObj.shaftsDividerThickness;
}

@freezedStruct
class ShaftLayout with _$ShaftLayout {
  const ShaftLayout._();

  const factory ShaftLayout({
    required Int64 shaftSeq,
    required ShaftWidthUnit shaftWidthUnits,
    required Wx wx,
  }) = _ShaftLayout;
}

@freezedStruct
class ShaftsLayout with _$ShaftsLayout {
  const ShaftsLayout._();

  const factory ShaftsLayout({
    required IList<ShaftLayout> shafts,
    required RenderObj renderObj,
  }) = _ShaftsLayout;
}

int shaftLayoutTotalWidthUnits({
  @ext required ShaftsLayout shaftsLayout,
}) {
  if (shaftsLayout.shafts.isEmpty) {
    return 1;
  }

  return shaftsLayout.shafts.sumBy(
    (element) => element.shaftWidthUnits,
  );
}

ThemeWrap renderCtxThemeWrap({
  @extHas required RenderObj renderObj,
}) {
  return renderObj.themeWrap;
}
