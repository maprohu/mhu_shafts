part of 'main.dart';

class SampleProtoShaftFactory extends SampleShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    final sampleObj = shaftCtx.sampleConfigObj();
    final sampleFw = sampleObj.sampleFw;
    final scalarValue = sampleFw.toScalarValue;
    final messageCtx =
        sampleObj.schemaLookupByName.lookupMessageCtxOfType<SmpSampleMsg>();

    late final shaftInterface = ComposedProtoMessageShaftInterface(
      messageCtx: messageCtx,
      msgScalarValue: scalarValue,
    );
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Sample Proto"),
      callShaftContent: () => protoMessageShaftContent(
        messageCtx: messageCtx,
        scalarValue: scalarValue,
      ),
      callShaftFocusHandler: shaftWithoutFocus,
      callShaftInterface: () => shaftInterface,
      callParseShaftIdentifier: keyOnlyShaftIdentifier,
    );
  }
}
