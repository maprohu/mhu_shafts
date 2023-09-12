part of '../shaft_factory.dart';

ParseShaftIdentifier<void> keyOnlyShaftIdentifier() {
  return convertShaftIdentifier(
    dataConverter: (value) => null,
  );
}

ParseShaftIdentifier<T> convertShaftIdentifier<T>({
  @ext required Convert<CmnAnyMsg, T> dataConverter,
}) {
  return (shaftIdentifierMsg) {
    return ShaftIdentifierObj(
      shaftFactoryKeyPath: shaftIdentifierMsg.shaftFactoryKeyPath.toIList(),
      shaftIdentifierData: dataConverter(shaftIdentifierMsg.anyData),
    );
  };
}

ParseShaftIdentifier<M> msgShaftIdentifierOf<M extends Msg>({
  @ext required CreateValue<M> create,
}) {
  return convertShaftIdentifier(
    dataConverter: (value) => create()
      ..mergeFromBuffer(value.singleValue.messageValue)
      ..freeze(),
  );
}

ParseShaftIdentifier<String> stringDataShaftIdentifier() {
  return convertShaftIdentifier(
    dataConverter: (value) => value.singleValue.scalarValue.stringValue,
  );
}

ParseShaftIdentifier<int> int32DataShaftIdentifier() {
  return convertShaftIdentifier(
    dataConverter: (value) => value.singleValue.scalarValue.int32Value,
  );
}

ParseShaftIdentifier<List<String>> repeatedStringDataShaftIdentifier() {
  return convertShaftIdentifier(
    dataConverter: (value) => value.repeatedStringValue.stringValues,
  );
}

final anyInt32Lift = ComposedLift<AnyMsg, int>(
  higher: (low) => low.singleValue.scalarValue.int32Value,
  lower: (high) => AnyMsg()
    ..ensureSingleValue().ensureScalarValue().int32Value = high
    ..freeze(),
);

final anyRepeatedInt32Lift = ComposedLift<AnyMsg, List<int>>(
  higher: (low) => low.repeatedInt32Value.int32Values,
  lower: (high) => AnyMsg()
    ..ensureRepeatedInt32Value().int32Values.addAll(high)
    ..freeze(),
);

Call<ParseShaftIdentifier<T>> anyMsgLiftCallParseShaftIdentifier<T>({
  @ext required AnyMsgLift<T> anyMsgLift,
}) {
  return () => convertShaftIdentifier(
        dataConverter: anyMsgLift.higher,
      );
}
