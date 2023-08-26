// import 'package:collection/collection.dart';
// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/proto.dart';
// import 'package:mhu_shafts/src/app.dart';
// import 'package:mhu_shafts/src/builder/shaft.dart';
// import 'package:mhu_shafts/src/context/rect.dart';
// import 'package:mhu_dart_proto/mhu_dart_proto.dart';
// import 'package:recase/recase.dart';
//
// import '../builder/sized.dart';
// import '../bx/menu.dart';
// import '../long_running.dart';
// import '../model.dart';
// import '../sharing_box.dart';
// import '../context/data.dart';
// import '../op.dart';
// import '../shaft/switch.dart';
// import '../bx/boxed.dart';
// import 'calc.dart' as $lib;
// part 'calc.g.dart';
//
// part 'calc.g.has.dart';
//
// part 'calc.g.compose.dart';
//
// @Has()
// typedef BuildShaftContent = SharingBoxes Function(
//   SizedShaftBuilderBits sizedBits,
// );
//
// List<MenuItem> emptyShaftOptions(ShaftBuilderBits shaftBuilderBits) => const [];
//
// SharingBoxes emptyContent(SizedShaftBuilderBits sizedShaftBuilderBits) =>
//     const [];
//
// @Has()
// @HasDefault(emptyShaftOptions)
// typedef BuildShaftOptions = List<MenuItem> Function(
//   ShaftBuilderBits shaftBuilderBits,
// );
//
//
// @Has()
// typedef ShaftCalcChainLeft = ShaftCalcChain?;
//
// @Has()
// typedef ShaftHeaderLabel = String;
//
// @Has()
// @HasDefault(noop)
// typedef OnShaftOpen = void Function();
//
// @Has()
// @HasDefault(true)
// typedef ShaftSignificant = bool;
//
// abstract class ShaftCalcBits implements HasShaftMsg, HasStateMsg, AppBits {}
//
// // @Has()
// // typedef ShaftStateField<T> = ScalarFieldAccess<MshShaftMsg, T>;
//
// @Has()
// typedef ShaftType = MshShaftIdentifierMsg_Type$;
//
// typedef ShaftTypes = MshShaftIdentifierMsg$;
//
// @Compose()
// abstract class ShaftCalcBuildBits
//     implements ShaftCalcBits, HasShaftCalcChain, HasShaftType {}
//
// @Has()
// typedef ShaftIndexFromRight = int;
// @Has()
// typedef ShaftIndexFromLeft = int;
//
// @Has()
// @Compose()
// abstract base class ShaftCalcChain
//     implements AppBits, ShaftCalcBits, HasShaftIndexFromRight {
//   late final ShaftCalc calc = calculateShaft(this);
//
//   late final ShaftCalcChain? shaftCalcChainLeft =
//       shaftMsg.parentOpt?.let((parent) {
//     return ComposedShaftCalcChain.appBits(
//       appBits: this,
//       shaftMsg: parent,
//       shaftIndexFromRight: shaftIndexFromRight + 1,
//       windowStateMsg: windowStateMsg,
//     );
//   });
//
//   late final ShaftIndexFromLeft shaftIndexFromLeft =
//       shaftCalcChainLeft?.shaftIndexFromLeft.let((i) => i + 1) ?? 0;
//
// // late final isFocused =
// //     shaftIndexFromLeft == stateMsg.focusedShaft.indexFromLeftOpt;
// }
//
// extension HasShaftMsgX on HasShaftMsg {
//   int get shaftWidth => shaftMsg.widthOpt ?? 1;
//
//   MshInnerStateMsg get innerState => shaftMsg.innerState;
// }
//
// @Has()
// @Compose()
// abstract class ShaftCalc
//     implements
//         ShaftCalcBuildBits,
//         ShaftLabeledContentBits,
//         ShaftCalcBits,
//         HasShaftCalcChain,
//         HasShaftHeaderLabel,
//         HasBuildShaftContent,
//         HasBuildShaftOptions,
//         HasShaftSignificant,
//         HasOnShaftOpen {}
//
// extension ShaftCalcChainX on ShaftCalcChain {
//   ShaftCalcBuildBits toBuildBits({
//     required ShaftType shaftType,
//   }) =>
//       ComposedShaftCalcBuildBits.shaftCalcBits(
//         shaftCalcBits: this,
//         shaftCalcChain: this,
//         shaftType: shaftType,
//       );
//
//   ShaftCalc? get leftCalc => shaftCalcChainLeft?.calc;
//
//   Iterable<ShaftCalc> get leftCalcs =>
//       leftCalc.finiteIterable((item) => item.leftCalc);
//
//   ShaftCalc? get leftSignificantCalc =>
//       leftCalcs.firstWhereOrNull((e) => e.shaftSignificant);
//
//   Fu<MshShaftMsg> get shaftMsgFu => shaftMsgFuByIndex(shaftIndexFromLeft);
//
//   MutableValue<ShaftMsg> get shaftUpdateValue => shaftMsgFu.toMutableValue;
//
// // Future<T> accessOwnInnerState<T>(
// //   FutureOr<T> Function(InnerStateFw innerStateFw) action,
// // ) {
// //   return accessInnerState(shaftIndexFromLeft, action);
// // }
//
// // Future<T> accessInnerStateRight<T>(
// //   Future<T> Function(InnerStateFw innerStateFw) action,
// // ) {
// //   return accessInnerState(shaftIndexFromLeft + 1, action);
// // }
// }
//
// extension ShaftCalcX on ShaftCalc {
//   // ShaftCalc? get leftCalc => shaftCalcChain.leftCalc;
// }
//
// extension HasShaftCalcChainX on HasShaftCalcChain {
//   ShaftCalc? get leftCalc => shaftCalcChain.leftCalc;
//
//   ShaftCalc? get leftSignificantCalc => shaftCalcChain.leftSignificantCalc;
//
//   // Future<R> accessOwnInnerState<R>(
//   //   FutureOr<R> Function(InnerStateFw innerStateFw) action,
//   // ) {
//   //   return shaftCalcChain.accessOwnInnerState(action);
//   // }
//
//   // Future<R> accessInnerStateRight<R>(
//   //   Future<R> Function(InnerStateFw innerStateFw) action,
//   // ) {
//   //   return shaftCalcChain.accessInnerStateRight(action);
//   // }
//
//   ShaftIndexFromLeft get shaftIndexFromLeft =>
//       shaftCalcChain.shaftIndexFromLeft;
// }
//
// @Compose()
// abstract class ShaftContentBits
//     implements HasBuildShaftContent, HasBuildShaftOptions {}
//
// @Compose()
// abstract class ShaftLabeledContentBits
//     implements ShaftContentBits, HasShaftHeaderLabel {}
//
// abstract class ShaftMergeBits
//     implements ShaftLabeledContentBits, HasShaftSignificant {}
//
// extension ShaftCalcBxX on Bx {
//   SharingBox get shaftContentSharing => SharingBox.fixedVertical(this);
//
//   SharingBoxes get toSharingBoxes =>
//       shaftContentSharing.toSingleElementIterable;
// }
//
// extension ShaftCalcBuildBitsX on ShaftCalcBuildBits {
//   String get defaultShaftHeaderLabel {
//     final fieldKey = lookupPbiMessageOf<MshShaftIdentifierMsg>()
//             .calc
//             .concreteFieldKeysByTagNumber[shaftType.tagNumber$] ??
//         MshShaftIdentifierMsg$.notImplemented.fieldKey;
//     return fieldKey.concreteFieldCalc.protoName.titleCase;
//   }
//
//   // void requestFocus() {
//   //   stateFw.rebuild((state) {
//   //     state.ensureFocusedShaft().indexFromLeft =
//   //         shaftCalcChain.shaftIndexFromLeft;
//   //   });
//   // }
//
//   void updateShaftMsg(
//     void Function(ShaftMsg shaftMsg) updates,
//   ) {
//     shaftCalcChain.shaftUpdateValue.updateValue(updates);
//   }
// }

