part of '../proto.dart';

ShaftDirectFocusContentActions stringProtoFieldShaftContentActions({
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required ScalarTypeActions<String> scalarTypeActions,
}) {
  return nullableMsgValueProtoFieldShaftContentActions(
    protoFieldShaftInterface: protoFieldShaftInterface,
    typeActions: scalarTypeActions,
    builder: (rectCtx, value) sync* {
      yield rectCtx.defaultMonoTextCtx().monoTextCtxSharingBox(
        string: value,
      );
    },
  );
}
