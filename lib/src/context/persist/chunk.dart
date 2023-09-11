part of '../persist.dart';

typedef ChunkedContentKey = int;
typedef PageNumber = int;
typedef PageNumberVar = WatchWrite<PageNumber>;

const mshDataPackageId = 0;

final mshChunkedSingletons = Singletons.mixin<int, ChunkedContentMarker>({
  0: SingleChunkedContent(),
});

abstract class ChunkedContentMarker with MixSingletonKey<int> {}

class SingleChunkedContent extends ChunkedContentMarker {}

ChunkedContentKey mshChunkedContentKeyOf<T extends ChunkedContentMarker>() {
  assert(T != ChunkedContentMarker);

  return mshChunkedSingletons.lookupSingletonByType<T>().singletonKey;
}

WatchWrite<PageNumber>
    chunkedContentPageNumberVarOf<T extends ChunkedContentMarker>({
  @ext required ShaftCtx shaftCtx,
}) {
  assert(T != ChunkedContentMarker);

  final key = mshChunkedContentKeyOf<T>();

  final dataVar = shaftCtx.shaftDefaultPersistedData();

  final dataUpdate = dataVar.watchWriteMsgDeepUpdate();

  return ComposedWatchWrite.watchRead(
    watchRead: dataVar.mapWatchReadFn$(
      (data) => data.packages[mshDataPackageId]?.chunkPages[key] ?? 0,
    ),
    writeValue: (pageNumber) {
      dataUpdate.updateValue(
        (data) {
          data.packages
              .putIfAbsent(
                mshDataPackageId,
                MshShaftPackageDataMsg.create,
              )
              .chunkPages[key] = pageNumber;
        },
      );
    },
  );
}

WatchWrite<PageNumber> singleChunkedContentPageNumberVar({
  @ext required ShaftCtx shaftCtx,
}) {
  return shaftCtx.chunkedContentPageNumberVarOf<SingleChunkedContent>();
}

PageNumber singleChunkedContentPageNumber({
  @ext required ShaftCtx shaftCtx,
}) {
  return shaftCtx.singleChunkedContentPageNumberVar().watchValue();
}
