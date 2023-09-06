part of 'main.dart';

ShaftActions sampleMainMenu(ShaftCtx shaftCtx) {
  // final focused = watchVar<ShaftFocusHandler>(null);

  return ComposedShaftActions.shaftLabel(
    shaftLabel: stringConstantShaftLabel("Main Menu"),
    callShaftContent: shaftMenuContent((shaftCtx) {
      return [
        sampleShaftOpener<SampleProtoShaftFactory>().shaftOpenerMenuItem(
          shaftCtx: shaftCtx,
        ),
        sampleAsyncShaftOpener<SampleProtoShaftFactory>(
          updateShaftInnerState: () {
            return CancelableOperation.fromFuture(
              Future.delayed(
                const Duration(
                  seconds: 2,
                ),
                () {
                  return (_) {};
                },
              ),
            );
          },
        ).asyncShaftOpenerMenuItem(
          shaftCtx: shaftCtx,
          elementId: null,
        ),
        // menuItemStatic(
        //   action: () {
        //     shaftCtx.shaftCtxRequestWindowFocus(
        //       elementId: null,
        //       handlePressedKey: (pressedKey, release) {
        //         if (pressedKey == PressedKey.escape) {
        //           release();
        //         }
        //       },
        //     );
        //   },
        //   label: "Async Opener",
        // ),
        menuItemStatic(
          action: shaftCtx.windowResetView,
          label: "Reset View",
        ),
      ];
    }),
    // callShaftFocusHandler: focused.watchValue,
    callShaftInterface: voidShaftInterface,
    callParseShaftIdentifier: keyOnlyShaftIdentifier,
  );
}
