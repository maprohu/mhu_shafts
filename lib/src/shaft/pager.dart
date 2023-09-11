part of '../shaft.dart';

class PagerShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Pager"),
      callShaftContent: () {
        return (rectCtx) sync* {};
      },
      callShaftInterface: voidShaftInterface,
      callParseShaftIdentifier:
          anyInt32Lift.anyMsgLiftCallParseShaftIdentifier(),
      callLoadShaftEphemeralData: shaftWithoutEphemeralData,
      callShaftDataPersistence: shaftWithoutDataPersistence,
    );
  }
}

AnyMsg pagerShaftIdentifier({
  @ext required ChunkedContentKey chunkedContentKey,
}) {
  return anyInt32Lift.lower(chunkedContentKey);
}
