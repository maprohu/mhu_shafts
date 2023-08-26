

// part 'inner_state.g.has.dart';
// part 'inner_state.g.compose.dart';

// typedef InnerStateKey = ShaftIndexFromLeft;
// typedef InnerStateFw = Fw<MshInnerStateMsg?>;

// Cache<InnerStateKey, Future<InnerStateFw>> innerStateFwCache({
//   required IsarDatabase isarDatabase,
//   required DspReg disposers,
// }) {
//   return Cache(
//     (key) => isarDatabase.mdiInnerStateRecords
//         .withCreateRecord(MshInnerStateRecord.new)
//         .protoRecordFwNullableWriteOnly(
//           id: key,
//           disposers: disposers,
//         ),
//   );
// }

// AccessInnerState createAccessInnerState({
//   required IsarDatabase isarDatabase,
//   required DspReg disposers,
// }) {
//   final cache = innerStateFwCache(
//     isarDatabase: isarDatabase,
//     disposers: disposers,
//   );
//
//   final taskQueue = KeyedTaskQueue<InnerStateKey>();
//
//   return <T>(key, action) async {
//     final innerStateFw = await cache.get(key);
//
//     return taskQueue.submit(
//       key,
//       () async => await action(innerStateFw),
//     );
//   };
// }

// extension InnerStateShaftCalcBuildBitsX on ShaftCalcBuildBits {
//   Widget innerStateWidget<S>({
//     required Future<S> Function(InnerStateFw innerStateFw) access,
//     required Widget Function(MshInnerStateMsg innerState, S value) builder,
//   }) {
//     return futureBuilderNull(
//       future: accessInnerState(
//         shaftCalcChain.shaftIndexFromLeft,
//         (innerStateFw) async => (innerStateFw, await access(innerStateFw)),
//       ),
//       builder: (context, record) {
//         return flcFrr(() {
//           final (innerStateFw, value) = record;
//
//           final innerState = innerStateFw();
//           if (innerState == null) {
//             return mdiBusyWidget;
//           }
//
//           return builder(innerState, value);
//         });
//       },
//     );
//   }
//
//   Widget innerStateWidgetVoid({
//     void Function(InnerStateFw innerStateFw)? access,
//     required Widget Function(
//       MshInnerStateMsg innerState,
//       void Function(MshInnerStateMsg? innerState) update,
//     ) builder,
//   }) {
//     return innerStateWidget(
//       access: (innerStateFw) async {
//         if (access != null) {
//           access(innerStateFw);
//         }
//         return innerStateFw.set;
//       },
//       builder: builder,
//     );
//   }
// }
