import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/app.dart';
import 'package:mhu_shafts/src/bx/menu.dart';
import 'package:mhu_shafts/src/context/data.dart';
import 'package:mhu_shafts/src/op.dart';
import 'package:mhu_shafts/src/proto.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:mhu_shafts/src/screen/notification.dart';
import 'package:mhu_shafts/src/shaft/editing/string.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import '../../../long_running.dart';

// part 'new_map_entry.g.has.dart';

part 'new_map_entry.g.compose.dart';

@Compose()
abstract class NewMapEntryShaftRight {}

@Compose()
abstract class NewMapEntryShaft
    implements ShaftCalcBuildBits, NewMapEntryShaftRight, ShaftCalc {
  static NewMapEntryShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final left = shaftCalcBuildBits.leftSignificantCalc as HasEditingBits;
    final mapEditingBits = left.editingBits as MapEditingBits;

    return mapEditingBits.mapEditingBitsGeneric(<K, V>(mapEditingBits) {
      final shaftRight = ComposedNewMapEntryShaftRight();

      return ComposedNewMapEntryShaft.merge$(
        shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
        shaftCalcBuildBits: shaftCalcBuildBits,
        newMapEntryShaftRight: shaftRight,
        buildShaftContent: (sizedBits) {
          void submitKeyValue(Object key) {}
          final MapKeyDataType mapKeyDataType =
              mapEditingBits.mapDataType.mapKeyDataType;

          final stringParsingBits = switch (mapKeyDataType) {
            StringDataType() =>
              StringParsingBits.stringType(submitValue: submitKeyValue),
            CoreIntDataType() =>
              StringParsingBits.intType(submitValue: submitKeyValue),
            final other => throw other,
          } as StringParsingBits<K>;

          if (shaftCalcBuildBits.shaftMsg.innerState.stringEdit.focused) {
            return focusedStringEditorSharingBox(
              sizedBits: sizedBits,
              stringParsingBits: stringParsingBits,
            ).toSingleElementIterable;
          } else {
            return [
              ...unfocusedStringEditSharingBoxes(
                sizedBits: sizedBits,
                stringParsingBits: stringParsingBits,
              ),
             sizedBits.menu([
                MenuItem(
                  label: "Add Entry",
                  callback: () {
                    final text = sizedBits.innerState.stringEdit.text;
                    final result = stringParsingBits.parseString(text);

                    switch (result) {
                      case ValidationFailure():
                        sizedBits.showNotifications(
                          result.validationFailureMessages,
                        );

                      case ValidationSuccess(value: final keyValue):
                        final messages = [
                          if (mapEditingBits
                                  .readValue()
                                  ?.containsKey(keyValue) ??
                              false)
                            "Key already exists.",
                        ];

                        if (messages.isNotEmpty) {
                          sizedBits.showNotifications(messages);
                        } else {
                          shaftCalcBuildBits.updateView(() {
                            mapEditingBits.updateValue((items) {
                              items[keyValue] = mapEditingBits
                                  .mapDataType.mapValueDataType.defaultValue;
                              // sizedBits.closeShaft();
                            });
                          });
                        }
                    }
                  },
                ),
              ]),
            ];
          }
        },
      );
    });
  }
}

// part of 'map.dart';
//
// @Compose()
// abstract class PfeMapFieldEntryNewBits implements PfeMapEntryBits {}
//
// @Compose()
// abstract class PfeShaftMapFieldNewEntry
//     implements
//         ShaftCalcBuildBits,
//         PfeMapFieldBits,
//         PfeMapEntryBits,
//         PfeMapShaftBits,
//         ShaftCalc {
//   static ShaftCalc of(ShaftCalcBuildBits shaftCalcBuildBits) {
//     final mapFieldShaft = shaftCalcBuildBits.shaftCalcChain.leftSignificantCalc
//         as PfeShaftMapField;
//
//     final shaftMsgFu = shaftCalcBuildBits.shaftCalcChain.shaftMsgFu;
//
//     late final stringKeyFw = Fw.fromFr(
//       fr: shaftMsgFu
//           .map((t) => t.newMapEntry.mapEntry.mapEntryKey.stringKeyOpt),
//       set: (value) {
//         shaftMsgFu.update((shaft) {
//           shaft.newMapEntry.ensureMapEntry().ensureMapEntryKey().stringKeyOpt =
//               value;
//         });
//       },
//     );
//     late final intKeyFw = Fw.fromFr(
//       fr: shaftMsgFu.map((t) => t.newMapEntry.mapEntry.mapEntryKey.intKeyOpt),
//       set: (value) {
//         shaftMsgFu.update((shaft) {
//           shaft.newMapEntry.ensureMapEntry().ensureMapEntryKey().intKeyOpt =
//               value;
//         });
//       },
//     );
//
//     final keyFw = switch (mapFieldShaft.mapDataType.mapKeyDataType) {
//       StringDataType() => stringKeyFw,
//       CoreIntDataType() => intKeyFw,
//       final other => throw other,
//     };
//
//     final mapValueDataType = mapFieldShaft.mapDataType.mapValueDataType;
//
//     Fw<M?> messageValueFw<M>(
//       MessageDataType messageDataType,
//     ) {
//       return Fw.fromFr(
//         fr: shaftMsgFu.map((t) {
//           final bytes = t.newMapEntry.mapEntry.bytesValueOpt;
//           if (bytes != null) {
//             return messageDataType.pbiMessage.instance.rebuild((m) {
//               m.mergeFromBuffer(bytes);
//             }) as M;
//           } else {
//             return null;
//           }
//         }),
//         set: (value) {
//           shaftMsgFu.update((shaft) {
//             if (value == null) {
//               shaft.ensureNewMapEntry().ensureMapEntry().clearBytesValue();
//             } else {
//               value as GeneratedMessage;
//               shaft.ensureNewMapEntry().ensureMapEntry().bytesValue =
//                   value.writeToBuffer();
//             }
//           });
//         },
//       );
//     }
//
//     final valueFw = mapValueDataType.dataTypeGeneric<Fw>(
//       <V>() {
//         return switch (mapValueDataType) {
//           MessageDataType() => messageValueFw<V>(mapValueDataType),
//           final other => throw other,
//         };
//       },
//     );
//
//     final entryBits = ComposedPfeMapFieldEntryNewBits(
//       pfeMapKeyFw: keyFw,
//       pfeMapValueFw: valueFw,
//     );
//
//     return ComposedPfeShaftMapFieldNewEntry.merge$(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       pfeMapFieldBits: mapFieldShaft,
//       pfeMapEntryBits: entryBits,
//       shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//       buildShaftContent: (sizedBits) {
//         return sizedBits.menu(items: [
//           sizedBits.openerField(MshShaftMsg$.mapEntryKey),
//           sizedBits.openerField(MshShaftMsg$.mapEntryValue),
//           MenuItem(
//             label: "Add Entry",
//             callback: () {
//               final keyValue = keyFw.read();
//               final mapFu = mapFieldShaft.pfeMapFieldFu;
//               final valueValue = valueFw.read();
//               final messages = [
//                 if (keyValue == null) "Key is null.",
//                 if (mapFu.read().containsKey(keyValue)) "Key already exists.",
//               ];
//               if (messages.isNotEmpty) {
//                 sizedBits.showNotifications(messages);
//               } else {
//                 shaftCalcBuildBits.fwUpdateGroup.run(() {
//                   mapFu.update((items) {
//                     items[keyValue] = valueValue;
//                     // sizedBits.closeShaft();
//                   });
//                 });
//               }
//             },
//           ),
//         ]);
//       },
//     );
//   }
// }
