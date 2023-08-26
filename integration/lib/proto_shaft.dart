part of 'main.dart';

class SampleProtoShaftFactory extends SampleShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    return ComposedShaftActions.shaftLabel(
      shaftLabel: staticShaftLabel("Sample Proto"),
      callShaftContent: shaftMenuContent((shaftCtx) {
        return [];
      }),
      callShaftFocusHandler: shaftWithoutFocus,
      callShaftInterface: voidShaftInterface,
    );
  }
}
