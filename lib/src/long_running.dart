// import 'package:fast_immutable_collections/fast_immutable_collections.dart';
// import 'package:flutter/material.dart';
// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/proto.dart';
// import 'package:mhu_shafts/src/builder/shaft.dart';
// import 'package:mhu_shafts/src/builder/sized.dart';
// import 'package:mhu_shafts/src/bx/menu_dynamic.dart';
// import 'package:mhu_shafts/src/bx/text.dart';
// import 'package:mhu_shafts/src/context/data.dart';
// import 'package:mhu_shafts/src/screen/calc.dart';
// import 'package:mhu_shafts/src/screen/opener.dart';
// import 'package:mhu_shafts/src/sharing_box.dart';
// import 'package:mhu_shafts/src/theme.dart';
// import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
//
// import 'bx/boxed.dart';
//
// import 'long_running.dart' as $lib;
// part 'long_running.g.dart';
//
// part 'long_running.g.has.dart';
//
// part 'long_running.g.compose.dart';
//
// @Has()
// typedef LongRunningTaskIdentifier = int;
//
// @Has()
// typedef ReadWatchLongRunningTasks = ReadWatchValue<IList<LongRunningTask>>;
//
// @Has()
// typedef LongRunningTaskMenuItem = DynamicMenuItem Function(
//   ShaftBuilderBits shaftBuilderBits,
// );
//
// @Has()
// typedef AddLongRunningTask = LongRunningTask Function(
//   LongRunningTaskBuildBits Function(
//     LongRunningTaskIdentifier taskIdentifier,
//   ) builder,
// );
//
// @Has()
// typedef RemoveLongRunningTask = void Function(
//   LongRunningTaskIdentifier identifier,
// );
//
// sealed class LongRunningState {}
//
// @Compose()
// abstract class LongRunningBusy implements LongRunningState {}
//
// @Compose()
// abstract class LongRunningComplete implements LongRunningState {}
//
// @Has()
// typedef BuildLongTermCompleteView<T> = SharingBoxes Function(
//   SizedShaftBuilderBits sizedShaftBuilderBits,
//   T value,
// );
//
// @Compose()
// abstract class LongTermBusy implements HasBuildShaftContent, HasWatchLabel {}
//
// @Has()
// typedef WatchLongTermCompleteLabel<T> = Label Function(T value);
//
// @Has()
// typedef ReadWatchLongRunningState = ReadWatchValue<LongRunningState>;
//
// @Compose()
// abstract class LongTermComplete<T>
//     implements
//         HasBuildLongTermCompleteView<T>,
//         HasWatchLongTermCompleteLabel<T> {}
//
// @Compose()
// abstract class LongRunningTaskBuildBits
//     implements HasLongRunningTaskMenuItem, HasReadWatchLongRunningState {
//   static LongRunningTaskBuildBits create<T extends Object>({
//     required Future<T> future,
//     required LongRunningTaskIdentifier taskIdentifier,
//     required LongTermBusy longTermBusy,
//     required LongTermComplete<T> longTermComplete,
//   }) {
//     final futureFw = fw<T?>(null);
//     future.then(futureFw.set);
//     return ComposedLongRunningTaskBuildBits(
//       readWatchLongRunningState: fr(() => futureFw() == null
//           ? ComposedLongRunningBusy()
//           : ComposedLongRunningComplete()).toReadWatchValue,
//       longRunningTaskMenuItem: (shaftBuilderBits) {
//         final themeCalc = shaftBuilderBits.themeCalc;
//         final openerBits = ShaftTypes.viewTask.openerBits(
//           shaftBuilderBits,
//           shaftKey: (key) => key.taskIdentifier = taskIdentifier,
//         );
//         return DynamicMenuItem.direct(
//           labelBuilder: (size) {
//             Widget widget({
//               required WatchLabel watchLabel,
//               required Widget statusIcon,
//             }) =>
//                 Row(
//                   children: [
//                     Flexible(
//                       child: LayoutBuilder(
//                         builder: (context, constraints) {
//                           final maxWidth = constraints.maxWidth;
//
//                           return flcFrr(() {
//                             return bxFlexibleText(
//                               maxWidth: maxWidth,
//                               text: watchLabel(),
//                               style: themeCalc.menuItemTextStyle,
//                               splitMarker: themeCalc.defaultSplitMarker,
//                             ).layout();
//                           });
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       width: size.height,
//                       height: size.height,
//                       child: statusIcon,
//                     ),
//                   ],
//                 );
//             return Bx.leaf(
//               size: size,
//               widget: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxWidth: size.width,
//                 ),
//                 child: flcFrr(
//                   () {
//                     final futureValue = futureFw();
//
//                     if (futureValue == null) {
//                       return widget(
//                         watchLabel: longTermBusy.watchLabel,
//                         statusIcon: const CircularProgressIndicator(),
//                       );
//                     } else {
//                       return widget(
//                         watchLabel: () => longTermComplete
//                             .watchLongTermCompleteLabel(futureValue),
//                         statusIcon: Icon(
//                           shaftBuilderBits
//                               .themeCalc.longRunningTaskCompleteIconData,
//                           color: shaftBuilderBits.themeCalc
//                               .longRunningTaskCompleteNotificationColor,
//                           size: size.height,
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             );
//           },
//           opCallback: openerBits.shortcutCallback,
//           openerState: openerBits.openerState,
//         );
//       },
//     );
//   }
// }
//
// @Compose()
// abstract class LongRunningTask
//     implements LongRunningTaskBuildBits, HasLongRunningTaskIdentifier {
//   static const completeIconData = Icons.notification_important;
// }
//
// abstract class LongRunningTasks
//     implements HasUpdateView, HasStateFw, HasLongRunningTasksController {}
//
// @Compose()
// @Has()
// abstract class LongRunningTasksController
//     implements
//         HasReadWatchLongRunningTasks,
//         HasAddLongRunningTask,
//         HasRemoveLongRunningTask {
//   static LongRunningTasksController create({
//     required DataCtx configBits,
//   }) {
//     final tasksValue = fw(IList<LongRunningTask>());
//
//     final identifierSequence = configBits.sequencesFw.longRunningTaskId;
//
//     return ComposedLongRunningTasksController(
//       readWatchLongRunningTasks: tasksValue.toReadWatchValue,
//       addLongRunningTask: (builder) {
//         final taskId = identifierSequence.value;
//         identifierSequence.update((v) => v + 1);
//
//         final taskBits = builder(taskId);
//
//         final task = ComposedLongRunningTask.longRunningTaskBuildBits(
//           longRunningTaskBuildBits: taskBits,
//           longRunningTaskIdentifier: taskId,
//         );
//
//         tasksValue.update(
//           (v) => v.add(task),
//         );
//
//         return task;
//       },
//       removeLongRunningTask: (identifier) {
//         tasksValue.update(
//           (v) => v.removeWhere(
//             (element) => element.longRunningTaskIdentifier == identifier,
//           ),
//         );
//       },
//     );
//   }
// }
//
// void openLongRunningTaskShaft({
//   @Ext() required LongRunningTasks longRunningTasks,
//   required HasShaftCalcChain shaftCalc,
//   required LongRunningTaskIdentifier taskIdentifier,
// }) {
//   // longRunningTasks.updateView(
//   //   () {
//   //     longRunningTasks.stateFw.rebuild(
//   //       (state) {
//   //         final shaftMsg = shaftCalc.shaftCalcChain.shaftMsgFu.read();
//   //         state.topShaft = MshShaftMsg$.create(
//   //           shaftIdentifier: MshShaftIdentifierMsg$.create(
//   //             viewTask: MshViewTaskMsg$.create(
//   //               taskIdentifier: taskIdentifier,
//   //             ),
//   //           ),
//   //           parent: MshShaftMsg$.create(
//   //             shaftIdentifier: MshShaftIdentifierMsg$.create(
//   //               options: MshEmptyMsg.getDefault(),
//   //             ),
//   //             parent: shaftMsg,
//   //           ),
//   //         );
//   //       },
//   //     );
//   //   },
//   // );
// }
