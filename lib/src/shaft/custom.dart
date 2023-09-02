import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/context/text.dart';
import 'package:mhu_shafts/src/screen/opener.dart';
import 'package:mhu_shafts/src/shaft/main_menu.dart';
import 'package:mhu_shafts/src/wx/wx.dart';

import '../shaft_factory.dart';

class CustomShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    return shaftCtx.customShaftActions.buildCustomShaftActions(shaftCtx);
  }
}

