part of '../shaft.dart';

WatchWrite<D> shaftPersistedData<D>({
  @ext required ShaftCtx shaftCtx,
}) {
  return shaftCtx.windowObj.shaftPersistedStore[shaftCtx.shaftCtxShaftSeq()]
          ?.data as WatchWrite<D>? ??
      (throw ('shaft data not found', shaftCtx.shaftObj.shaftActions));
}

WatchWrite<MshShaftDataMsg> shaftDefaultPersistedData({
  @ext required ShaftCtx shaftCtx,
}) {
  return shaftCtx.shaftPersistedData();
}
