part of 'main.dart';

class SampleProtoShaftFactory extends SampleShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    final sampleObj = shaftCtx.sampleConfigObj();
    final sampleWatch = sampleObj.sampleWatch;
    final messageCtx =
        sampleObj.schemaLookupByName.lookupMessageCtxOfType<SmpSampleMsg>();

    late final shaftInterface = ComposedProtoMessageShaftInterface(
      messageCtx: messageCtx,
      messageValue: sampleWatch,
    );
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Sample Proto"),
      callShaftContent: () => protoMessageShaftContent(
        messageCtx: messageCtx,
        messageValue: sampleWatch,
      ),
      callShaftFocusHandler: shaftWithoutFocus,
      callShaftInterface: () => shaftInterface,
      callParseShaftIdentifier: keyOnlyShaftIdentifier,
    );
  }
}
