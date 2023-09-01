part of 'proto.dart';

ShaftContent protoMessageShaftContent<M extends Msg>({
  @ext required MessageCtx messageCtx,
  @ext required ScalarValue<M> scalarValue,
}) {
  return (rectCtx) {
    final msg = scalarValue.watchValue();
    if (msg == null) {
      final monoTextCtx = rectCtx.createMonoTextCtx(
        monoTextStyle: rectCtx.renderCtxThemeWrap().stringTextStyle,
      );
      return [
        monoTextCtx.monoTextCtxSharingBox(string: "hello"),
      ];
    }
    final monoTextCtx = rectCtx.createMonoTextCtx(
      monoTextStyle: rectCtx.renderCtxThemeWrap().stringTextStyle,
    );
    return [
      monoTextCtx.monoTextCtxSharingBox(string: "hello"),
    ];
    // return [
    //   rectCtx.chunkedListRectVerticalSharingBox(
    //     itemHeight: rectCtx.renderObj.themeWrap.protoFieldItemOuterHeight,
    //     items: [
    //       ...messageCtx.callLogicalFieldsList().expand((logicalFieldCtx) {
    //         return pro(
    //           action: () {},
    //           label: logicalFieldCtx.fieldProtoName,
    //         );
    //       }),
    //     ],
    //   ),
    // ];
  };
}

Iterable<Wx> protoMessageFieldWx({
  required LogicalFieldCtx logicalFieldCtx,
  required double width,
  required Wx aimWx,
  required String label,
  required String value,
}) sync* {}

double calculateProtoMessageFieldItemInnerHeight({
  @ext required ThemeWrap themeWrap,
}) {
  return max(
    themeWrap.aimWxSize.height,
    themeWrap.protoFieldLabelTextStyleWrap.textHeight +
        themeWrap.protoFieldValueTextStyleWrap.textHeight +
        themeWrap.protoFieldLabelValueGapHeight,
  );
}
