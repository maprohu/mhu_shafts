import 'dart:async';

import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';

import '../init.dart';
export '../init.dart';
import 'app.dart';


part 'config.g.has.dart';

part 'config.g.dart';

part 'config.freezed.dart';

@Compose()
abstract class ConfigCtx
    implements AppCtx, HasConfigObj, HasCustomShaftActions {}

@Has()
typedef ConfigObj = dynamic;

@Has()
typedef BuildConfigObj = FutureOr<ConfigObj> Function(AppCtx appCtx);
