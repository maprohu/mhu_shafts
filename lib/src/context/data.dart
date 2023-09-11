import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_shafts/src/context/control.dart';
export 'package:mhu_shafts/src/context/asset.dart';
export 'package:mhu_shafts/src/context/persist.dart';

import '../../proto.dart';
import 'data.dart' as $lib;

part 'data.g.dart';

part 'data.g.has.dart';

@Has()
class DataObj with MixDataCtx, MixDisposers {
  late final dynamic config;
  late final WatchProto<MshWindowStateMsg> windowStateWatchVar;
  late final WatchProto<MshThemeMsg> themeWatchVar;
  // late final WatchProto<MshShaftNotificationsMsg> notificationsWatchVar;
  late final WatchProto<MshSequencesMsg> sequencesWatchVar;

  late final controlWrapWatch = disposers.watching(
    () => ControlWrap(),
  );
}

@Compose()
@Has()
abstract class DataCtx implements PersistCtx, HasDataObj {}

Future<DataCtx> createDataCtx({
  @Ext() required PersistCtx persistCtx,
}) async {
  final PersistCtx(
    :persistObj,
  ) = persistCtx;
  final dataObj = DataObj()
    ..disposers = DspImpl()
    ..windowStateWatchVar = await isarSingletonWatchFactories
        .lookupSingletonByType<MshWindowStateIsarSingletonWatchFactory>()
        .mshProducePersistObjSingletonWatch(persistObj: persistObj)
    ..themeWatchVar = await isarSingletonWatchFactories
        .lookupSingletonByType<MshThemeIsarSingletonWatchFactory>()
        .mshProducePersistObjSingletonWatch(persistObj: persistObj)
    ..sequencesWatchVar = await isarSingletonWatchFactories
        .lookupSingletonByType<MshSequencesIsarSingletonWatchFactory>()
        .mshProducePersistObjSingletonWatch(persistObj: persistObj);
    // ..notificationsWatchVar = await isarSingletonWatchFactories
    //     .lookupSingletonByType<MshShaftNotificationsIsarSingletonWatchFactory>()
    //     .mshProducePersistObjSingletonWatch(persistObj: persistObj);

  return ComposedDataCtx.persistCtx(
    persistCtx: persistCtx,
    dataObj: dataObj,
  )..initMixDataCtx(dataObj);
}

WindowStateMsg watchWindowStateMsg({
  @extHas required DataObj dataObj,
}) {
  return dataObj.windowStateWatchVar.watchOrDefaultMessage();
}

