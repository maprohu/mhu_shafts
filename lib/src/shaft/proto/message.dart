part of 'proto.dart';

@Compose()
abstract class ProtoMessageShaftInterface
    implements HasMessageCtx, HasMessageValue {}

ShaftContent protoMessageShaftContent<M extends Msg>({
  @ext required MessageCtx messageCtx,
  @ext required MessageValue<M> messageValue,
}) {
  return (rectCtx) {
    final msg = messageValue.watchValue();
    final themeWrap = rectCtx.renderCtxThemeWrap();
    if (msg == null) {
      return rectCtx.rectMessageSharingBoxes(
        message: "Data does not exist.",
      );
    }
    return [
      rectCtx.chunkedListRectVerticalSharingBox(
        itemHeight: themeWrap.protoFieldPaddingSizer.callOuterHeight(),
        items: protoMessageFieldWxRectBuilders(
          messageCtx: messageCtx,
          msg: msg,
        ).toList(),
      ),
    ];
  };
}

Iterable<WxRectBuilder> protoMessageFieldWxRectBuilders<M extends Msg>({
  required MessageCtx messageCtx,
  required M msg,
}) sync* {
  for (final logicalFieldCtx in messageCtx.callLogicalFieldsList()) {
    switch (logicalFieldCtx) {
      case FieldCtx():
        yield protoMessageFieldWxRectBuilder(
          shaftOpener:
              mshShaftFactories.factoriesShaftOpenerOf<ProtoFieldShaftFactory>(
            identifierAnyData: MshShaftIdentifierMsg_Field$.create(
              tagNumber: logicalFieldCtx.fieldCtxTagNumber(),
            ).cmnAnyFromMsg(),
          ),
          label: logicalFieldCtx.fieldProtoName,
          value: "<todo>",
        );
      case OneofCtx():
    }
  }
}

WxRectBuilder protoMessageFieldWxRectBuilder({
  required ShaftOpener shaftOpener,
  required String label,
  required String value,
}) {
  return (rectCtx) {
    final themeWrap = rectCtx.renderCtxThemeWrap();
    return wxRectPaddingSizer(
      rectCtx: rectCtx,
      paddingSizer: themeWrap.protoFieldPaddingSizer,
      builder: (rectCtx) {
        final labelCtx = rectCtx.rectWithHeight(
          height: themeWrap.protoFieldLabelHeight,
        );
        final labelTextStyleWrap = themeWrap.protoFieldLabelTextStyleWrap;

        final labelWx = labelCtx.wxRectFillRight(
          left: [
            rectCtx.wxRectAim(
              action: shaftOpener.openShaftAction(
                shaftCtx: rectCtx,
              ),
              horizontal: null,
              vertical: AxisAlignment.center,
            ),
          ],
          right: (rectCtx) {
            return rectCtx
                .createTextCtx(
                  textStyleWrap: labelTextStyleWrap,
                )
                .wxTextAlign(
                  text: label,
                );
          },
        );

        final valueWx = rectCtx
            .createTextCtx(
                textStyleWrap: themeWrap.protoFieldValueTextStyleWrap)
            .wxTextHorizontal(text: value);

        return rectCtx.wxRectColumnExact(
          children: [
            labelWx,
            rectCtx
                .rectWithHeight(height: themeWrap.protoFieldLabelValueGapHeight)
                .wxEmpty(),
            valueWx,
          ],
        );
      },
    ).wxDecorateShaftOpener(
      shaftOpener: shaftOpener,
      shaftCtx: rectCtx,
    );
  };
}

double calculateProtoMessageFieldItemInnerHeight({
  @ext required ThemeWrap themeWrap,
}) {
  return themeWrap.protoFieldLabelHeight +
      themeWrap.protoFieldLabelValueGapHeight +
      themeWrap.protoFieldValueTextStyleWrap.callTextHeight();
}
