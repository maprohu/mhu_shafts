part of '../rect.dart';

TextSpan aimTextSpan({
  required AimState aimState,
  required ThemeWrap themeWrap,
}) {
  return TextSpan(
    children: [
      TextSpan(
        text: aimState.pressed,
        style: themeWrap.aimPressedTextStyle,
      ),
      TextSpan(
        text: aimState.notPressed,
        style: themeWrap.aimTextStyle,
      ),
    ],
  );
}

Wx wxRectAim({
  @ext required RectCtx rectCtx,
  required VoidCallback action,
  required AxisAlignment? horizontal,
  required AxisAlignment? vertical,
}) {
  return wxRectAimWatch(
    rectCtx: rectCtx,
    watchAction: () => action,
    horizontal: horizontal,
    vertical: vertical,
  );
}

Wx wxRectAimWatch({
  @ext required RectCtx rectCtx,
  required WatchAimAction watchAction,
  required AxisAlignment? horizontal,
  required AxisAlignment? vertical,
}) {
  final themeWrap = rectCtx.renderCtxThemeWrap();

  final aimWxSize = themeWrap.aimWxSize;

  final registeredAim = rectCtx.renderObj.aimsRegistry.registerAim(watchAction);

  return wxSizedBox(
    widget: flcFrr(() {
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
  ).wxAlign(
    size: aimWxSize,
    vertical: vertical,
    horizontal: horizontal,
  );
}
