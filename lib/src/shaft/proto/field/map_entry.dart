import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/app.dart';
import 'package:mhu_shafts/src/bx/menu.dart';
import 'package:mhu_shafts/src/context/config.dart';
import 'package:mhu_shafts/src/model.dart';
import 'package:mhu_shafts/src/op.dart';
import 'package:mhu_shafts/src/proto.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:mhu_shafts/src/screen/opener.dart';
import 'package:mhu_shafts/src/shaft/proto/content/value_browsing.dart';
import 'package:mhu_shafts/src/shaft/proto/proto_path.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import '../../../long_running.dart';

part 'map_entry.g.has.dart';

part 'map_entry.g.compose.dart';

@Has()
typedef DeleteEntry = VoidCallback;

@Has()
@Compose()
abstract class MapEntryShaftRight implements HasEditingBits, HasDeleteEntry {}

@Compose()
abstract class MapEntryShaft
    implements
        ShaftCalcBuildBits,
        ShaftContentBits,
        MapEntryShaftRight,
        ShaftCalc {
  static MapEntryShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final left = shaftCalcBuildBits.leftCalc as HasEditingBits;
    final mapEditingBits = left.editingBits as MapEditingBits;

    final MapEditingBits(
      :protoCustomizer,
    ) = mapEditingBits;

    return mapEditingBits.mapEditingBitsGeneric(
      <K, V>(mapEditingBits) {
        final key = mapEditingBits
            .mapDataType.mapKeyDataType.mapEntryKeyMsgAttribute
            .readAttribute(
          shaftCalcBuildBits.shaftMsg.shaftIdentifier.mapEntry,
        );

        final scalarValue = mapEditingBits.itemValue(key);

        final mapFieldAccess = mapEditingBits.protoPathField.fieldAccess
            as MapFieldAccess<Msg, K, V>;

        final mapEntry = MapEntry(
          key,
          scalarValue.readValue() ??
              mapEditingBits.mapDataType.mapValueDataType.defaultValue,
        );
        final content = ValueBrowsingContent.scalar(
          scalarDataType: mapEditingBits.mapDataType.mapValueDataType,
          scalarValue: scalarValue,
          extraContent: (sizedBits) {
            return [
              sizedBits.menu([
                ShaftTypes.confirm.opener(
                  sizedBits,
                  shaftKey: (key) {
                    key.ensureDeleteEntry();
                  },
                ),
              ]),
              ...mapEditingBits.protoCustomizer
                  .mapEntryExtraContent(mapFieldAccess, mapEntry)
                  .call(sizedBits),
            ];
          },
          protoCustomizer: mapEditingBits.protoCustomizer,
          protoPath: ProtoPathMapItem(
            parent: mapEditingBits.protoPathField,
            key: key,
          ),
        );

        final shaftRight = ComposedMapEntryShaftRight(
            editingBits: content.editingBits,
            deleteEntry: () {
              shaftCalcBuildBits.updateView(() {
                shaftCalcBuildBits.closeShaft();
                mapEditingBits.updateValue((map) {
                  map.remove(key);
                });
              });
            });

        return ComposedMapEntryShaft.merge$(
          shaftCalcBuildBits: shaftCalcBuildBits,
          shaftHeaderLabel: protoCustomizer.mapEntryLabel(
            mapFieldAccess,
            mapEntry,
          ),
          shaftContentBits: content,
          mapEntryShaftRight: shaftRight,
        );
      },
    );
  }
}
