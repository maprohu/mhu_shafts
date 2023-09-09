part of '../shaft_factory.dart';

ParseShaftIdentifier<void> keyOnlyShaftIdentifier() {
  return convertShaftIdentifier(
    dataConverter: (value) => null,
  );
}

ParseShaftIdentifier<T> convertShaftIdentifier<T>({
  required Convert<CmnAnyMsg, T> dataConverter,
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

ParseShaftIdentifier<List<String>> repeatedStringDataShaftIdentifier() {
  return convertShaftIdentifier(
    dataConverter: (value) => value.repeatedStringValue.stringValues,
  );
}
