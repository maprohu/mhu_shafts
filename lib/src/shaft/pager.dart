part of '../shaft.dart';

@Compose()
abstract class PagerBits
    implements HasPageCountVar, HasPageNumberVar, HasPagerKey {}

class PagerShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    late final PagerKey pagerKey =
        shaftCtx.shaftObj.shaftIdentifierObj.shaftIdentifierData;

    late final pageCount = shaftCtx.shaftCtxOnLeft().shaftPageCount(
          pagerKey: pagerKey,
        );
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Pager"),
      callShaftContent: () {
        return (rectCtx) sync* {
          yield rectCtx.defaultTextRow(text: "${pageCount}");
        };
      },
      callShaftInterface: voidShaftInterface,
      callParseShaftIdentifier:
          anyPagerKeyLift.anyMsgLiftCallParseShaftIdentifier(),
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
