part of '../shaft.dart';

Int64 nextShaftSequence({
  @extHas required DataObj dataObj,
}) {
  final fv = dataObj.sequencesWatchVar.shaftSeq;
  final next = fv.readValue() ?? Int64.ZERO;
  fv.value = next + 1;
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
  required ShaftEphemeralRecord? shaftEphemeralRecord,
}) {
  shaftCtx.windowUpdateView(() {
    final shaftSeq = shaftCtx.nextShaftSequence();
    if (shaftEphemeralRecord != null) {
      shaftCtx.windowObj.shaftEphemeralStore[shaftSeq] = shaftEphemeralRecord;
    }
    shaftCtx.windowObj.windowStateWatchVar.topShaft.value = shaftMsg
        .addShaftMsgParent(
          shaftCtx: shaftCtx,
        )
        .rebuild(
          (msg) => msg.shaftSeq = shaftSeq,
        );
  });
}

ShaftCtx createOpenedShaftCtx({
  @ext required ShaftOpener shaftOpener,
  @ext required ShaftCtx shaftCtx,
}) {
  return shaftOpener
      .openerShaftMsg()
      .addShaftMsgParent(shaftCtx: shaftCtx)
      .createShaftCtx(
        renderCtx: shaftCtx,
        shaftOnRight: null,
      );
}

@Has()
typedef UpdateShaftIdentifier = void Function(
  MshShaftIdentifierMsg shaftIdentifierMsg,
);
// @Has()
// typedef UpdateShaftInnerState = void Function(
//   MshInnerStateMsg innerStateMsg,
// );

// @Has()
// typedef AsyncUpdateShaftInnerState
//     = Call<CancelableOperation<UpdateShaftInnerState>>;

void shaftEmptyInnerState(MshInnerStateMsg innerStateMsg) {}

@Compose()
abstract class ShaftOpener
    implements HasUpdateShaftIdentifier // , HasUpdateShaftInnerState
{}

// @Compose()
// abstract class AsyncShaftOpener
//     implements HasUpdateShaftIdentifier
//     // , HasAsyncUpdateShaftInnerState
// {}

MshShaftIdentifierMsg openerShaftIdentifierMsg({
  @ext required HasUpdateShaftIdentifier shaftOpener,
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

  final rightIdentifierObj = shaftOnRight.shaftIdentifierObj;

  final openerIdentifierObj = createOpenedShaftCtx(
    shaftOpener: shaftOpener,
    shaftCtx: shaftCtx,
  ).shaftObj.shaftIdentifierObj;

  return rightIdentifierObj == openerIdentifierObj;
}

Wx wxDecorateShaftOpenBool({
  @ext required Wx wx,
  required bool isOpen,
  @ext required ThemeWrap themeWrap,
}) {
  if (isOpen) {
    return wx.wxBackgroundColor(
      color: themeWrap.openerIsOpenBackgroundColor,
    );
  } else {
    return wx;
  }
}

Wx wxDecorateShaftOpener({
  @ext required Wx wx,
  @ext required ShaftOpener shaftOpener,
  @ext required ShaftCtx shaftCtx,
}) {
  return wxDecorateShaftOpenBool(
    wx: wx,
    isOpen: isShaftOpen(shaftOpener: shaftOpener, shaftCtx: shaftCtx),
    themeWrap: shaftCtx.renderCtxThemeWrap(),
  );
}

UpdateShaftIdentifier factoriesUpdateShaftIdentifier<F extends ShaftFactory>({
  @ext required ShaftFactories shaftFactories,
  CmnAnyMsg? identifierAnyData,
}) {
  assert(F != ShaftFactory);
  final shaftFactory = shaftFactories.shaftFactoriesLookupType<F>();
  final shaftFactoryKey = shaftFactory.getShaftFactoryKey();

  return (shaftIdentifierMsg) {
    shaftIdentifierMsg.shaftFactoryKeyPath.add(shaftFactoryKey);
    if (identifierAnyData != null) {
      shaftIdentifierMsg.anyData = identifierAnyData;
    }
  };
}

ShaftOpener factoriesShaftOpenerOf<F extends ShaftFactory>({
  @ext required ShaftFactories shaftFactories,
  CmnAnyMsg? identifierAnyData,
  // UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  assert(F != ShaftFactory);
  return ComposedShaftOpener(
    updateShaftIdentifier: shaftFactories.factoriesUpdateShaftIdentifier<F>(
      identifierAnyData: identifierAnyData,
    ),
    // updateShaftInnerState: updateShaftInnerState,
  );
}

// AsyncShaftOpener factoriesAsyncShaftOpenerOf<F extends ShaftFactory>({
//   @ext required ShaftFactories shaftFactories,
//   CmnAny? identifierAnyData,
//   required AsyncUpdateShaftInnerState updateShaftInnerState,
// }) {
//   assert(F != ShaftFactory);
//   return ComposedAsyncShaftOpener(
//     updateShaftIdentifier: shaftFactories.factoriesUpdateShaftIdentifier<F>(
//       identifierAnyData: identifierAnyData,
//     ),
//     asyncUpdateShaftInnerState: updateShaftInnerState,
//   );
// }

ShaftOpener mshShaftOpenerOf<F extends ShaftFactory>({
  CmnAnyMsg? identifierAnyData,
  // UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  assert(F != ShaftFactory);
  return mshShaftFactories.factoriesShaftOpenerOf<F>(
    identifierAnyData: identifierAnyData,
    // updateShaftInnerState: updateShaftInnerState,
  );
}

ShaftOpener mshCustomShaftOpener({
  @ext required ShaftOpener shaftOpener,
}) {
  return mshShaftFactories.factoriesCustomShaftOpenerOf<CustomShaftFactory>(
    shaftOpener: shaftOpener,
  );
}

ShaftOpener mshIoShaftOpener({
  @ext required ShaftOpener shaftOpener,
}) {
  return mshShaftFactories.factoriesCustomShaftOpenerOf<IoShaftFactory>(
    shaftOpener: shaftOpener,
  );
}

// AsyncShaftOpener mshCustomAsyncShaftOpener({
//   @ext required AsyncShaftOpener shaftOpener,
// }) {
//   return mshShaftFactories
//       .factoriesCustomAsyncShaftOpenerOf<CustomShaftFactory>(
//     shaftOpener: shaftOpener,
//   );
// }

ShaftOpener factoriesCustomShaftOpenerOf<F extends ShaftFactory>({
  @ext required ShaftOpener shaftOpener,
  @ext required ShaftFactories shaftFactories,
}) {
  assert(F != ShaftFactory);
  // final customIdentifier = shaftOpener.openerShaftIdentifierMsg();
  final shaftFactory = shaftFactories.shaftFactoriesLookupType<F>();
  final shaftFactoryKey = shaftFactory.getShaftFactoryKey();
  return ComposedShaftOpener(
    updateShaftIdentifier: (shaftIdentifierMsg) {
      shaftOpener.updateShaftIdentifier(shaftIdentifierMsg);
      shaftIdentifierMsg.shaftFactoryKeyPath.insert(
        0,
        shaftFactoryKey,
      );
    },
  );
  // return factoriesShaftOpenerOf<F>(
  //   shaftFactories: shaftFactories,
  //   // updateShaftInnerState: shaftOpener.updateShaftInnerState,
  //   identifierAnyData: customIdentifier.writeToBuffer().cmnAnyFromBytes(),
  // );
}

// AsyncShaftOpener factoriesCustomAsyncShaftOpenerOf<F extends ShaftFactory>({
//   @ext required AsyncShaftOpener shaftOpener,
//   @ext required ShaftFactories shaftFactories,
// }) {
//   assert(F != ShaftFactory);
//   final customIdentifier = shaftOpener.openerShaftIdentifierMsg();
//   return factoriesAsyncShaftOpenerOf<F>(
//     shaftFactories: shaftFactories,
//     updateShaftInnerState: shaftOpener.asyncUpdateShaftInnerState,
//     identifierAnyData: customIdentifier.writeToBuffer().cmnAnyFromBytes(),
//   );
// }

ShaftMsg openerShaftMsg({
  @ext required ShaftOpener shaftOpener,
}) {
  final shaftMsg = ShaftMsg();
  shaftOpener.updateShaftIdentifier(shaftMsg.ensureShaftIdentifier());
  // shaftOpener.updateShaftInnerState(shaftMsg.ensureInnerState());
  return shaftMsg..freeze();
}

VoidCallback openShaftAction({
  @ext required ShaftCtx shaftCtx,
  @ext required ShaftOpener shaftOpener,
}) {
  return () {
    openShaftOpener(
      shaftCtx: shaftCtx,
      shaftOpener: shaftOpener,
      shaftEphemeralRecord: null,
    );
  };
}

void openShaftOpener({
  @ext required ShaftCtx shaftCtx,
  @ext required ShaftOpener shaftOpener,
  required ShaftEphemeralRecord? shaftEphemeralRecord,
}) {
  shaftCtx.openShaftMsg(
    shaftMsg: shaftOpener.openerShaftMsg(),
    shaftEphemeralRecord: shaftEphemeralRecord,
  );
}

bool shaftIsInStack({
  @ext required ShaftCtx shaftCtx,
}) {
  final shaftSeq = shaftCtx.shaftObj.shaftMsg.shaftSeq;
  return shaftCtx.windowObj.windowStateWatchVar
      .readOrDefaultMessage()
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

    for (final shaft in shaftCtx.shaftCtxRightIterable()) {
      final record = shaftCtx.windowObj.shaftEphemeralStore
          .remove(shaft.shaftCtxShaftSeq());
      record?.disposers.dispose();
    }

    shaftCtx.windowUpdateView(() {
      shaftCtx.windowObj.windowStateWatchVar.topShaft.value =
          shaftOnLeft.shaftMsg;
    });
  };
}

WxRectBuilder shaftOpenerPreviewWxRectBuilder({
  required ShaftOpener shaftOpener,
  required String label,
  required String value,
}) {
  return (rectCtx) {
    final themeWrap = rectCtx.renderCtxThemeWrap();
    return wxRectPaddingSizer(
      rectCtx: rectCtx,
      paddingSizer: themeWrap.protoFieldPaddingSizer,
      builder: (rectCtx) {
        final labelCtx = rectCtx.rectWithHeight(
          height: themeWrap.protoFieldLabelHeight,
        );
        final labelTextStyleWrap = themeWrap.protoFieldLabelTextStyleWrap;

        final labelWx = labelCtx.wxRectFillRight(
          left: [
            rectCtx.wxRectAim(
              action: shaftOpener.openShaftAction(
                shaftCtx: rectCtx,
              ),
              horizontal: null,
              vertical: AxisAlignment.center,
            ),
          ],
          right: (rectCtx) {
            return rectCtx
                .createTextCtx(
                  textStyleWrap: labelTextStyleWrap,
                )
                .wxTextAlign(
                  text: label,
                );
          },
        );

        final valueWx = rectCtx
            .createTextCtx(
                textStyleWrap: themeWrap.protoFieldValueTextStyleWrap)
            .wxTextHorizontal(text: value);

        return rectCtx.wxRectColumnExact(
          children: [
            labelWx,
            rectCtx
                .rectWithHeight(height: themeWrap.protoFieldLabelValueGapHeight)
                .wxEmpty(),
            valueWx,
          ],
        );
      },
    ).wxDecorateShaftOpener(
      shaftOpener: shaftOpener,
      shaftCtx: rectCtx,
    );
  };
}
