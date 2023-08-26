import 'package:mhu_dart_commons/commons.dart';

import '../context/shaft.dart';
import '../shaft_factory.dart';


class MainMenuShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    return shaftCtx.customShaftActions.buildMainMenuShaftActions(shaftCtx);
  }
}
