import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/proto.dart';

import 'app.dart';
import 'context/shaft.dart';
import 'model.dart' as $lib;
import 'shaft/main_menu.dart';
import 'shaft_factory.dart';

part 'model.g.has.dart';

part 'model.g.dart';

typedef ShaftWidthUnit = int;

@Has()
typedef WindowStateMsg = MshWindowStateMsg;

@Has()
typedef ShaftMsg = MshShaftMsg;

@Has()
typedef ShaftIdentifierMsg = MshShaftIdentifierMsg;

extension MshShaftMsgX on MshShaftMsg {
  @Deprecated('use shaftMsgIterableLeft')
  Iterable<MshShaftMsg> get iterableTowardsLeft =>
      finiteIterable((e) => e.parentOpt);

  @Deprecated("use shaftMsgByIndexFromLeft")
  MshShaftMsg? shaftByIndexFromLeft(int index) {
    final listTowardsLeft = iterableTowardsLeft.toList();
    final reverseIndex = listTowardsLeft.length - index - 1;
    return listTowardsLeft.getOrNull(reverseIndex);
  }

// void clearNotificationsDeepMutate() {
//   for (final msg in iterableTowardsLeft) {
//     msg.notifications.clear();
//   }
// }
//
// MshShaftMsg clearNotificationsDeepRebuild() {
//   return deepRebuild((msg) {
//     msg.clearNotificationsDeepMutate();
//   });
// }
}

// extension PfeMapKeyDataTypeX<K> on MapKeyDataType<K> {
//   ScalarAttribute<MshMapEntryKeyMsg, K> get mapEntryKeyMsgAttribute {
//     final MapKeyDataType self = this;
//     final ScalarAttribute<MshMapEntryKeyMsg, dynamic> result = switch (self) {
//       StringDataType() => MshMapEntryKeyMsg$.stringKey.hack,
//       CoreIntDataType() => MshMapEntryKeyMsg$.intKey.hack,
//       final other => throw other,
//     };
//
//     return result as ScalarAttribute<MshMapEntryKeyMsg, K>;
//   }
// }

// extension _Hack on ScalarAttribute<MshMapEntryKeyMsg, dynamic> {
//   ScalarAttribute<MshMapEntryKeyMsg, dynamic> get hack => this;
// }

ShaftMsg getEffectiveTopShaft({
  @Ext() required MshWindowStateMsg stateMsg,
}) {
  return stateMsg.topShaftOpt ?? createDefaultShaftMsg();
}

ShaftMsg createDefaultShaftMsg() {
  return MshShaftMsg()
    ..ensureShaftMsgMainMenu()
    ..freeze();
}

void ensureShaftMsgMainMenu({
  @Ext() required ShaftMsg shaftMsg,
}) {
  shaftMsg.ensureShaftIdentifier().shaftFactoryKeyPath.add(
        mshShaftFactories
            .lookupSingletonByType<MainMenuShaftFactory>()
            .getShaftFactoryKey(),
      );
}

ShaftMsg ensureEffectiveTopShaft({
  required MshWindowStateMsg stateMsg,
}) {
  return stateMsg.topShaftOpt ??
      (stateMsg.ensureTopShaft()..ensureShaftMsgMainMenu());
}

ShaftWidthUnit getShaftEffectiveWidthUnits({
  @extHas required ShaftMsg shaftMsg,
}) {
  return shaftMsg.widthUnitsOpt ?? 1;
}

Iterable<MshShaftMsg> shaftMsgIterableLeft({
  @ext required ShaftMsg shaftMsg,
}) {
  return shaftMsg.finiteIterable(
    (e) => e.parentOpt,
  );
}

MshShaftMsg? shaftMsgByIndexFromLeft(
  @ext ShaftMsg shaftMsg,
  int index,
) {
  final listTowardsLeft = shaftMsg.shaftMsgIterableLeft().toList();
  final reverseIndex = listTowardsLeft.length - index - 1;
  return listTowardsLeft.getOrNull(reverseIndex);
}

// ShaftIdentifierMsg innerShaftIdentifierMsg({
//   @ext required ShaftIdentifierMsg shaftIdentifierMsg,
// }) {
//   return shaftIdentifierMsg.anyData.rawValue.let(
//     MshShaftIdentifierMsg.fromBuffer,
//   )..freeze();
// }
