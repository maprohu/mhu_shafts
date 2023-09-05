part of 'proto.dart';

@Compose()
abstract class ProtoFieldShaftInterface
    implements ProtoMessageShaftInterface, HasFieldCtx {}

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

    case MapTypeActions():
      return protoMapFieldContentActions(
        protoFieldShaftInterface: protoFieldShaftInterface,
        mapTypeActions: typeActions,
      );
    default:
      return todoShaftDirectContentActions(
        message: typeActions,
        stackTrace: StackTrace.current,
      );
  }
}

SharingBoxes rectCtxNullableMsgSharingBoxes<V>({
  @ext required RectCtx rectCtx,
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required TypeActions<V> typeActions,
  required SharingBoxes Function(V value) builder,
}) sync* {
  final msg = protoFieldShaftInterface.messageValue.watchValue();
  if (msg == null) {
    yield rectCtx.rectMessageSharingBox(
      message: "Msg is null.",
    );
    return;
  }

  final value = typeActions.readFieldValue(
    msg,
    protoFieldShaftInterface.fieldCtx.callFieldCoordinates().fieldIndex,
  );

  yield* builder(value);
}

ShaftDirectFocusContentActions
    nullableMsgProtoFieldShaftContentActions<V extends Object>({
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required TypeActions<V> typeActions,
  required SharingBoxes Function(RectCtx rectCtx, V value) builder,
}) {
  return ComposedShaftDirectFocusContentActions(
    shaftContent: (rectCtx) {
      return rectCtx.rectCtxNullableMsgSharingBoxes(
        protoFieldShaftInterface: protoFieldShaftInterface,
        typeActions: typeActions,
        builder: (value) sync* {
          yield* builder(rectCtx, value);
        },
      );
    },
  );
}

ShaftDirectFocusContentActions
    nullableMsgValueProtoFieldShaftContentActions<V extends Object>({
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required TypeActions<V?> typeActions,
  required SharingBoxes Function(RectCtx rectCtx, V value) builder,
}) {
  return ComposedShaftDirectFocusContentActions(
    shaftContent: (rectCtx) {
      return rectCtx.rectCtxNullableMsgSharingBoxes(
        protoFieldShaftInterface: protoFieldShaftInterface,
        typeActions: typeActions,
        builder: (value) sync* {
          if (value == null) {
            yield rectCtx
                .defaultTextCtx()
                .wxTextHorizontal(text: "Value is null.")
                .fixedVerticalSharingBox();
          } else {
            yield* builder(rectCtx, value);
          }
        },
      );
    },
  );
}
