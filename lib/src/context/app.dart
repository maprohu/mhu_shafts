import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/config.dart';
import 'package:mhu_shafts/src/context/rect.dart';
export 'package:mhu_shafts/src/context/tasks.dart';
export 'package:mhu_shafts/src/context/theme.dart';
export 'package:mhu_shafts/src/context/data.dart';
import '../init.dart';
import 'app.dart' as $lib;

part 'app.g.dart';

part 'app.g.has.dart';


@Has()
class AppObj with MixAppCtx, MixDisposers {
  late final WindowCtx windowCtx;

  late final themeWrapFr = disposers.fr(
    () => appCtx.createThemeWrap(
      themeMsg: appCtx.dataObj.themeFw(),
    ),
  );
}

@Compose()
@Has()
abstract class AppCtx implements DataCtx, AssetCtx, HasAppObj, HasTasksObj {}

Future<AppCtx> createAppCtx({
  @Ext() required DataCtx dataCtx,
  required AssetCtx assetCtx,
  required Disposers disposers,
  required BuildConfigObj buildConfigObj,
  required CustomShaftActions customShaftActions,
}) async {
  final appObj = AppObj()..disposers = disposers;

  final tasksObj = dataCtx.createTasksObj();

  final appCtx = ComposedAppCtx.merge$(
    dataCtx: dataCtx,
    assetCtx: assetCtx,
    appObj: appObj,
    tasksObj: tasksObj,
  )..initMixAppCtx(appObj);

  final configObj = await buildConfigObj(
    appCtx,
  );

  final configCtx = ComposedConfigCtx.appCtx(
    appCtx: appCtx,
    configObj: configObj,
    customShaftActions: customShaftActions,
  );

  appObj.windowCtx = await configCtx.createWindowCtx(
    disposers: disposers,
  );

  return appCtx;
}
