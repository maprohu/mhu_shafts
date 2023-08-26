// import 'dart:math';
//
// import 'package:collection/collection.dart';
// import 'package:fast_immutable_collections/fast_immutable_collections.dart';
// import 'package:fixnum/fixnum.dart';
// import 'package:flutter/material.dart';
// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/context/tasks/long_running.dart';
// import 'package:mhu_shafts/src/context/data.dart';
// import 'package:mhu_shafts/src/context/rect.dart';
// import 'package:mhu_shafts/src/shaft/main_menu.dart';
// import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
//
// import '../../proto.dart';
// import '../app.dart';
// import '../builder/double.dart';
// import '../builder/shaft.dart';
// import '../wx/wx.dart';
// import 'shaft.dart';
// import '../state.dart';
// import '../theme.dart';
// import 'boxed.dart';
// import 'paginate.dart';
// import '../screen/calc.dart';
//
// import 'screen.dart' as $lib;
//
// part 'screen.g.dart';
//
// part 'screen.freezed.dart';
//
//
//
// const _defaultMinShaftWidth = 200.0;
//
// ShaftsLayout mdiBuildScreen({
//   required AppBits appBits,
// }) {
//   final screenSize = appBits.screenSizeFr();
//   final screenWidth = screenSize.width;
//
//   final opBuilder = appBits.opBuilder;
//
//   return opBuilder.build(() {
//     final ThemeWrap(
//       shaftsDividerThickness: shaftsVerticalDividerThickness,
//     ) = appBits.themeCalcFr();
//
//     final StateCalc(
//       :state,
//     ) = appBits.stateCalcFr();
//
//     final minShaftWidth = state.minShaftWidthOpt ?? _defaultMinShaftWidth;
//
//     final shaftFitCount = itemFitCount(
//       available: screenWidth,
//       itemSize: minShaftWidth,
//       dividerThickness: shaftsVerticalDividerThickness,
//     );
//
//     final topCalcChain = ComposedShaftCalcChain.appBits(
//       appBits: appBits,
//       shaftMsg: state.getEffectiveTopShaft(hasShaftFactories: appBits),
//       shaftIndexFromRight: 0,
//       windowStateMsg: state,
//     );
//
//     final doubleChain = ComposedShaftDoubleChain(
//       shaftCalcChain: topCalcChain,
//     );
//
//     final visibleShaftsWithWidths = doubleChain.iterableLeft
//         .map((s) {
//           final widthLeft = shaftFitCount - s.widthOnRight;
//           return (
//             shaft: s,
//             width: min(widthLeft, s.shaftCalcChain.shaftWidth),
//           );
//         })
//         .takeWhile(
//           (v) => v.width > 0,
//         )
//         .toList();
//
//     final actualShaftUnitCount =
//         visibleShaftsWithWidths.map((e) => e.width).sum;
//
//     final singleShaftWidth = (screenWidth -
//             ((actualShaftUnitCount - 1) * shaftsVerticalDividerThickness)) /
//         actualShaftUnitCount;
//
//     final visibleShaftsLayout = visibleShaftsWithWidths
//         .mapIndexed((index, sw) {
//           final (:shaft, :width) = sw;
//           final shaftBits = ComposedShaftBuilderBits.shaftCalc(
//             shaftCalc: shaft.shaftCalcChain.calc,
//             shaftDoubleChain: shaft,
//           );
//
//           final sizedBits = shaftBits.sized(
//             screenSize.withWidth(
//               width * singleShaftWidth +
//                   ((width - 1) * shaftsVerticalDividerThickness),
//             ),
//           );
//
//           final headerExtra = index == 0
//               ? longRunningTaskIndicatorIcon(
//                   appBits: sizedBits,
//                 )
//               : null;
//
//           final bx = defaultShaftBx(
//             sizedBits: sizedBits,
//             headerExtra: headerExtra,
//           );
//           final shaftMsg = shaft.shaftCalcChain.shaftMsg;
//           return ShaftLayout(
//             shaftSeq: shaftMsg.shaftSeq,
//             shaftWidthUnits: shaftMsg.widthOpt ?? 1,
//             shaftBx: bx,
//           );
//         })
//         .toList()
//         .reversed;
//
//     return ShaftsLayout(
//       shafts: visibleShaftsLayout.toIList(),
//       screenSize: screenSize,
//       dividerThickness: shaftsVerticalDividerThickness,
//     );
//
//     // return Bx.row(
//     //   columns: visibleShafts.toList(),
//     //   size: screenSize,
//     // );
//   });
// }
//
// // typedef ShaftsLayout = IList<ShaftLayout>;
//
// UpdateView mdiStartScreenStream({
//   required AppBits appBits,
//   required DspReg disposers,
//   required WriteValue<ShaftsLayout> shaftsLayout,
// }) {
//   final viewFr = disposers.fr(() {
//     return mdiBuildScreen(appBits: appBits);
//   });
//
//   viewFr.changes().forEach(shaftsLayout);
//
//   bool paused = false;
//   return (update) {
//     if (paused) {
//       update();
//       return;
//     }
//
//     viewFr.pause();
//     paused = true;
//
//     try {
//       update();
//     } finally {
//       paused = false;
//       viewFr.resume();
//     }
//   };
// }
//
//
//
// extension ScreenMshShaftMsgX on MshShaftMsg {
//   Iterable<MshShaftMsg> get toShaftIterable =>
//       finiteIterable((item) => item.parentOpt);
//
//   MshShaftMsg getShaftByIndex(int index) {
//     return toShaftIterable.skip(index).first;
//   }
//
//   MshShaftMsg getShaftByIndexFromLeft(ShaftIndexFromLeft shaftIndexFromLeft) {
//     final iterable = toShaftIterable;
//     final length = iterable.length;
//     return iterable.skip(length - shaftIndexFromLeft - 1).first;
//   }
// }
