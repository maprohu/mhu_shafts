part of 'main.dart';

class SampleProtoShaftFactory extends SampleShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    final sampleObj = shaftCtx.sampleConfigObj();
    final sampleFw = sampleObj.sampleFw;
    final scalarValue = sampleFw.toScalarValue;
    final messageCtx =
        sampleObj.schemaLookupByName.lookupMessageCtxOfType<SmpSampleMsg>();
    return ComposedShaftActions.shaftLabel(
      shaftLabel: staticShaftLabel("Sample Proto"),
      callShaftContent: () => protoMessageShaftContent(
        messageCtx: messageCtx,
        scalarValue: scalarValue,
      ),
      callShaftFocusHandler: shaftWithoutFocus,
      callShaftInterface: voidShaftInterface,
    );
  }
}
