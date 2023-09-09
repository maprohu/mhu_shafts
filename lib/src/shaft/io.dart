part of '../shaft.dart';

class IoShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    return ioShaftActions(shaftCtx);
  }
}

late final BuildCustomShaftActions ioShaftActions;
