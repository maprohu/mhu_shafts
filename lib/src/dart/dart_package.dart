import 'dart:io';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/data.dart';
import 'package:mhu_shafts/src/dart/workspace.dart';
import 'package:mhu_shafts/src/long_running.dart';
import 'package:path/path.dart' as p;

import 'dart_package.dart' as $lib;

part 'dart_package.g.dart';

part 'dart_package.g.has.dart';

part 'dart_package.g.compose.dart';

const packageYamlName = "package.yaml";

@Has()
typedef ScanForWorkspaceDartPackagesLookup
    = Map<WorkspaceIdentifier, LongRunningTaskIdentifier>;

Stream<String> scanForDartPackages({
  required String directoryPath,
}) async* {
  final skip = <Directory>{};

  Stream<String> scan(Directory directory) async* {
    final currentPath = directory.path;
    directory = directory.absolute;
    if (!skip.add(directory)) {
      return;
    }

    await for (final entity in directory.list()) {
      switch (entity) {
        case File(:final path):
          if (p.basename(path) == packageYamlName) {
            yield currentPath;
          }
        case Directory(:final path):
          final baseName = p.basename(path);
          if (!baseName.startsWith('.')) {
            yield* scan(entity);
          }
      }
    }
  }

  yield* scan(
    Directory(directoryPath),
  );
}

abstract class DartPackages
    implements DartPackagesBits, HasLongRunningTasksController, HasConfigFw {}

@Compose()
abstract class DartPackagesBits
    implements HasScanForWorkspaceDartPackagesLookup {
  static DartPackagesBits create() {
    return ComposedDartPackagesBits(
      scanForWorkspaceDartPackagesLookup: {},
    );
  }
}

LongRunningTaskIdentifier ensureScanWorkspaceForDartPackages({
  @Ext() required DartPackages dartPackages,
  required WorkspaceIdentifier workspaceIdentifier,
}) {
  final running =
      dartPackages.scanForWorkspaceDartPackagesLookup[workspaceIdentifier];
  if (running != null) {
    return running;
  }

  final workspaceFr =
      dartPackages.configFw.map((t) => t.workspaces[workspaceIdentifier]);
  final path = workspaceFr.read()!.path;

  String watchName() => workspaceFr()?.name ?? "<missing>";

  final task = dartPackages.longRunningTasksController
      .addLongRunningTask((taskIdentifier) {
    final future = scanForDartPackages(directoryPath: path).toList();
    return LongRunningTaskBuildBits.create(
      future: future,
      taskIdentifier: taskIdentifier,
      longTermBusy: ComposedLongTermBusy(
        buildShaftContent: (sizedBits) => [],
        watchLabel: () {
          return "Scanning for Dart Packages: ${watchName()}";
        },
      ),
      longTermComplete: ComposedLongTermComplete<List<String>>(
        buildLongTermCompleteView: (sizedShaftBuilderBits, value) {
          return [];
        },
        watchLongTermCompleteLabel: (value) {
          return "Finished Scanning for Dart Packages: ${watchName()}";
        },
      ),
    );
  });

  return task.longRunningTaskIdentifier;
}
