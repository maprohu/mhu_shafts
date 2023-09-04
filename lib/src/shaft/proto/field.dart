part of 'proto.dart';

@Compose()
abstract class ProtoFieldShaftInterface
    implements ProtoMessageShaftInterface, HasFieldCtx {}

@Compose()
abstract class ProtoScalarFieldShaftInterface<V extends Object>
    implements ProtoFieldShaftInterface, HasScalarTypeActions<V> {}

class ProtoFieldShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    late final parse =
        MshShaftIdentifierMsg_Field.create.parseShaftIdentifierOf();

    late final ProtoMessageShaftInterface messageInterface =
        shaftCtx.shaftCtxOnLeft().shaftCtxInterface();

    late final messageCtx = messageInterface.messageCtx;

    late final shaftIdentifierObj = parse(shaftCtx.shaftObj.shaftIdentifier);

    late final tagNumber = shaftIdentifierObj.shaftIdentifierData.tagNumber;

    late final fieldCtx = messageCtx.lookupFieldByTagNumber(tagNumber);

    late final fieldInterface =
        ComposedProtoFieldShaftInterface.protoMessageShaftInterface(
      protoMessageShaftInterface: messageInterface,
      fieldCtx: fieldCtx,
    );

    return ComposedShaftActions.merge$(
      callParseShaftIdentifier: () => parse,
      shaftLabel: stingCallShaftLabel(
        () => fieldCtx.fieldProtoName,
      ),
      shaftContentActions: callContentActions(
        call: () => fieldInterface.protoFieldContentActions(),
      ),
    );
  }
}

ShaftDirectContentActions protoFieldContentActions({
  @ext required ProtoFieldShaftInterface protoFieldShaftInterface,
}) {
  final typeActions = protoFieldShaftInterface.fieldCtx.typeActions;

  switch (typeActions) {
    case ScalarTypeActions():
      final ProtoScalarFieldShaftInterface scalarInterface =
          typeActions.singleTypeGeneric(
        <V extends Object>() {
          return protoScalarFieldShaftInterface(
            protoFieldShaftInterface: protoFieldShaftInterface,
            scalarTypeActions: typeActions.castScalarTypeActions<V>(),
          );
        },
      );
      return ComposedShaftDirectContentActions.shaftDirectFocusContentActions(
        shaftDirectFocusContentActions: scalarProtoFieldFocusContentActions(
          scalarTypeActions: typeActions,
          protoFieldShaftInterface: protoFieldShaftInterface,
        ),
        shaftInterface: scalarInterface,
      );
    default:
      return todoShaftDirectContentActions(
        message: typeActions,
        stackTrace: StackTrace.current,
      );
  }
}

ProtoScalarFieldShaftInterface<V>
    protoScalarFieldShaftInterface<V extends Object>({
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required ScalarTypeActions<V> scalarTypeActions,
}) {
  return ComposedProtoScalarFieldShaftInterface<V>.protoFieldShaftInterface(
    protoFieldShaftInterface: protoFieldShaftInterface,
    scalarTypeActions: scalarTypeActions,
  );
}

ShaftDirectFocusContentActions scalarProtoFieldFocusContentActions({
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required ScalarTypeActions scalarTypeActions,
}) {
  final scalarTypeEnm = scalarTypeActions.scalarTypeEnm;
  switch (scalarTypeEnm) {
    case ScalarTypes.TYPE_STRING:
      return stringProtoFieldShaftContentActions(
        scalarTypeActions: scalarTypeActions.castScalarTypeActions<String>(),
        protoFieldShaftInterface: protoFieldShaftInterface,
      );
    case ScalarTypes.TYPE_INT32:
    case ScalarTypes.TYPE_UINT32:
    case ScalarTypes.TYPE_SINT32:
    case ScalarTypes.TYPE_FIXED32:
    case ScalarTypes.TYPE_SFIXED32:
      return intProtoFieldShaftContentActions(
        scalarTypeActions: scalarTypeActions.castScalarTypeActions<int>(),
        protoFieldShaftInterface: protoFieldShaftInterface,
      );
    default:
      return todoShaftDirectContentActions(
        message: scalarTypeEnm,
        stackTrace: StackTrace.current,
      );
  }
}

ShaftDirectFocusContentActions stringProtoFieldShaftContentActions({
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required ScalarTypeActions<String> scalarTypeActions,
}) {
  return nullableScalarProtoFieldShaftContentActions(
    protoFieldShaftInterface: protoFieldShaftInterface,
    scalarTypeActions: scalarTypeActions,
    builder: (rectCtx, value) {
      return rectCtx.defaultMonoTextCtx().monoTextCtxSharingBox(
            string: value,
          );
    },
  );
}

ShaftDirectFocusContentActions intProtoFieldShaftContentActions({
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required ScalarTypeActions<int> scalarTypeActions,
}) {
  return nullableScalarProtoFieldShaftContentActions(
    protoFieldShaftInterface: protoFieldShaftInterface,
    scalarTypeActions: scalarTypeActions,
    builder: (rectCtx, value) {
      return rectCtx.defaultMonoTextCtx().monoTextCtxSharingBox(
            string: value.toString(),
          );
    },
  );
}

ShaftDirectFocusContentActions
    nullableScalarProtoFieldShaftContentActions<V extends Object>({
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required ScalarTypeActions<V> scalarTypeActions,
  required SharingBox Function(RectCtx rectCtx, V value) builder,
}) {
  return ComposedShaftDirectFocusContentActions(
    shaftContent: (rectCtx) sync* {
      final msg = protoFieldShaftInterface.messageValue.watchValue();
      if (msg == null) {
        yield rectCtx.rectMessageSharingBox(
          message: "Msg does not exist.",
        );
        return;
      }
      final value = scalarTypeActions.readFieldValue(
        msg,
        protoFieldShaftInterface.fieldCtx.callFieldCoordinates().fieldIndex,
      );
      if (value == null) {
        yield rectCtx
            .defaultTextCtx()
            .wxTextHorizontal(text: "Value is null.")
            .fixedVerticalSharingBox();
      } else {
        yield builder(rectCtx, value);
      }
    },
  );
}
