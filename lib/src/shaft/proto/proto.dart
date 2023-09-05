import 'dart:ui';

import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_dart_pbschema/mhu_dart_pbschema.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/context/text.dart';
import 'package:mhu_shafts/src/shaft/main_menu.dart';
import 'package:mhu_shafts/src/shaft/proto/proto_customizer.dart';
import 'package:mhu_shafts/src/wx/wx.dart';
import 'package:protobuf/protobuf.dart';

import 'proto.dart' as $lib;
// part 'proto.g.has.dart';
part 'proto.g.dart';

part 'message.dart';
part 'field.dart';

part 'field/scalar.dart';
part 'field/string.dart';
part 'field/int.dart';
part 'field/map.dart';
