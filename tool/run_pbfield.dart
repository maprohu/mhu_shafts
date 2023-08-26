import 'package:mhu_shafts/src/generated/mhu_shafts.pblib.dart';
import 'package:mhu_dart_pbgen/mhu_dart_pbgen.dart';

void main() async {
  await runPbFieldGenerator(
    lib: mhuShaftsLib,
  );
}
