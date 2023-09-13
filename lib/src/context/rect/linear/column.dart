part of '../../rect.dart';

RigidWidget aimTextRow({
  required ColumnCtx columnCtx,
  required WatchAimAction watchAimAction,
  required String text,
  EdgeInsets? edgeInsets,
  Color? backgroundColor,
  TextStyleWrap? textStyleWrap,
}) {
  Wx builder(LinearCtx linearCtx) {
    final row = linearCtx.createRowCtx();
    return row.wxLinearWidgets(
      widgets: [
        row
            .wxAim(
              watchAction: watchAimAction,
            )
            .rigidWidgetWx(
              linearCtx: row,
            ),
        row.textShrinkingWidget(
          textStyleWrap:
              textStyleWrap ?? linearCtx.defaultTextCtx().textStyleWrap,
          text: text,
        ),
      ],
    );
  }

  final decorator = backgroundColor?.backgroundColorDecorator();

  if (edgeInsets == null) {
    return builder(columnCtx)
        .wxDecorateWidget(decorator: decorator)
        .rigidWidgetWx(linearCtx: columnCtx);
  } else {
    return columnCtx.linearPadding(
      edgeInsets: edgeInsets,
      builder: columnCtx.rigidPaddingBuilder$(builder),
      widgetDecorator: backgroundColor?.backgroundColorDecorator(),
    );
  }
}
