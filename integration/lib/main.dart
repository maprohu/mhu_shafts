import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:mhu_shafts/proto.dart';

part 'main_menu.dart';
part 'custom_shafts.dart';
part 'proto_shaft.dart';

void main() async {
  initMhuShafts();

  final app = ComposedMhuShaftsConfig(
    isarSchemas: [],
    buildConfigObj: (appCtx) => null,
    buildCustomShaftActions: sampleCustomShaftActions,
    buildMainMenuShaftActions: sampleMainMenu,
  ).mhuShaftsApp();

  runApp(app);
}
