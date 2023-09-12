import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_shafts/src/context/shaft.dart';
import 'package:mhu_shafts/src/context/text.dart';
import 'package:mhu_shafts/src/shaft_factory.dart';
import 'package:mhu_shafts/src/wx/wx.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
export 'package:mhu_shafts/src/context/shaft.dart';

import '../layout.dart';
import 'rect.dart' as $lib;

part 'rect.g.dart';

part 'rect.g.has.dart';

part 'rect/fill.dart';

part 'rect/padding.dart';

part 'rect/divider.dart';

part 'rect/aim.dart';

part 'rect/chunk.dart';

part 'rect/sharing_box.dart';

part 'rect/menu.dart';

part 'rect/linear.dart';

part 'rect/text.dart';

@Has()
typedef WxRectBuilder = Wx Function(RectCtx rectCtx);

// @Has()
// @Compose()
// abstract base class RectObj implements HasSize {}

@Compose()
abstract class RectCtx implements ShaftCtx, HasSize {}

RectCtx createRectCtx({
  @Ext() required ShaftCtx shaftCtx,
  required Size size,
}) {
  return ComposedRectCtx.shaftCtx(
    shaftCtx: shaftCtx,
    size: size,
  );
}

RectCtx rectWithSize({
  @ext required RectCtx rectCtx,
  @extHas required Size size,
}) {
  return rectCtx.createRectCtx(
    size: size,
  );
}

RectCtx rectWithAxisDimension({
  @ext required RectCtx rectCtx,
  @ext required Axis axis,
  required Dimension dimension,
}) {
  return rectCtx.rectWithSize(
    size: rectCtx.sizeWithAxisDimension(
      axis: axis,
      dimension: dimension,
    ),
  );
}

RectCtx rectWithWidth({
  @ext required RectCtx rectCtx,
  required double width,
}) {
  return rectCtx.rectWithSize(
    size: rectCtx.sizeWithWidth(
      width: width,
    ),
  );
}

RectCtx rectWithHeight({
  @ext required RectCtx rectCtx,
  required double height,
}) {
  return rectCtx.rectWithSize(
    size: rectCtx.sizeWithHeight(
      height: height,
    ),
  );
}
