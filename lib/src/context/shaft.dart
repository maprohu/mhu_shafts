import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_shafts/src/bx/screen.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/context/text.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:mhu_shafts/src/shaft/custom.dart';
import 'package:mhu_shafts/src/shaft/options.dart';
import 'package:mhu_shafts/src/shaft_factory.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:protobuf/protobuf.dart';
export 'package:mhu_shafts/src/context/render.dart';

import '../../proto.dart';
import '../bx/boxed.dart';
import '../model.dart';
import '../wx/wx.dart';
import 'shaft.dart' as $lib;

part 'shaft.g.dart';

part 'shaft.g.has.dart';

part 'shaft/render.dart';

part 'shaft/header.dart';

part 'shaft/open.dart';

part 'shaft/text.dart';

@Has()
class ShaftObj with MixShaftCtx, MixShaftMsg {
  late final ShaftObj? shaftOnRight;

  late final int indexFromRight = shaftOnRight?.indexFromRight.plus(1) ?? 0;

  late final ShaftObj? shaftOnLeft = shaftMsg.parentOpt?.let(
    (parentShaftMsg) => shaftCtx
        .createShaftCtx(
          shaftMsg: parentShaftMsg,
          shaftOnRight: this,
        )
        .shaftObj,
  );

  late final int indexFromLeft =
      shaftCtx.renderObj.maxShaftIndex - indexFromRight;

  late final shaftWidthUnits = shaftMsg.getShaftEffectiveWidthUnits();

  late final int totalWidthUnitsFromRightEndInclusive =
      shaftWidthUnits + totalWidthUnitsOnRight;
  late final int totalWidthUnitsOnRight =
      shaftOnRight?.totalWidthUnitsFromRightEndInclusive ?? 0;

  late final screenWidthUnitsAvailableForShaft =
      shaftCtx.renderObj.shaftWidthUnitsFitCount - totalWidthUnitsOnRight;

  late final visibleWidthUnits = min(
    shaftWidthUnits,
    screenWidthUnitsAvailableForShaft,
  );

  late final isVisible = screenWidthUnitsAvailableForShaft > 0;

  late final shaftIdentifier = shaftMsg.shaftIdentifier;
  late final shaftFactoryKey = shaftIdentifier.shaftFactoryKey;

  late final shaftActions = mshLookupKeyShaftFactory(
    shaftFactoryKey: shaftFactoryKey,
  ).buildShaftActions(shaftCtx);

  late final shaftIdentifierObj =
      shaftIdentifier.parseShaftIdentifier(shaftObj: this);

}

@Compose()
@Has()
abstract class ShaftCtx implements RenderCtx, HasShaftObj {}

ShaftCtx createShaftCtx({
  @Ext() required RenderCtx renderCtx,
  @ext required ShaftMsg shaftMsg,
  required ShaftObj? shaftOnRight,
}) {
  final shaftObj = ShaftObj().also(shaftMsg.initMixShaftMsg)
    ..shaftOnRight = shaftOnRight;

  return ComposedShaftCtx.renderCtx(
    renderCtx: renderCtx,
    shaftObj: shaftObj,
  )..initMixShaftCtx(shaftObj);
}

Iterable<ShaftCtx> shaftCtxLeftIterable({
  @extHas required ShaftCtx shaftCtx,
}) {
  return shaftCtx.finiteIterable(
    (item) => item.shaftObj.shaftOnLeft?.shaftCtx,
  );
}

ShaftMsg? readShaftMsg({
  @extHas required ShaftObj shaftObj,
}) {
  return shaftObj.shaftCtx.windowObj.windowStateWatchVar
      .readOrDefaultMessage()
      .getEffectiveTopShaft()
      .shaftMsgByIndexFromLeft(shaftObj.indexFromLeft);
}

// Fu<MshShaftMsg> shaftMsgFuByIndex({
//   required ConfigCtx configCtx,
//   required ShaftIndexFromLeft shaftIndexFromLeft,
// }) {
//   return Fu.fromFr(
//     fr: configCtx.stateFw.map((state) {
//       return state.effectiveTopShaft
//           .getShaftByIndexFromLeft(shaftIndexFromLeft);
//     }),
//     update: (updates) {
//       configCtx.stateFw.deepRebuild((state) {
//         state
//             .ensureEffectiveTopShaft()
//             .getShaftByIndexFromLeft(shaftIndexFromLeft)
//             .let(updates);
//       });
//     },
//   );
// }

ShaftIdentifierObj parseShaftIdentifier({
  @extHas required ShaftObj shaftObj,
  @ext required MshShaftIdentifierMsg shaftIdentifierMsg,
}) {
  return shaftObj.shaftActions
      .callParseShaftIdentifier()
      .call(shaftIdentifierMsg);
}

ShaftIdentifierMsg shaftCtxInnerIdentifierMsg({
  @extHas required ShaftObj shaftObj,
}) {
  return shaftObj.shaftIdentifier.innerShaftIdentifierMsg();
}

ShaftCtx shaftCtxOnLeft({
  @extHas required ShaftObj shaftObj,
}) {
  return shaftObj.shaftOnLeft!.shaftCtx;
}
