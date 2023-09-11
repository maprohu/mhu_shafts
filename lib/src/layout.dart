import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_shafts/src/context/text.dart';

import 'layout.dart' as $lib;
import 'wx/wx.dart';
part 'layout.g.has.dart';
part 'layout.g.dart';

part 'layout.freezed.dart';

part 'layout/widget_line.dart';
part 'layout/text.dart';


int itemFitCount({
  required double available,
  required double itemSize,
  required double dividerThickness,
}) {
  final remaining = available - itemSize;
  if (remaining < 0) {
    return 0;
  }

  return 1 + (remaining ~/ (itemSize + dividerThickness));
}
