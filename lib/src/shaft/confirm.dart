// import 'dart:async';
// import 'dart:ui';
//
// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/proto.dart';
// import 'package:mhu_shafts/src/app.dart';
// import 'package:mhu_shafts/src/bx/string.dart';
// import 'package:mhu_shafts/src/context/data.dart';
// import 'package:mhu_shafts/src/op.dart';
// import 'package:mhu_shafts/src/screen/calc.dart';
// import 'package:mhu_shafts/src/screen/opener.dart';
// import 'package:mhu_shafts/src/shaft/proto/field/map_entry.dart';
//
// import '../keyboard.dart';
// import '../long_running.dart';
//
// part 'confirm.g.compose.dart';
//
// @Compose()
// abstract class ConfirmShaftMerge
//     implements ShaftLabeledContentBits, HasOnShaftOpen {}
//
// @Compose()
// abstract class ConfirmShaft
//     implements ShaftCalcBuildBits, ConfirmShaftMerge, ShaftCalc {
//   static ConfirmShaft create(
//     ShaftCalcBuildBits shaftCalcBuildBits,
//   ) {
//     final confirmType =
//         shaftCalcBuildBits.shaftMsg.shaftIdentifier.confirm.type;
//
//     final merge = switch (confirmType) {
//       MshConfirmMsg_Type$deleteEntry() => ComposedConfirmShaftMerge(
//           shaftHeaderLabel: "Delete Entry",
//           buildShaftContent: (sizedBits) {
//             return [
//               stringVerticalSharingBx(
//                 sizedBits: sizedBits,
//                 string: "Confirm delete (Enter) or Cancel (Escape)?",
//               ),
//             ];
//           },
//           onShaftOpen: () {
//             final opBuilder = shaftCalcBuildBits.opBuilder;
//
//             final hasDeleteEntry =
//                 shaftCalcBuildBits.leftSignificantCalc as HasDeleteEntry;
//
//             opBuilder.startAsyncOp(
//               shaftIndexFromLeft: shaftCalcBuildBits.shaftIndexFromLeft,
//               start: (addShortcutKeyListener) async {
//                 final completer = Completer<VoidCallback>();
//
//                 addShortcutKeyListener(
//                   (key) {
//                     switch (key) {
//                       case ShortcutKey.escape:
//                         completer.complete(() {
//                           shaftCalcBuildBits.closeShaft();
//                         });
//                       case ShortcutKey.enter:
//                         completer.complete(() {
//                           hasDeleteEntry.deleteEntry();
//                         });
//                       default:
//                     }
//                   },
//                 );
//
//                 return await completer.future;
//               },
//             );
//           },
//         ),
//       _ => throw confirmType,
//     };
//
//     return ComposedConfirmShaft.merge$(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       confirmShaftMerge: merge,
//     );
//   }
// }
