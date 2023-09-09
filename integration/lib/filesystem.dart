part of 'main.dart';

class SampleFileSystemRootShaftFactory extends SampleShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    final fileSystemShaftActions = ComposedFileSystemShaftActions(
      fileSystemPathWatchPool: fileSystemPathWatchPool,
      directoryListingWatchPool: directoryListingWatchPool,
    );
    late final FileSystemShaftEphemeralData ephemeralData =
        shaftCtx.shaftObj.ephemeralData;

    final absolutePath = AbsoluteFilePath.root;

    late final shaftInterface =
        ComposedFileSystemShaftInterface.fileSystemShaftActions(
      fileSystemShaftActions: fileSystemShaftActions,
      callFileSystemShaftEphemeralData: () => ephemeralData,
    );
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("FileSystem Root"),
      callShaftContent: () {
        return fileSystemShaftContent(
          ephemeralData: ephemeralData,
          absoluteFilePath: absolutePath,
        );
      },
      callShaftInterface: () => shaftInterface,
      callParseShaftIdentifier: keyOnlyShaftIdentifier,
      callLoadShaftEphemeralData: () {
        return (disposers) => fileSystemShaftEphemeralData(
              fileSystemShaftActions: fileSystemShaftActions,
              absoluteFilePath: absolutePath,
              disposers: disposers,
            );
      },
    );
  }
}

// @Has()
// typedef SampleDirectoryList = WatchReload<IList<FileSystemEntityNode>?>;
//
// @Has()
// typedef SampleDirectoryLookupWatch = ReadWatchValue<DirectoryNode?> Function(
//     Name name);
// @Has()
// typedef SampleFileLookupWatch = ReadWatchValue<FileNode?> Function(Name name);
//
// @Compose()
// abstract class SampleFileSystemDirectoryEphemeralData
//     implements
//         HasSampleDirectoryList,
//         HasSampleDirectoryLookupWatch,
//         HasSampleFileLookupWatch {}
//
// class SampleFileSystemRootShaftFactory extends SampleShaftFactory {
//   @override
//   ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
//     late final SampleFileSystemDirectoryEphemeralData ephemeralData =
//         shaftCtx.shaftObj.ephemeralData;
//
//     return ComposedShaftActions.shaftLabel(
//       shaftLabel: stringConstantShaftLabel("FileSystem Root"),
//       callShaftContent: () => ephemeralData.sampleDirectoryShaftContent(),
//       callShaftInterface: () => ephemeralData,
//       callParseShaftIdentifier: keyOnlyShaftIdentifier,
//       callLoadShaftEphemeralData: () {
//         return (disposers) {
//           return CancelableOperation.fromFuture(
//             fileSystemRoots(disposers),
//           )
//               .thenCancelable$(
//                 (roots) => roots.fileSystemRootsWatchReloadNodes(
//                   disposers: disposers,
//                 ),
//               )
//               .then(
//                 (nodes) => nodes.sampleFileSystemDirectoryEphemeralData(),
//               );
//         };
//       },
//     );
//   }
// }
//
// ShaftContent sampleDirectoryShaftContent({
//   @ext required SampleFileSystemDirectoryEphemeralData ephemeralData,
// }) {
//   return (rectCtx) sync* {
//     final nodes = ephemeralData.sampleDirectoryList.watchValue();
//     if (nodes == null) {
//       // TODO display missing
//       return;
//     }
//     yield rectCtx.menuRectSharingBox(
//       items: [
//         for (final node in nodes)
//           switch (node) {
//             DirectoryNode() =>
//               sampleShaftOpener<SampleFileSystemDirectoryShaftFactory>(
//                 identifierAnyData: node.fileSystemNodeShaftIdentifierData(),
//               ).shaftOpenerMenuItem(shaftCtx: rectCtx),
//             FileNode() => sampleShaftOpener<SampleFileSystemFileShaftFactory>(
//                 identifierAnyData: node.fileSystemNodeShaftIdentifierData(),
//               ).shaftOpenerMenuItem(shaftCtx: rectCtx),
//             LinkNode() => menuItemStatic(
//                 action: () {},
//                 label: node.name,
//               ),
//           },
//       ],
//     );
//   };
// }
//
// class SampleFileSystemDirectoryShaftFactory extends SampleShaftFactory {
//   @override
//   ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
//     late final String directoryName =
//         shaftCtx.shaftObj.shaftIdentifierObj.shaftIdentifierData;
//
//     late final SampleFileSystemDirectoryEphemeralData directoryEphemeralData =
//         shaftCtx.shaftCtxOnLeft().shaftCtxInterface();
//
//     late final SampleFileSystemDirectoryEphemeralData ephemeralData =
//         shaftCtx.shaftObj.ephemeralData;
//
//     return ComposedShaftActions.shaftLabel(
//       shaftLabel: stringCallShaftLabel(() => directoryName),
//       callShaftContent: () => ephemeralData.sampleDirectoryShaftContent(),
//       callShaftInterface: () => ephemeralData,
//       callParseShaftIdentifier: stringDataShaftIdentifier,
//       callLoadShaftEphemeralData: () {
//         return (disposers) {
//           final watchNode = directoryEphemeralData.sampleDirectoryLookupWatch(directoryName);
//           final initial = watchNode.readValue();
//           if (initial == null) {
//
//           } else {
//             return CancelableOperation.fromFuture(
//                 initial.listDirectoryNodes(),
//             ).then((nodes) {
//
//             });
//           }
//           return CancelableOperation.fromFuture(
//             fileSystemRoots(disposers),
//           )
//               .thenCancelable$(
//                 (roots) => roots.fileSystemRootsWatchReloadNodes(
//                   disposers: disposers,
//                 ),
//               )
//               .then(
//                 (nodes) => nodes.sampleFileSystemDirectoryEphemeralData(),
//               );
//         };
//       },
//     );
//   }
// }
//
// class SampleFileSystemFileShaftFactory extends SampleShaftFactory {
//   @override
//   ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
//     return ComposedShaftActions.shaftLabel(
//       shaftLabel: stringConstantShaftLabel("Sample File"),
//       callShaftContent: () {
//         return (rectCtx) sync* {};
//       },
//       callShaftInterface: voidShaftInterface,
//       callParseShaftIdentifier: keyOnlyShaftIdentifier,
//       callLoadShaftEphemeralData: shaftWithoutEphemeralData,
//     );
//   }
// }
//
// CmnAnyMsg fileSystemNodeShaftIdentifierData({
//   @ext required FileSystemEntityNode fileSystemEntityNode,
// }) {
//   return CmnAnyMsg()
//     ..ensureSingleValue().ensureScalarValue().stringValue =
//         fileSystemEntityNode.name
//     ..freeze();
// }
//
// SampleFileSystemDirectoryEphemeralData sampleFileSystemDirectoryEphemeralData({
//   @ext required WatchReload<IList<FileSystemEntityNode>?> watchReloadNodes,
// }) {
//   late final lookups = watching(() {
//     final dirs = <String, DirectoryNode>{};
//     final files = <String, FileNode>{};
//
//     final nodes = watchReloadNodes.watchValue();
//
//     if (nodes != null) {
//       for (final node in nodes) {
//         switch (node) {
//           case DirectoryNode():
//             dirs[node.name] = node;
//           case FileNode():
//             files[node.name] = node;
//           case LinkNode():
//             break;
//         }
//       }
//     }
//     return (
//       dirs: dirs,
//       files: files,
//     );
//   });
//
//   return ComposedSampleFileSystemDirectoryEphemeralData(
//     sampleDirectoryList: watchReloadNodes,
//     sampleDirectoryLookupWatch: (name) => lookups.mapReadWatchValue(
//       readAttribute: ComposedReadAttribute(
//         readAttribute: (ups) => ups.dirs[name],
//       ),
//     ),
//     sampleFileLookupWatch: (name) => lookups.mapReadWatchValue(
//       readAttribute: ComposedReadAttribute(
//         readAttribute: (ups) => ups.files[name],
//       ),
//     ),
//   );
// }
