part of '../window.dart';

void windowInitializeShaftPersistedData({
  @extHas required WindowObj windowObj,
  required ShaftPersistedDataActions persistedDataActions,
  required ShaftSeq shaftSeq,
}) {
  windowObj.shaftPersistedStore[shaftSeq] =
      windowObj.windowCtx.createShaftPersistedRecord(
    shaftSeq: shaftSeq,
    persistedDataActions: persistedDataActions,
  );
}
