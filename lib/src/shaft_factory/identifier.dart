part of '../shaft_factory.dart';

ParseShaftIdentifier keyOnlyShaftIdentifier() {
  return (shaftIdentifierMsg) {
    return ShaftIdentifierObj(
      shaftFactoryKey: shaftIdentifierMsg.shaftFactoryKey,
      shaftIdentifierData: null,
    );
  };
}

ParseShaftIdentifier<M> parseShaftIdentifierOf<M extends Msg>({
  @ext required CreateValue<M> create,
}) {
  return (shaftIdentifierMsg) {
    return ShaftIdentifierObj<M>(
      shaftFactoryKey: shaftIdentifierMsg.shaftFactoryKey,
      shaftIdentifierData: create()
        ..mergeFromBuffer(shaftIdentifierMsg.anyData.data)
        ..freeze(),
    );
  };
}
