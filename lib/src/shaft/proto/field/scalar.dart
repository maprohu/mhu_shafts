part of '../proto.dart';

@Compose()
abstract class ProtoScalarFieldShaftInterface<V extends Object>
    implements ProtoFieldShaftInterface, HasScalarTypeActions<V> {}

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

// ShaftDirectFocusContentActions
//     nullableScalarProtoFieldShaftContentActions<V extends Object>({
//   required ProtoFieldShaftInterface protoFieldShaftInterface,
//   required ScalarTypeActions<V> scalarTypeActions,
//   required SharingBox Function(RectCtx rectCtx, V value) builder,
// }) {
//   return ComposedShaftDirectFocusContentActions(
//     shaftContent: (rectCtx) sync* {
//       final msg = protoFieldShaftInterface.messageValue.watchValue();
//       if (msg == null) {
//         yield rectCtx.rectMessageSharingBox(
//           message: "Msg does not exist.",
//         );
//         return;
//       }
//       final value = scalarTypeActions.readFieldValue(
//         msg,
//         protoFieldShaftInterface.fieldCtx.callFieldCoordinates().fieldIndex,
//       );
//       if (value == null) {
//         yield rectCtx
//             .defaultTextCtx()
//             .wxTextHorizontal(text: "Value is null.")
//             .fixedVerticalSharingBox();
//       } else {
//         yield builder(rectCtx, value);
//       }
//     },
//   );
// }

