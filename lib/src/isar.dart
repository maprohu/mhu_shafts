//
// import 'dart:async';
//
// import 'package:isar/isar.dart';
// import 'package:logger/logger.dart';
// import 'package:mhu_dart_commons/isar.dart';
// import 'package:path_provider/path_provider.dart';
//
// // part 'isar.g.dart';
//
// final _logger = Logger();
//
// enum MshSingleton {
//   config,
//   state,
//   theme,
//   notifications,
//   sequences,
// }
//
// Future<Isar> mdiCreateIsar() async {
//   final dir = await getApplicationSupportDirectory();
//
//   _logger.i("isar dir: $dir");
//
//   return await Isar.open(
//     [
//       SingletonRecordSchema,
//       // MshInnerStateRecordSchema,
//     ],
//     directory: dir.path,
//   );
// }
//
// // @collection
// // class MshInnerStateRecord
// //     with BlobRecord, IsarIdRecord, ProtoRecord<MshInnerStateMsg> {
// //   @override
// //   MshInnerStateMsg createProto$() => MshInnerStateMsg();
// // }

