part of '../persist.dart';

typedef ChunkedContentKey = int;
@Has()
typedef PageNumber = int;
@Has()
typedef PageNumberVar = WatchWrite<PageNumber>;

typedef DataPackageId = int;

const DataPackageId mshDataPackageId = 0;

@Has()
typedef PagerKey = ({
  DataPackageId packageId,
  ChunkedContentKey contentKey,
});

final anyPagerKeyLift = anyRepeatedInt32Lift.liftComposition<PagerKey>(
  higher: ComposedLift(
    higher: (low) {
      final [packageId, contentKey] = low;
      return (
        packageId: packageId,
        contentKey: contentKey,
      );
    },
    lower: (high) => [
      high.packageId,
      high.contentKey,
    ],
  ),
);

final mshChunkedSingletons = Singletons.mixin<int, ChunkedContentMarker>({
  0: SingleChunkedContent(),
});

abstract class ChunkedContentMarker with MixSingletonKey<int> {}

class SingleChunkedContent extends ChunkedContentMarker {}

ChunkedContentKey mshChunkedContentKeyOf<T extends ChunkedContentMarker>() {
  assert(T != ChunkedContentMarker);

  return mshChunkedSingletons.lookupSingletonByType<T>().singletonKey;
}

PagerBits mshChunkedContentPagePagerBitsOf<T extends ChunkedContentMarker>({
  @ext required ShaftCtx shaftCtx,
}) {
  assert(T != ChunkedContentMarker);

  final key = mshChunkedContentKeyOf<T>();

  final PagerKey pagerKey = (
    packageId: mshDataPackageId,
    contentKey: key,
  );

  final pageNumberVar = shaftPageNumberVar(
    shaftCtx: shaftCtx,
    pagerKey: pagerKey,
  );

  final pageCountMap = shaftCtx.shaftObj.pageCountMap;
  return ComposedPagerBits(
    pageCountVar: ComposedReadWriteValue(
      readValue: () {
        // assert(pageCountMap.containsKey(pagerKey), pagerKey);
        return pageCountMap[pagerKey];
      },
      writeValue: (value) {
        assert(!pageCountMap.containsKey(pagerKey), pagerKey);
        pageCountMap[pagerKey] = value;
      },
    ),
    pageNumberVar: pageNumberVar,
    pagerKey: pagerKey,
  );
}

PagerBits singleChunkedContentPagerBits({
  @ext required ShaftCtx shaftCtx,
}) {
  return shaftCtx.mshChunkedContentPagePagerBitsOf<SingleChunkedContent>();
}

PageNumberVar shaftPageNumberVar({
  @ext required ShaftCtx shaftCtx,
  required PagerKey pagerKey,
}) {
  final dataVar = shaftCtx.shaftDefaultPersistedData();

  final dataUpdate = dataVar.watchWriteMsgDeepUpdate();
  return ComposedWatchWrite.watchRead(
    watchRead: dataVar.mapWatchReadFn$(
      (data) =>
          data.packages[pagerKey.packageId]?.chunkPages[pagerKey.contentKey] ??
          0,
    ),
    writeValue: (pageNumber) {
      dataUpdate.updateValue(
        (data) {
          data.packages
              .putIfAbsent(
                pagerKey.packageId,
                MshShaftPackageDataMsg.create,
              )
              .chunkPages[pagerKey.contentKey] = pageNumber;
        },
      );
    },
  );
}
