part of '../proto.dart';

ShaftDirectFocusContentActions intProtoFieldShaftContentActions({
  required ProtoFieldShaftInterface protoFieldShaftInterface,
  required ScalarTypeActions<int> scalarTypeActions,
}) {
  return nullableMsgValueProtoFieldShaftContentActions(
    protoFieldShaftInterface: protoFieldShaftInterface,
    typeActions: scalarTypeActions,
    builder: (rectCtx, value) sync* {
      yield rectCtx.defaultMonoTextCtx().monoTextCtxSharingBox(
        string: value.toString(),
      );
    },
  );
}
