part of '../rect.dart';

@Has()
typedef WatchMenuItemSelected = WatchValue<bool>;

@Compose()
abstract class MenuItem
    implements HasWatchAimAction, HasWxRectBuilder, HasWatchMenuItemSelected {}

SharingBox menuRectSharingBox({
  @ext required RectCtx rectCtx,
  required List<MenuItem> items,
  double? itemHeight,
}) {
  final themeWrap = rectCtx.renderCtxThemeWrap();
  itemHeight ??= themeWrap.menuItemPaddingSizer.callOuterHeight();
  return rectCtx.chunkedRectVerticalSharingBox(
    itemHeight: itemHeight,
    itemCount: items.length,
    startAt: 0,
    itemBuilder: (index, rectCtx) {
      final item = items[index];
      return rectCtx
          .wxRectPaddingSizer(
            paddingSizer: themeWrap.menuItemPaddingSizer,
            builder: (rectCtx) {
              return rectCtx.wxRectFillRight(
                left: [
                  rectCtx.wxRectAimWatch(
                    watchAction: item.watchAimAction,
                    horizontal: null,
                    vertical: AxisAlignment.center,
                  ),
                ],
                right: item.wxRectBuilder,
              );
            },
          )
          .wxAlignVertical(
            size: rectCtx.size,
          )
          .wxDecorateShaftOpenBool(
            isOpen: item.watchMenuItemSelected(),
            themeWrap: themeWrap,
          );
    },
    dividerThickness: themeWrap.menuItemsDividerThickness,
  );
}

MenuItem menuItemStatic({
  required VoidCallback action,
  required String label,
}) {
  return menuItemStaticAction(
    action: action,
    wxRectBuilder: (rectCtx) {
      return wxMenuItemLabelString(
        rectCtx: rectCtx,
        label: label,
      );
    },
    watchMenuItemSelected: () => false,
  );
}

MenuItem menuItemStaticAction({
  required VoidCallback action,
  required WxRectBuilder wxRectBuilder,
  required WatchMenuItemSelected watchMenuItemSelected,
}) {
  return ComposedMenuItem(
    watchAimAction: () => action,
    wxRectBuilder: wxRectBuilder,
    watchMenuItemSelected: watchMenuItemSelected,
  );
}

MenuItem mshShaftOpenerMenuItem<F extends ShaftFactory>({
  @ext required ShaftCtx shaftCtx,
  CmnAny? anyData,
  UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  return factoriesShaftOpenerMenuItem<F>(
    shaftCtx: shaftCtx,
    shaftFactories: mshShaftFactories,
    identifierAnyData: anyData,
    updateShaftInnerState: updateShaftInnerState,
  );
}

MenuItem factoriesShaftOpenerMenuItem<F extends ShaftFactory>({
  @ext required ShaftCtx shaftCtx,
  @ext required ShaftFactories shaftFactories,
  CmnAny? identifierAnyData,
  UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  assert(F != ShaftFactory);
  final shaftOpener = shaftFactories.factoriesShaftOpenerOf<F>(
    updateShaftInnerState: updateShaftInnerState,
    identifierAnyData: identifierAnyData,
  );

  return shaftOpenerMenuItem(
    shaftOpener: shaftOpener,
    shaftCtx: shaftCtx,
  );
}

MenuItem shaftOpenerMenuItem({
  @ext required ShaftOpener shaftOpener,
  @ext required ShaftCtx shaftCtx,
}) {
  final openedShaftCtx = createOpenedShaftCtx(
    shaftOpener: shaftOpener,
    shaftCtx: shaftCtx,
  );
  final shaftObj = openedShaftCtx.shaftObj;

  return menuItemStaticAction(
    action: shaftOpener.openShaftAction(
      shaftCtx: shaftCtx,
    ),
    wxRectBuilder: shaftObj.shaftActions.callShaftOpenerLabel(),
    watchMenuItemSelected: () {
      return isShaftOpen(
        shaftOpener: shaftOpener,
        shaftCtx: shaftCtx,
      );
    },
  );
}

TextCtx menuItemText({
  @ext required RectCtx rectCtx,
}) {
  return createTextCtx(
    rectCtx: rectCtx,
    textStyleWrap: rectCtx.renderObj.themeWrap.menuItemTextStyleWrap,
  );
}

Wx wxMenuItemLabelString({
  @ext required RectCtx rectCtx,
  required String label,
}) {
  return rectCtx.menuItemText().wxTextHorizontal(
        text: label,
      );
}
