part of '../persist.dart';

@collection
final class MshShaftPersistedDataRecord with BlobRecord, IsarIdRecordMixin {
  static final collectionBits =
      MshShaftPersistedDataRecord.new.isarIdCollectionBits();
}

ShaftPersistedRecord createShaftPersistedRecord<D>({
  @extHas required PersistObj persistObj,
  required ShaftPersistedDataActions persistedDataActions,
  required ShaftSeq shaftSeq,
}) {
  return persistedDataActions.typeGenericFunction(<D extends Object>() {
    persistedDataActions as ShaftPersistedDataActions<D>;

    final recordCtx = MshShaftPersistedDataRecord.collectionBits
        .isarCollectionCtx(isar: persistObj.isar)
        .isarRecordCtx(
          isarId: shaftSeq.toInt(),
        );

    final disposers = DspImpl();

    final lift = persistedDataActions.shaftPersistedDataLift;

    final recordLift =
        recordCtx.isarBlobCollectionBytesLift().liftComposition(higher: lift);

    final initialValue = persistedDataActions.initShaftPersistedData();

    final watch = watchVar(initialValue).isarWatchWritePutLatest(
      recordCtx: recordCtx,
      lower: recordLift.lower,
      putFirst: true,
      disposers: disposers,
    );

    return (
      disposers: disposers,
      data: watch,
    );
  });
}

Future<ShaftPersistedRecord> loadShaftPersistedRecord({
  @extHas required PersistObj persistObj,
  required ShaftPersistedDataActions persistedDataActions,
  required ShaftSeq shaftSeq,
}) async {
  return persistedDataActions.typeGenericFunction(<D extends Object>() async {
    persistedDataActions as ShaftPersistedDataActions<D>;
    final recordCtx = MshShaftPersistedDataRecord.collectionBits
        .isarCollectionCtx(isar: persistObj.isar)
        .isarRecordCtx(
          isarId: shaftSeq.toInt(),
        );

    var initialRecord = await recordCtx.loadIsarRecordCtx();

    final bytesLift = recordCtx.isarBlobCollectionBytesLift();

    final recordLift = bytesLift.liftComposition(
      higher: persistedDataActions.shaftPersistedDataLift,
    );
    if (initialRecord == null) {
      logger.w((
        'shaft persisted data not found',
        shaftSeq,
        D,
      ));

      initialRecord =
          persistedDataActions.initShaftPersistedData().let(recordLift.lower);
    }

    final disposers = DspImpl();

    final initialValue = recordLift.higher(initialRecord!);

    final watch = watchVar(initialValue).isarWatchWritePutLatest(
      recordCtx: recordCtx,
      lower: recordLift.lower,
      putFirst: false,
      disposers: disposers,
    );

    return (
      disposers: disposers,
      data: watch,
    );
  });
}
