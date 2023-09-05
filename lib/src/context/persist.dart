import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_pbschema/mhu_dart_pbschema.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protobuf/protobuf.dart';

import 'persist.dart' as $lib;

part 'persist.g.dart';

part 'persist.g.has.dart';

@Has()
class PersistObj with MixIsar {
  final flushDisposers = DspImpl();
}

@Compose()
abstract class PersistCtx implements HasPersistObj {}

@collection
final class MshSingletonRecord extends SingletonRecord {}

Future<PersistCtx> createPersistCtx({
  @Ext() required DspReg disposers,
  List<CollectionSchema<dynamic>> schemas = const [],
}) async {
  final dir = await getApplicationSupportDirectory();

  logger.i("isar dir: $dir");
  final isar = await Isar.open(
    [
      MshSingletonRecordSchema,
      ...schemas,
    ],
    directory: dir.path,
  );
  final persistObj = PersistObj()..isar = isar;

  disposers.add(() async {
    await persistObj.flushDisposers.dispose();
    await isar.dispose();
  });

  return ComposedPersistCtx(
    persistObj: persistObj,
  );
}

typedef MshIsarSingletonWatchFactory<M extends Object>
    = IsarSingletonWatchFactory<M, MshSingletonRecord>;

MshIsarSingletonWatchFactory<M>
    mshIsarSingletonWatchFactory<M extends GeneratedMessage>({
  @Ext() required CreateValue<M> createValue,
  DefaultValue? defaultValue,
}) {
  return createIsarSingletonProtoWriteOnlyWatchFactory(
    createValue: createValue,
    createRecord: MshSingletonRecord.new,
    defaultValue: defaultValue,
  );
}

@Compose()
abstract class MshWindowStateIsarSingletonWatchFactory
    implements MshIsarSingletonWatchFactory<MshWindowStateMsg> {
  static final instance =
      ComposedMshWindowStateIsarSingletonWatchFactory.isarSingletonWatchFactory(
    isarSingletonWatchFactory: MshWindowStateMsg.new.mshIsarSingletonWatchFactory(),
  );
}

@Compose()
abstract class MshThemeIsarSingletonWatchFactory
    implements MshIsarSingletonWatchFactory<MshThemeMsg> {
  static final instance =
      ComposedMshThemeIsarSingletonWatchFactory.isarSingletonWatchFactory(
    isarSingletonWatchFactory: MshThemeMsg.new.mshIsarSingletonWatchFactory(),
  );
}

@Compose()
abstract class MshShaftNotificationsIsarSingletonWatchFactory
    implements MshIsarSingletonWatchFactory<MshShaftNotificationsMsg> {
  static final instance = ComposedMshShaftNotificationsIsarSingletonWatchFactory
      .isarSingletonWatchFactory(
    isarSingletonWatchFactory:
        MshShaftNotificationsMsg.new.mshIsarSingletonWatchFactory(),
  );
}

@Compose()
abstract class MshSequencesIsarSingletonWatchFactory
    implements MshIsarSingletonWatchFactory<MshSequencesMsg> {
  static final instance =
      ComposedMshSequencesIsarSingletonWatchFactory.isarSingletonWatchFactory(
    isarSingletonWatchFactory: MshSequencesMsg.new.mshIsarSingletonWatchFactory(),
  );
}

final isarSingletonWatchFactories =
    createIsarSingletonWatchFactories<Msg, MshSingletonRecord>({
  1: MshWindowStateIsarSingletonWatchFactory.instance,
  2: MshThemeIsarSingletonWatchFactory.instance,
  3: MshShaftNotificationsIsarSingletonWatchFactory.instance,
  4: MshSequencesIsarSingletonWatchFactory.instance,
});

class PersistObjSingletonFactoryMarker<M extends Msg,
    F extends MshIsarSingletonWatchFactory<M>> {
  late final F factory;
}

// PersistObjSingletonFactoryMarker<M, F> markPersistObjSingletonFactory<M extends Msg, F extends IsarSingletonWatchFactory<M>>({
//
//
// })

// Future<Watch<M>> createPersistObjSingletonWatch<M extends Msg,
//     F extends IsarSingletonWatchFactory<M>>({
//   required PersistObj persistObj,
// }) {
//   return isarSingletonWatchFactories
//       .lookupSingletonByType<F>()
//       .produceIsarSingletonWatch(
//         isar: persistObj.isar,
//         disposers: persistObj.flushDisposers,
//       );
// }

Future<WatchProto<M>> mshProducePersistObjSingletonWatch<M extends Msg>({
  @ext required MshIsarSingletonWatchFactory<M> isarSingletonWatchFactory,
  required PersistObj persistObj,
}) {
  assert(M != Msg);
  return isarSingletonWatchFactory.produceIsarSingletonWatch(
    isarSingletonCollection: persistObj.isar.mshSingletonRecords,
    disposers: persistObj.flushDisposers,
  );
}
