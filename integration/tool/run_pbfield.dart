import 'package:mhu_dart_pbgen/mhu_dart_pbgen.dart';
import 'package:mhu_shafts_example/src/generated/mhu_shafts_example.pblib.dart';

void main() async {
  await runPbFieldGenerator(
    lib: mhuShaftsExampleLib,
  );
}
