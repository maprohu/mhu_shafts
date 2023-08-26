import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/bx/menu.dart';
import 'package:mhu_shafts/src/context/data.dart';
import 'package:mhu_shafts/src/proto.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:mhu_shafts/src/screen/opener.dart';
import 'package:mhu_shafts/src/shaft/editing/edit_scalar.dart';
import 'package:mhu_shafts/src/shaft/proto/content/message.dart';
import 'package:mhu_shafts/src/shaft/proto/proto_customizer.dart';
import 'package:mhu_shafts/src/shaft/proto/proto_path.dart';
import 'package:mhu_shafts/src/shaft/string.dart';
import 'package:mhu_shafts/src/sharing_box/browse_map.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

part 'value_browsing.g.compose.dart';

@Compose()
abstract class ValueBrowsingContent<T>
    implements ShaftContentBits, HasEditingBits<T> {
  static ValueBrowsingContent<T> concreteField<M extends GeneratedMessage, T>({
    required MessageUpdateBits<M> messageUpdateBits,
    required ScalarValue<M> messageValue,
    required FieldCoordinates fieldCoordinates,
    required DataType<T> dataType,
    required ProtoCustomizer protoCustomizer,
    required ProtoPathField protoPathField,
  }) {
    final DataType dt = dataType;
    switch (dt) {
      case ScalarDataType():
        dt as ScalarDataType<T>;
        return scalar(
          scalarDataType: dt,
          scalarValue: messageValue.scalarAttribute(
            messageUpdateBits: messageUpdateBits,
            scalarAttribute: dt.scalarAttribute(
              fieldCoordinates: fieldCoordinates,
            ),
          ),
          protoCustomizer: protoCustomizer,
          protoPath: protoPathField,
        );
      case MapDataType():
        return dt.mapKeyValueGeneric<ValueBrowsingContent>(
          <K, V>(mapDataType) {
            return map(
              MapEditingBits.create(
                mapDataType: mapDataType,
                mapValue: messageValue.mapAttribute(
                  messageUpdateBits: messageUpdateBits,
                  hasReadAttribute: mapDataType.hasReadAttribute(
                    fieldCoordinates: fieldCoordinates,
                  ),
                ),
                protoCustomizer: protoCustomizer,
                protoPath: protoPathField,
              ),
            );
          },
        ) as ValueBrowsingContent<T>;
      default:
        throw dataType;
    }
  }

  static ValueBrowsingContent<T> scalar<T>({
    required ScalarDataType<T> scalarDataType,
    required ScalarValue<T> scalarValue,
    BuildShaftContent extraContent = emptyContent,
    required ProtoCustomizer protoCustomizer,
    required ProtoPath protoPath,
  }) {
    ValueBrowsingContent<T> build<V>(
      ScalarDataType<V> scalarDataType,
      ValueBrowsingContent<V> Function(
        ScalarEditingBits<V> scalarEditingBits,
      ) builder,
    ) {
      final scalarEditingBits = ScalarEditingBits.create(
        scalarDataType: scalarDataType,
        scalarValue: scalarValue as ScalarValue<V>,
        protoCustomizer: protoCustomizer,
        protoPath: protoPath,
      );

      final result = builder(scalarEditingBits) as ValueBrowsingContent<T>;

      return ComposedValueBrowsingContent(
        buildShaftContent: (sizedBits) {
          return [
            ...result.buildShaftContent(sizedBits),
            sizedBits.menu([
              ShaftTypes.editScalar.opener(sizedBits),
              MenuItem(
                label: "Paste from Clipboard",
                callback: () {
                  EditScalarShaft.stringEditPasteFromClipboard(
                    appBits: sizedBits,
                    shaftIndexFromLeft: sizedBits.shaftIndexFromLeft + 1,
                  );
                  sizedBits.updateView(() {
                    ShaftTypes.editScalar
                        .openerBits(
                          sizedBits,
                          innerState: MshInnerStateMsg()
                            ..ensureStringEdit().pasting = true
                            ..freeze(),
                        )
                        .shortcutCallback();
                  });
                },
              )
            ]),
            ...extraContent(sizedBits),
          ];
        },
        editingBits: result.editingBits,
      );
    }

    final ScalarDataType sdt = scalarDataType;
    switch (sdt) {
      case MessageDataType():
        return sdt.messageDataTypeGeneric<ValueBrowsingContent>(
          <M extends Msg>(messageDataType) {
            return message<M>(
              messageEditingBits: MessageEditingBits.create<M>(
                messageDataType: messageDataType,
                scalarValue: scalarValue as ScalarValue<M>,
                protoCustomizer: protoCustomizer,
                protoPath: protoPath,
              ),
              extraContent: extraContent,
            );
          },
        ) as ValueBrowsingContent<T>;
      case CoreIntDataType():
        return build(sdt, coreIntType);
      case StringDataType():
        return build(sdt, stringType);

      default:
        throw scalarDataType;
    }
  }

  static ValueBrowsingContent<int> coreIntType(
    ScalarEditingBits<int> scalarEditingBits,
  ) {
    return ComposedValueBrowsingContent(
      buildShaftContent: stringBuildShaftContent(
        scalarEditingBits.watchValue()?.toString(),
        nullLabel: "<null int>",
      ),
      editingBits: scalarEditingBits,
    );
  }

  static ValueBrowsingContent<String> stringType(
    ScalarEditingBits<String> scalarEditingBits,
  ) {
    return ComposedValueBrowsingContent(
      buildShaftContent: stringBuildShaftContent(
        scalarEditingBits.watchValue(),
      ),
      editingBits: scalarEditingBits,
    );
  }

  static ValueBrowsingContent<Map<K, V>> map<K, V>(
    MapEditingBits<K, V> mapEditingBits,
  ) {
    return ComposedValueBrowsingContent(
      buildShaftContent: (sizedBits) {
        return [
          ...browseMapSharingBoxes(
            sizedShaftBuilderBits: sizedBits,
            mapEditingBits: mapEditingBits,
          ),
        ];
      },
      buildShaftOptions: (shaftBuilderBits) {
        final newEntryOpener = ShaftTypes.newMapEntry.opener(shaftBuilderBits);
        final customItems = mapEditingBits.protoCustomizer.mapFieldOptions(
          mapEditingBits.protoPathField.fieldAccess
              as MapFieldAccess<Msg, K, V>,
          mapEditingBits,
          shaftBuilderBits,
        );
        return [
          newEntryOpener.copyWith(
            callback: () {
              final mapFieldAccess = mapEditingBits.protoPathField.fieldAccess
                  as MapFieldAccess<Msg, K, V>;
              shaftBuilderBits.updateView(() {
                final newKey = mapEditingBits.protoCustomizer
                    .mapDefaultKey(mapFieldAccess);

                if (newKey == null) {
                  newEntryOpener.callback();
                } else {
                  mapEditingBits.updateValue(
                    (map) {
                      map[newKey] = mapEditingBits
                          .mapDataType.mapValueDataType.defaultValue;
                    },
                  );

                  shaftBuilderBits
                      .opener(
                        ShaftIdentifiers.mapEntry(
                          mapKeyDataType:
                              mapEditingBits.mapDataType.mapKeyDataType,
                          key: newKey,
                        ),
                      )
                      .callback();
                }
              });
            },
          ),
          if (customItems != null) ...customItems,
        ];
      },
      editingBits: mapEditingBits,
    );
  }

  static ValueBrowsingContent<M> message<M extends Msg>({
    required MessageEditingBits<M> messageEditingBits,
    BuildShaftContent extraContent = emptyContent,
  }) {
    final customItems = messageEditingBits.protoCustomizer.messageEditOptions(
      messageEditingBits.messageDataType.defaultValue,
      messageEditingBits,
    );
    return ComposedValueBrowsingContent.shaftContentBits(
      shaftContentBits: MessageContent.create(
        messageEditingBits: messageEditingBits,
        extraContent: (sizedBits) {
          return [
            ...extraContent(sizedBits),
            if (customItems != null)
              sizedBits.menu(
                customItems(sizedBits),
              ),
          ];
        },
      ),
      editingBits: messageEditingBits,
    );
  }
}
