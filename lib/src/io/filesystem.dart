part of 'io.dart';

class FileSystemShaftFactory extends IoShaftFactoryMarker {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    late final FileSystemShaftEphemeralData ephemeralData =
        shaftCtx.shaftObj.ephemeralData;

    late final List<String> shaftIdentifierObj =
        shaftCtx.shaftObj.shaftIdentifierObj.shaftIdentifierData;

    late final absolutePath = AbsoluteFilePath(
      filePath: shaftIdentifierObj.toIList(),
    );

    late final FileSystemShaftInterface leftShaftInterface =
        shaftCtx.shaftCtxOnLeft().shaftCtxInterface();

    late final shaftInterface =
        ComposedFileSystemShaftInterface.fileSystemShaftActions(
      fileSystemShaftActions: leftShaftInterface,
      callFileSystemShaftEphemeralData: () => ephemeralData,
    );

    String labelString() {
      final leftState =
          leftShaftInterface.callFileSystemShaftEphemeralData().watchValue();
      final name = absolutePath.filePath.last;

      if (leftState case FileSystemShaftDirectory()) {
        final entry = leftState.listing.directoryListingFindEntry$(name);
        if (entry != null && entry.type == DirectoryEntryType.directory) {
          return "$name/";
        }
      }

      return name;
    }

    return ComposedShaftActions(
      callShaftLabelString: labelString,
      // callShaftHeaderLabel: stringShaftHeaderLabel(
      //   () {
      //     final state = ephemeralData.watchValue();
      //     final name = absolutePath.filePath.last;
      //
      //     switch (state) {
      //       case FileSystemShaftDirectory():
      //         return "$name/";
      //       default:
      //         return name;
      //     }
      //   },
      // ),
      // callShaftOpenerLabel: stringShaftOpenerLabel(labelString),
      callShaftContent: () {
        return fileSystemShaftContent(
          ephemeralData: ephemeralData,
          absoluteFilePath: absolutePath,
        );
      },
      callShaftInterface: () => shaftInterface,
      callParseShaftIdentifier: repeatedStringDataShaftIdentifier,
      callLoadShaftEphemeralData: () {
        return (disposers) {
          return fileSystemShaftEphemeralData(
            fileSystemShaftActions: shaftInterface,
            absoluteFilePath: absolutePath,
            disposers: disposers,
          );
        };
      },
      callShaftDataPersistence: shaftWithDefaultPersistence,
    );
  }
}

@Compose()
@Has()
abstract class FileSystemShaftActions
    implements HasFileSystemPathWatchPool, HasDirectoryListingWatchPool {}

@Compose()
abstract class FileSystemShaftInterface
    implements FileSystemShaftActions, HasCallFileSystemShaftEphemeralData {}

@Compose()
@Has()
abstract class FileSystemShaftEphemeralData
    implements WatchReloadSync<FileSystemShaftState> {}

CancelableOperation<FileSystemShaftEphemeralData> fileSystemShaftEphemeralData({
  required FileSystemShaftActions fileSystemShaftActions,
  required AbsoluteFilePath absoluteFilePath,
  required DspReg disposers,
}) {
  return CancelableOperation.fromFuture(
    Future(() async {
      final path = await fileSystemShaftActions.fileSystemPathWatchPool.acquire(
        absoluteFilePath,
        disposers,
      );
      final listing =
          await fileSystemShaftActions.directoryListingWatchPool.acquire(
        absoluteFilePath,
        disposers,
      );

      final state = disposers.watching(() {
        final listingValue = listing.watchValue();

        if (listingValue != null) {
          return FileSystemShaftDirectory(listing: listingValue);
        } else {
          final pathValue = path.watchValue();

          switch (pathValue) {
            case DirectoryEntryType.file:
              return FileSystemShaftState.file;
            default:
              return FileSystemShaftState.invalid;
          }
        }
      });

      return ComposedFileSystemShaftEphemeralData.watchReloadSync(
        watchReloadSync: watchReloadSync(
          readWatchValue: state,
          createDirtyChecker: equalsDirtyChecker,
        ),
      );
    }),
  );
}

ShaftContent fileSystemShaftContent({
  required FileSystemShaftEphemeralData ephemeralData,
  required AbsoluteFilePath absoluteFilePath,
}) {
  return (rectCtx) sync* {
    final state = ephemeralData.watchValue();

    // TODO reload

    switch (state) {
      case FileSystemShaftInvalid():
        yield rectCtx.rectMonoTextSharingBox$("Invalid.");

      case FileSystemShaftFile():
        // TODO
        yield rectCtx.rectMonoTextSharingBox$("File.");

      case FileSystemShaftDirectory():
        yield rectCtx.menuRectSharingBox(
          pageCountCallback: (_) {}, // TODO
          pageNumber: rectCtx.singleChunkedContentPageNumber(),
          items: state.listing.entries.map((entry) {
            final itemPath = absoluteFilePath.absolutePathChild$(entry.name);
            return ioShaftOpener<FileSystemShaftFactory>(
              identifierAnyData: fileSystemShaftIdentifierLift.lower(itemPath),
            ).shaftOpenerMenuItem(shaftCtx: rectCtx);
          }).toList(),
        );
    }
  };
}

sealed class FileSystemShaftState {
  const FileSystemShaftState();

  static const invalid = const FileSystemShaftInvalid._();
  static const file = const FileSystemShaftFile._();
}

class FileSystemShaftFile extends FileSystemShaftState {
  const FileSystemShaftFile._();
}

class FileSystemShaftInvalid extends FileSystemShaftState {
  const FileSystemShaftInvalid._();
}

@freezed
class FileSystemShaftDirectory
    with _$FileSystemShaftDirectory
    implements FileSystemShaftState {
  const factory FileSystemShaftDirectory({
    required DirectoryListing listing,
  }) = _FileSystemShaftDirectory;
}

typedef FileSystemShaftIdentifierObj = AbsoluteFilePath;

typedef FileSystemShaftIdentifierLift
    = ShaftIdentifierLift<FileSystemShaftIdentifierObj>;

final FileSystemShaftIdentifierLift fileSystemShaftIdentifierLift =
    ComposedLift(
  higher: (low) => AbsoluteFilePath(
    filePath: low.repeatedStringValue.stringValues.toIList(),
  ),
  lower: (high) => CmnAnyMsg()
    ..ensureRepeatedStringValue().stringValues.addAll(high.filePath)
    ..freeze(),
);
