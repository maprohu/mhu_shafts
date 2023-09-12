import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_dart_pbschema/mhu_dart_pbschema.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/context/shaft.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protobuf/protobuf.dart';

import '../shaft.dart';
import '../shaft_factory.dart';
import 'persist.dart' as $lib;

part 'persist.g.dart';

part 'persist.g.has.dart';

part 'persist/shaft.dart';
part 'persist/chunk.dart';

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
      MshShaftPersistedDataRecordSchema,
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
    = IsarSingletonWatchFactory<M>;

MshIsarSingletonWatchFactory<M>
    mshIsarSingletonWatchFactory<M extends GeneratedMessage>({
  @Ext() required CreateValue<M> createValue,
  DefaultValue? defaultValue,
}) {
  return createIsarSingletonProtoWriteOnlyWatchFactory(
    createValue: createValue,
    defaultValue: defaultValue,
    collectionBits: isarCollectionBits<MshSingletonRecord>(
      createIsarRecord: MshSingletonRecord.new,
      isarIdAttribute: hasIsarIdAttribute(),
    ),
  );
}

@Compose()
abstract class MshWindowStateIsarSingletonWatchFactory
    implements MshIsarSingletonWatchFactory<MshWindowStateMsg> {
  static final instance =
      ComposedMshWindowStateIsarSingletonWatchFactory.isarSingletonWatchFactory(
    isarSingletonWatchFactory:
        MshWindowStateMsg.new.mshIsarSingletonWatchFactory(),
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

// @Compose()
// abstract class MshShaftNotificationsIsarSingletonWatchFactory
//     implements MshIsarSingletonWatchFactory<MshShaftNotificationsMsg> {
//   static final instance = ComposedMshShaftNotificationsIsarSingletonWatchFactory
//       .isarSingletonWatchFactory(
//     isarSingletonWatchFactory:
//         MshShaftNotificationsMsg.new.mshIsarSingletonWatchFactory(),
//   );
// }

@Compose()
abstract class MshSequencesIsarSingletonWatchFactory
    implements MshIsarSingletonWatchFactory<MshSequencesMsg> {
  static final instance =
      ComposedMshSequencesIsarSingletonWatchFactory.isarSingletonWatchFactory(
    isarSingletonWatchFactory:
        MshSequencesMsg.new.mshIsarSingletonWatchFactory(),
  );
}

final isarSingletonWatchFactories =
    createIsarSingletonWatchFactories<Msg>({
  1: MshWindowStateIsarSingletonWatchFactory.instance,
  2: MshThemeIsarSingletonWatchFactory.instance,
  // 3: MshShaftNotificationsIsarSingletonWatchFactory.instance,
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
    isar: persistObj.isar,
    // isarSingletonCollection: persistObj.isar.mshSingletonRecords,
    disposers: persistObj.flushDisposers,
  );
}
