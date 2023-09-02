import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/shaft_factory.dart';

import '../proto.dart';

import 'screen/app.dart';

import 'init.dart' as $lib;

part 'init.g.has.dart';

part 'init.g.dart';


@Has()
typedef IsarSchemas = List<CollectionSchema>;

@Has()
typedef BuildCustomShaftActions = ShaftActions Function(ShaftCtx shaftCtx);

@Has()
typedef BuildMainMenuShaftActions = BuildShaftActions;

@Compose()
@Has()
abstract class CustomShaftActions
    implements HasBuildCustomShaftActions, HasBuildMainMenuShaftActions {}

@Compose()
abstract class MhuShaftsConfig
    implements CustomShaftActions, HasIsarSchemas, HasBuildConfigObj {}

void initMhuShafts() {
  GoogleFonts.config.allowRuntimeFetching = false;
  WidgetsFlutterBinding.ensureInitialized();
  mhuShaftsLib.register();
}

Widget mhuShaftsApp({
  @ext required MhuShaftsConfig mhuShaftsConfig,
}) {
  return flcAsyncDisposeWidget(
    waiting: nullWidget,
    builder: (disposers) async {
      final persistCtx = await createPersistCtx(
        disposers: disposers,
        schemas: mhuShaftsConfig.isarSchemas,
      );

      final assetCtx = await createAssetCtx();

      final dataCtx = await persistCtx.createDataCtx();

      final appCtx = await dataCtx.createAppCtx(
        assetCtx: assetCtx,
        disposers: disposers,
        buildConfigObj: mhuShaftsConfig.buildConfigObj,
        customShaftActions: mhuShaftsConfig,
      );

      final windowCtx = appCtx.appObj.windowCtx;

      return MshApp(
        windowObj: windowCtx.windowObj,
      );
    },
  );
}
