import 'package:mhu_dart_model/proto.dart';
import 'package:mhu_dart_pbgen/mhu_dart_pbgen.dart';

Future<void> main() async {
  await runPbSchemaGenerator(
    dependencies: [
      mhuDartModelPbschema,
    ]
  );
}
