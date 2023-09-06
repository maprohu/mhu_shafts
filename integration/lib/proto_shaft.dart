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
      protoCustomizer: ProtoCustomizer(),
    );
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Sample Proto"),
      callShaftContent: () => shaftInterface.protoMessageShaftContent(),
      callShaftInterface: () => shaftInterface,
      callParseShaftIdentifier: keyOnlyShaftIdentifier,
    );
  }
}
