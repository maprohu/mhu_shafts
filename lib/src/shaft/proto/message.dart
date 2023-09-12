part of 'proto.dart';

@Compose()
abstract class ProtoMessageShaftInterface<M extends Msg>
    implements HasMessageCtx, HasMessageValue<M>, HasProtoCustomizer {}

ShaftContent protoMessageShaftContent<M extends Msg>({
  @ext required ProtoMessageShaftInterface<M> shaftInterface,
}) {
  return (rectCtx) sync* {
    final msg = shaftInterface.messageValue.watchValue();
    final themeWrap = rectCtx.renderCtxThemeWrap();
    if (msg == null) {
      yield rectCtx.rectMonoTextSharingBox(
        text: "Data does not exist.",
      );
      return;
    }
    final columnCtx = rectCtx.createColumnCtx();
    yield columnCtx.chunkedListSizingWidget(
      itemDimension: themeWrap.protoFieldPaddingSizer.callOuterHeight(),
      emptySizingWidget: columnCtx.defaultTextRow(text: "No fields."),
      items: protoMessageFieldWxRectBuilders(
        shaftInterface: shaftInterface,
        msg: msg,
      ).toList(),
    );
  };
}

Iterable<WxRectBuilder> protoMessageFieldWxRectBuilders<M extends Msg>({
  required ProtoMessageShaftInterface<M> shaftInterface,
  required M msg,
}) sync* {
  for (final logicalFieldCtx
      in shaftInterface.messageCtx.callLogicalFieldsList()) {
    final isVisible = shaftInterface.protoCustomizer.logicalFieldVisible.call(
      logicalFieldCtx.callLogicalFieldMarker(),
      shaftInterface,
    );

    if (!isVisible) {
      continue;
    }

    switch (logicalFieldCtx) {
      case FieldCtx():
        yield shaftOpenerPreviewWxRectBuilder(
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

double calculateProtoMessageFieldItemInnerHeight({
  @ext required ThemeWrap themeWrap,
}) {
  return themeWrap.protoFieldLabelHeight +
      themeWrap.protoFieldLabelValueGapHeight +
      themeWrap.protoFieldValueTextStyleWrap.callTextHeight();
}
