part of 'proto.dart';

ShaftContent protoMessageShaftContent<M extends Msg>({
  @ext required MessageCtx messageCtx,
  @ext required ScalarValue<M> scalarValue,
}) {
  return (rectCtx) {
    return [
      rectCtx.menuRectSharingBox(items: []),
    ];
  };
}
