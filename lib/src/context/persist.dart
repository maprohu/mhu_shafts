import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
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

typedef MshIsarSingletonFwFactory<M>
    = IsarSingletonFwFactory<M, MshSingletonRecord>;

MshIsarSingletonFwFactory<M>
    mshIsarSingletonFwFactory<M extends GeneratedMessage>({
  @Ext() required CreateValue<M> createValue,
  DefaultValue? defaultValue,
}) {
  return createIsarSingletonProtoWriteOnlyFwFactory(
    createValue: createValue,
    createRecord: MshSingletonRecord.new,
    defaultValue: defaultValue,
  );
}

@Compose()
abstract class MshWindowStateIsarSingletonFwFactory
    implements MshIsarSingletonFwFactory<MshWindowStateMsg> {
  static final instance =
      ComposedMshWindowStateIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory: MshWindowStateMsg.new.mshIsarSingletonFwFactory(),
  );
}

@Compose()
abstract class MshThemeIsarSingletonFwFactory
    implements MshIsarSingletonFwFactory<MshThemeMsg> {
  static final instance =
      ComposedMshThemeIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory: MshThemeMsg.new.mshIsarSingletonFwFactory(),
  );
}

@Compose()
abstract class MshShaftNotificationsIsarSingletonFwFactory
    implements MshIsarSingletonFwFactory<MshShaftNotificationsMsg> {
  static final instance = ComposedMshShaftNotificationsIsarSingletonFwFactory
      .isarSingletonFwFactory(
    isarSingletonFwFactory:
        MshShaftNotificationsMsg.new.mshIsarSingletonFwFactory(),
  );
}

@Compose()
abstract class MshSequencesIsarSingletonFwFactory
    implements MshIsarSingletonFwFactory<MshSequencesMsg> {
  static final instance =
      ComposedMshSequencesIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory: MshSequencesMsg.new.mshIsarSingletonFwFactory(),
  );
}

final isarSingletonFwFactories =
    createIsarSingletonFwFactories<Msg, MshSingletonRecord>({
  1: MshWindowStateIsarSingletonFwFactory.instance,
  2: MshThemeIsarSingletonFwFactory.instance,
  3: MshShaftNotificationsIsarSingletonFwFactory.instance,
  4: MshSequencesIsarSingletonFwFactory.instance,
});

class PersistObjSingletonFactoryMarker<M extends Msg,
    F extends MshIsarSingletonFwFactory<M>> {
  late final F factory;
}

// PersistObjSingletonFactoryMarker<M, F> markPersistObjSingletonFactory<M extends Msg, F extends IsarSingletonFwFactory<M>>({
//
//
// })

// Future<Fw<M>> createPersistObjSingletonFw<M extends Msg,
//     F extends IsarSingletonFwFactory<M>>({
//   required PersistObj persistObj,
// }) {
//   return isarSingletonFwFactories
//       .lookupSingletonByType<F>()
//       .produceIsarSingletonFw(
//         isar: persistObj.isar,
//         disposers: persistObj.flushDisposers,
//       );
// }

Future<Fw<M>> mshProducePersistObjSingletonFw<M extends Msg>({
  @ext required MshIsarSingletonFwFactory<M> isarSingletonFwFactory,
  required PersistObj persistObj,
}) {
  return isarSingletonFwFactory.produceIsarSingletonFw(
    isarSingletonCollection: persistObj.isar.mshSingletonRecords,
    disposers: persistObj.flushDisposers,
  );
}
