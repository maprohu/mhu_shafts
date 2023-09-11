part of '../shaft_factory.dart';

typedef ShaftPersistedData = dynamic;

@Has()
typedef ShaftPersistedDataLift<T> = BinaryLift<T>;

@Has()
typedef InitShaftPersistedData<T> = Call<T>;

@Has()
typedef ShaftDataPersistence = ShaftPersistedDataActions?;

@Compose()
abstract class ShaftPersistedDataActions<T>
    implements
        HasShaftPersistedDataLift<T>,
        HasInitShaftPersistedData<T>,
        HasTypeGenericFunction<Object> {}

ShaftDataPersistence shaftWithoutDataPersistence() => null;

ShaftDataPersistence shaftWithDefaultPersistence() {
  return ComposedShaftPersistedDataActions<MshShaftDataMsg>(
    shaftPersistedDataLift: MshShaftDataMsg.create.createBinaryProtoLift(),
    initShaftPersistedData: MshShaftDataMsg.getDefault,
    typeGenericFunction: genericFunction1<Object, MshShaftDataMsg>(),
  );
}
