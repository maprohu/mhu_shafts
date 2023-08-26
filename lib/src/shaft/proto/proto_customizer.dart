import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/bx/menu.dart';
import 'package:mhu_shafts/src/proto.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

import '../../builder/shaft.dart';

part 'proto_customizer.g.dart';

part 'proto_customizer.g.has.dart';

@Customizer()
typedef MapEntryFeature<O> = O Function<K, V>(
  MapFieldAccess<Msg, K, V> mapFieldAccess,
  MapEntry<K, V> mapEntry,
);

@Customizer()
typedef MapKeyFeature = K? Function<K, V>(
  MapFieldAccess<Msg, K, V> mapFieldAccess,
);

@Customizer()
typedef MessageValueFeature<O> = O Function<M extends Msg>(
  M instance,
  MessageEditingBits<M> messageEditingBits,
);

@Customizer()
typedef MapFieldOptionsFeature = List<MenuItem>? Function<K, V>(
  MapFieldAccess<Msg, K, V> mapFieldAccess,
  MapEditingBits<K, V> mapEditingBits,
  ShaftBuilderBits shaftBuilderBits,
);

@Has()
class ProtoCustomizer {
  late final mapEntryLabel = MapEntryFeatureCustomizer<String>(
    <K, V>(mapFieldAccess, mapEntry) => mapEntry.key.toString(),
  );

  late final mapDefaultKey = MapKeyFeatureCustomizer(
    <K, V>(mapFieldAccess) => null,
  );

  late final mapFieldOptions = MapFieldOptionsFeatureCustomizer(
    <K, V>(mapFieldAccess, mapEditingBits, shaftBuilderBits) => null,
  );

  late final mapEntryExtraContent =
      MapEntryFeatureCustomizer<BuildShaftContent>(
    <K, V>(mapFieldAccess, mapEntry) => empty1,
  );

  late final messageEditOptions =
      MessageValueFeatureCustomizer<BuildShaftOptions?>(
    <M extends Msg>(instance, messageEditingBits) => null,
  );
}

// void _setup(ProtoCustomizer cst) {
//   cst.mapEntryLabel.put(
//     MshConfigMsg$.dartPackages,
//     (MapEntry<int, MshDartPackageMsg> input) => input.value.path,
//   );
// }
//
// void _use(ProtoCustomizer cst) {
//   final mapEntry = MapEntry(
//     1,
//     MshDartPackageMsg()
//       ..path = "some/path"
//       ..freeze(),
//   );
//   String label = cst.mapEntryLabel(
//     MshConfigMsg$.dartPackages,
//     mapEntry,
//   );
// }
