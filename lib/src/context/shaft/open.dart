part of '../shaft.dart';

Int64 nextShaftSequence({
  @extHas required DataObj dataObj,
}) {
  final fv = dataObj.sequencesFw.shaftSeq;

  final next = fv.value;

  fv.update((v) => v + 1);

  return next;
}

ShaftMsg addShaftMsgParent({
  @ext required ShaftCtx shaftCtx,
  @ext required ShaftMsg shaftMsg,
}) {
  return shaftMsg.rebuild(
    (msg) => msg.parent = shaftCtx.readShaftMsg()!,
  );
}

void openShaftMsg({
  @ext required ShaftCtx shaftCtx,
  required ShaftMsg shaftMsg,
}) {
  shaftCtx.windowUpdateView(() {
    shaftCtx.windowObj.windowStateFw.topShaft.value = shaftMsg
        .addShaftMsgParent(
          shaftCtx: shaftCtx,
        )
        .rebuild(
          (msg) => msg.shaftSeq = shaftCtx.nextShaftSequence(),
        );
  });
}

@Has()
typedef UpdateShaftIdentifier = void Function(
  MshShaftIdentifierMsg shaftIdentifierMsg,
);
@Has()
@HasDefault(shaftEmptyInnerState)
typedef UpdateShaftInnerState = void Function(
  MshInnerStateMsg innerStateMsg,
);

void shaftEmptyInnerState(MshInnerStateMsg innerStateMsg) {}

@Compose()
abstract class ShaftOpener
    implements HasUpdateShaftIdentifier, HasUpdateShaftInnerState {}

MshShaftIdentifierMsg openerShaftIdentifierMsg({
  @ext required ShaftOpener shaftOpener,
}) {
  return MshShaftIdentifierMsg().also(shaftOpener.updateShaftIdentifier)
    ..freeze();
}

bool isShaftOpen({
  @ext required ShaftOpener shaftOpener,
  @ext required ShaftCtx shaftCtx,
}) {
  final shaftOnRight = shaftCtx.shaftObj.shaftOnRight;

  if (shaftOnRight == null) {
    return false;
  }

  final shaftIdentifier = shaftOpener.openerShaftIdentifierMsg();

  return shaftOnRight.shaftMsg.shaftIdentifier == shaftIdentifier;
}

Wx wxDecorateShaftOpener({
  @ext required Wx wx,
  @ext required ShaftOpener shaftOpener,
  @ext required ShaftCtx shaftCtx,
}) {
  if (isShaftOpen(shaftOpener: shaftOpener, shaftCtx: shaftCtx)) {
    return wx.wxBackgroundColor(
      color: shaftCtx.renderObj.themeWrap.openerIsOpenBackgroundColor,
    );
  } else {
    return wx;
  }
}

UpdateShaftIdentifier factoriesUpdateShaftIdentifier<F extends ShaftFactory>({
  @ext required ShaftFactories shaftFactories,
  CmnAny? identifierAnyData,
}) {
  assert(F != ShaftFactory);
  final shaftFactory = shaftFactories.shaftFactoriesLookupType<F>();
  final shaftFactoryKey = shaftFactory.getShaftFactoryKey();

  return (shaftIdentifierMsg) {
    shaftIdentifierMsg.shaftFactoryKey = shaftFactoryKey;
    if (identifierAnyData != null) {
      shaftIdentifierMsg.anyData = identifierAnyData;
    }
  };
}

ShaftOpener factoriesShaftOpenerOf<F extends ShaftFactory>({
  @ext required ShaftFactories shaftFactories,
  CmnAny? identifierAnyData,
  UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  assert(F != ShaftFactory);
  return ComposedShaftOpener(
    updateShaftIdentifier: shaftFactories.factoriesUpdateShaftIdentifier<F>(
      identifierAnyData: identifierAnyData,
    ),
    updateShaftInnerState: updateShaftInnerState,
  );
}

ShaftOpener mshShaftOpenerOf<F extends ShaftFactory>({
  CmnAny? identifierAnyData,
  UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  assert(F != ShaftFactory);
  return mshShaftFactories.factoriesShaftOpenerOf<F>(
    identifierAnyData: identifierAnyData,
    updateShaftInnerState: updateShaftInnerState,
  );
}

ShaftOpener mshCustomShaftOpener({
  @ext required ShaftOpener shaftOpener,
}) {
  return mshShaftFactories.factoriesCustomShaftOpenerOf<CustomShaftFactory>(
    shaftOpener: shaftOpener,
  );
}

ShaftOpener factoriesCustomShaftOpenerOf<F extends ShaftFactory>({
  @ext required ShaftOpener shaftOpener,
  @ext required ShaftFactories shaftFactories,
}) {
  assert(F != ShaftFactory);
  final customIdentifier = shaftOpener.openerShaftIdentifierMsg();
  return factoriesShaftOpenerOf<F>(
    shaftFactories: shaftFactories,
    updateShaftInnerState: shaftOpener.updateShaftInnerState,
    identifierAnyData: customIdentifier.writeToBuffer().cmnAnyFromBytes(),
  );
}

ShaftMsg openerShaftMsg({
  @ext required ShaftOpener shaftOpener,
}) {
  final shaftMsg = ShaftMsg();
  shaftOpener.updateShaftIdentifier(shaftMsg.ensureShaftIdentifier());
  shaftOpener.updateShaftInnerState(shaftMsg.ensureInnerState());
  return shaftMsg..freeze();
}

void openShaftOpener({
  @ext required ShaftCtx shaftCtx,
  @ext required ShaftOpener shaftOpener,
}) {
  shaftCtx.openShaftMsg(
    shaftMsg: shaftOpener.openerShaftMsg(),
  );
}

bool shaftIsInStack({
  @ext required ShaftCtx shaftCtx,
}) {
  final shaftSeq = shaftCtx.shaftObj.shaftMsg.shaftSeq;
  return shaftCtx.windowObj.windowStateFw
      .read()
      .getEffectiveTopShaft()
      .shaftMsgIterableLeft()
      .any((s) => s.shaftSeq == shaftSeq);
}

VoidCallback? shaftCloseAction({
  @extHas required ShaftObj shaftObj,
}) {
  final shaftOnLeft = shaftObj.shaftOnLeft;

  if (shaftOnLeft == null) {
    return null;
  }

  final shaftCtx = shaftObj.shaftCtx;

  return () {
    assert(shaftCtx.shaftIsInStack());
    shaftCtx.windowUpdateView(() {
      shaftCtx.windowObj.windowStateFw.topShaft.value = shaftOnLeft.shaftMsg;
    });
  };
}
