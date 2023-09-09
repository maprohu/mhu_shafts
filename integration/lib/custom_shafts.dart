part of 'main.dart';

ShaftActions sampleCustomShaftActions(ShaftCtx shaftCtx) {
  final shaftIdentifier = shaftCtx.shaftObj.shaftIdentifier;

  return sampleShaftFactories
      .shaftFactoriesLookupKey(
        shaftFactoryKey: shaftIdentifier.shaftFactoryKeyPath[1],
      )
      .buildShaftActions(shaftCtx);
      // .mshCustomShaftActions();
}

abstract class SampleShaftFactory extends ShaftFactory {}

final ShaftFactories sampleShaftFactories = Singletons.mixin({
  0: SampleProtoShaftFactory(),
  1: SampleAsyncShaftFactory(),
  2: SampleFileSystemRootShaftFactory(),
  // 3: SampleFileSystemDirectoryShaftFactory(),
});

ShaftOpener sampleShaftOpener<F extends SampleShaftFactory>({
  CmnAnyMsg? identifierAnyData,
  // UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  assert(F != SampleShaftFactory);
  return sampleShaftFactories
      .factoriesShaftOpenerOf<F>(
        identifierAnyData: identifierAnyData,
        // updateShaftInnerState: updateShaftInnerState,
      )
      .mshCustomShaftOpener();
}
// AsyncShaftOpener sampleAsyncShaftOpener<F extends SampleShaftFactory>({
//   CmnAny? identifierAnyData,
//   required AsyncUpdateShaftInnerState updateShaftInnerState,
// }) {
//   assert(F != SampleShaftFactory);
//   return sampleShaftFactories
//       .factoriesAsyncShaftOpenerOf<F>(
//     identifierAnyData: identifierAnyData,
//     updateShaftInnerState: updateShaftInnerState,
//   )
//       .mshCustomAsyncShaftOpener();
// }
