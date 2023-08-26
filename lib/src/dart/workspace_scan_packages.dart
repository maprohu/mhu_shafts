import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/app.dart';
import 'package:mhu_shafts/src/context/data.dart';
import 'package:mhu_shafts/src/op.dart';
import 'package:mhu_shafts/src/screen/calc.dart';

part 'workspace_scan_packages.g.has.dart';
part 'workspace_scan_packages.g.compose.dart';

@Has()
@Compose()
abstract class DartWorkspaceScanPackagesShaftRight {}

@Compose()
abstract class DartWorkspaceScanPackagesShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class DartWorkspaceScanPackagesShaft
    implements
        ShaftCalcBuildBits,
        DartWorkspaceScanPackagesShaftMerge,
        DartWorkspaceScanPackagesShaftRight,
        ShaftCalc {
  static DartWorkspaceScanPackagesShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {

    final shaftRight = ComposedDartWorkspaceScanPackagesShaftRight();
    final shaftMerge = ComposedDartWorkspaceScanPackagesShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        throw "todo";
      },
    );

    return ComposedDartWorkspaceScanPackagesShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      dartWorkspaceScanPackagesShaftMerge: shaftMerge,
      dartWorkspaceScanPackagesShaftRight: shaftRight,
    );
  }
}
