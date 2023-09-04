import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_dart_pbschema/mhu_dart_pbschema.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts_example/src/generated/mhu_shafts_example.pbschema.dart';

import 'main.dart' as $lib;
import 'proto.dart';

part 'main.g.has.dart';
part 'main.g.dart';

// part 'main.freezed.dart';

part 'main_menu.dart';

part 'custom_shafts.dart';

part 'proto_shaft.dart';

part 'config.dart';


void main() async {
  initMhuShafts();

  final app = ComposedMhuShaftsConfig(
    isarSchemas: [],
    buildConfigObj: createSampleConfigObj,
    buildCustomShaftActions: sampleCustomShaftActions,
    buildMainMenuShaftActions: sampleMainMenu,
  ).mhuShaftsApp();

  runApp(app);

  // runApp(Placeholder());
}
