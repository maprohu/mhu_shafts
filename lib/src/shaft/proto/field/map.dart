part of '../proto.dart';

@Compose()
abstract class ProtoMapFieldShaftInterface<K extends Object, V extends Object>
    implements ProtoFieldShaftInterface, HasMapTypeActions<K, V> {}

ShaftDirectContentActions protoMapFieldContentActions({
  @ext required ProtoFieldShaftInterface protoFieldShaftInterface,
  required MapTypeActions mapTypeActions,
}) {
  return mapTypeActions.mapTypeActionsKeyValueGeneric$(
    <K extends Object, V extends Object>(mapTypeActions) {
      final shaftInterface =
          ComposedProtoMapFieldShaftInterface.protoFieldShaftInterface(
        protoFieldShaftInterface: protoFieldShaftInterface,
        mapTypeActions: mapTypeActions,
      );

      final actions = nullableMsgProtoFieldShaftContentActions(
        protoFieldShaftInterface: protoFieldShaftInterface,
        typeActions: mapTypeActions,
        builder: (rectCtx, mapValue) sync* {
          final themeWrap = rectCtx.renderCtxThemeWrap();

          final entries =
              mapTypeActions.mapTypeActionsSortedEntries(mapValue: mapValue);

          yield rectCtx.chunkedListSizingWidget(
            items: [
              for (final entry in entries)
                shaftOpenerPreviewWxRectBuilder(
                  shaftOpener: mshShaftOpenerOf<MainMenuShaftFactory>(),
                  label: entry.key.toString(),
                  value: "<todo>",
                )
            ],
            itemDimension: themeWrap.protoFieldPaddingSizer.callOuterHeight(),
            emptySizingWidget: rectCtx.defaultTextRow(
              text: "No entries.",
            ),
          );
        },
      );

      return ComposedShaftDirectContentActions.shaftDirectFocusContentActions(
        shaftDirectFocusContentActions: actions,
        shaftInterface: shaftInterface,
      );
    },
  );
}
