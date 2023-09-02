part of 'proto.dart';

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

    return ComposedShaftActions.merge$(
      callParseShaftIdentifier: () => parse,
      shaftLabel: stingCallShaftLabel(
        () => fieldCtx.fieldProtoName,
      ),
      shaftContentActions: callContentActions(
        call: () => protoFieldContentActions(
          fieldCtx: fieldCtx,
        ),
      ),
    );
  }
}

ShaftDirectContentActions protoFieldContentActions({
  required FieldCtx fieldCtx,
}) {
  final typeActions = fieldCtx.typeActions;

  ShaftDirectContentActions todo(Object message) {
    logger.w(
      message,
      stackTrace: StackTrace.current,
    );
    return ComposedShaftDirectContentActions(
      shaftContent: message.toString().constantStringTextShaftContent(),
      shaftInterface: voidShaftInterface,
    );
  }

  switch (typeActions) {
    case ScalarTypeActions():
      final scalarTypeEnm = typeActions.scalarTypeEnm;
      switch (scalarTypeEnm) {
        default:
          return todo(scalarTypeEnm);
      }
    default:
      return todo(typeActions);
  }
}
