part of 'main.dart';

ShaftActions sampleCustomShaftActions(ShaftCtx shaftCtx) {
  final shaftIdentifier = shaftCtx.shaftObj.shaftIdentifier.anyData.data.let(
    MshShaftIdentifierMsg.fromBuffer,
  )..freeze();

  return sampleShaftFactories
      .shaftFactoriesLookupKey(
        shaftFactoryKey: shaftIdentifier.shaftFactoryKey,
      )
      .buildShaftActions(shaftCtx);
}

abstract class SampleShaftFactory extends ShaftFactory {}

final ShaftFactories sampleShaftFactories =
    Singletons.mixin({
  0: SampleProtoShaftFactory(),
});

ShaftOpener sampleShaftOpener<F extends SampleShaftFactory>({
  CmnAny? identifierAnyData,
  UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  assert(F != SampleShaftFactory);
  return sampleShaftFactories
      .factoriesShaftOpenerOf<F>(
        identifierAnyData: identifierAnyData,
        updateShaftInnerState: updateShaftInnerState,
      )
      .mshCustomShaftOpener();
}
