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

  final dataVar = shaftCtx.shaftDefaultPersistedData();

  final dataUpdate = dataVar.watchWriteMsgDeepUpdate();

  final PageNumberVar pageNumberVar = ComposedWatchWrite.watchRead(
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

  final PagerKey pagerKey = (
    packageId: mshDataPackageId,
    contentKey: key,
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
