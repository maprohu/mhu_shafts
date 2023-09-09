part of 'main.dart';

class SampleAsyncShaftFactory extends SampleShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Sample Async"),
      callShaftContent: () {
        return (rectCtx) sync* {
          // final String text = shaftCtx.shaftObj.ephemeralData;
          //
          // return rectMonoTextSharingBoxes(
          //   rectCtx: rectCtx,
          //   text: text,
          // );
        };
      },
      callShaftInterface: voidShaftInterface,
      callParseShaftIdentifier: keyOnlyShaftIdentifier,
      callLoadShaftEphemeralData: () {
        return (disposers) {
          return CancelableOperation.fromFuture(
            // fileSystemRoots(disposers),
            Future.value(null),
          );
        };
      },
    );
  }
}
