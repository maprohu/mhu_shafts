part of 'main.dart';

ShaftActions sampleMainMenu(ShaftCtx shaftCtx) {
  return ComposedShaftActions.shaftLabel(
    shaftLabel: staticShaftLabel("Main Menu"),
    callShaftContent: shaftMenuContent((shaftCtx) {
      return [
        sampleShaftOpener<SampleProtoShaftFactory>().shaftOpenerMenuItem(
          shaftCtx: shaftCtx,
        ),
        menuItemStatic(
          action: shaftCtx.windowResetView,
          label: "Reset View",
        ),
      ];
    }),
    callShaftFocusHandler: shaftWithoutFocus,
    callShaftInterface: voidShaftInterface,
  );
}
