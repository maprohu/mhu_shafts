// import 'package:flutter/material.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/app.dart';
// import 'package:mhu_shafts/src/bx/boxed.dart';
// import 'package:mhu_shafts/src/bx/menu.dart';
// import 'package:mhu_shafts/src/long_running.dart';
// import 'package:mhu_shafts/src/screen/calc.dart';
// import 'package:mhu_shafts/src/theme.dart';
// import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
//
// BuildShaftContent? longRunningTasksShaftContent({
//   required AppBits appBits,
// }) {
//   final AppBits(
//     :longRunningTasksController,
//   ) = appBits;
//
//   final runningTasks =
//       longRunningTasksController.readWatchLongRunningTasks.watchValue();
//
//   if (runningTasks.isEmpty) {
//     return null;
//   }
//
//   return (sizedBits) {
//     return sizedBits.dynamicMenu([
//       ...runningTasks.map(
//         (task) => task.longRunningTaskMenuItem(sizedBits),
//       ),
//     ]).toSingleElementIterable;
//   };
// }
//
// Bx longRunningTaskIndicatorIcon({
//   required AppBits appBits,
// }) {
//   final AppBits(
//     :longRunningTasksController,
//   ) = appBits;
//   final dimension = appBits.themeCalc.shaftHeaderContentHeight;
//
//   final size = Size.square(dimension);
//
//   return Bx.leaf(
//     size: size,
//     widget: flcFrr(() {
//       final runningTasks =
//           longRunningTasksController.readWatchLongRunningTasks.watchValue();
//       Widget child = nullWidget;
//
//       if (runningTasks.isNotEmpty) {
//         if (runningTasks.any((e) =>
//             e.readWatchLongRunningState.watchValue() is LongRunningComplete)) {
//           child = Icon(
//             appBits.themeCalc.longRunningTaskCompleteIconData,
//             size: dimension,
//             color: appBits.themeCalc.longRunningTaskCompleteNotificationColor,
//           );
//         } else {
//           child = const CircularProgressIndicator();
//         }
//       }
//
//       return SizedBox.fromSize(
//         size: size,
//         child: child,
//       );
//     }),
//   );
// }
