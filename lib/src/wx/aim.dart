part of 'wx.dart';

Wx wxAim({
  @extHas required RenderObj renderObj,
  required WatchAimAction watchAction,
}) {
  final themeWrap = renderObj.renderCtxThemeWrap();

  final aimWxSize = themeWrap.aimWxSize;

  final registeredAim = renderObj.aimsRegistry.registerAim(watchAction);

  return wxSizedBox(
    widget: watchWidget(() {
      final aimState = registeredAim.watchAimState();

      if (aimState == null) {
        return nullWidget;
      }

      final action = watchAction();

      if (action == null) {
        return nullWidget;
      }

      return aimTextSpan(
        aimState: aimState,
        themeWrap: themeWrap,
      ).createRichText().centered();
    }),
    size: aimWxSize,
  );
}
