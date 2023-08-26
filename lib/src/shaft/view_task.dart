// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/app.dart';
// import 'package:mhu_shafts/src/context/config.dart';
// import 'package:mhu_shafts/src/op.dart';
// import 'package:mhu_shafts/src/screen/calc.dart';
//
// import '../long_running.dart';
//
// part 'view_task.g.has.dart';
// part 'view_task.g.compose.dart';
//
// @Has()
// @Compose()
// abstract class ViewTaskShaftRight {}
//
// @Compose()
// abstract class ViewTaskShaftMerge implements ShaftMergeBits {}
//
// @Compose()
// abstract class ViewTaskShaft
//     implements
//         ShaftCalcBuildBits,
//         ViewTaskShaftMerge,
//         ViewTaskShaftRight,
//         ShaftCalc {
//   static ViewTaskShaft create(
//     ShaftCalcBuildBits shaftCalcBuildBits,
//   ) {
//
//     final shaftRight = ComposedViewTaskShaftRight();
//     final shaftMerge = ComposedViewTaskShaftMerge(
//       shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//       buildShaftContent: (sizedBits) {
//         return [];
//       },
//     );
//
//     return ComposedViewTaskShaft.merge$(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       viewTaskShaftMerge: shaftMerge,
//       viewTaskShaftRight: shaftRight,
//     );
//   }
// }
