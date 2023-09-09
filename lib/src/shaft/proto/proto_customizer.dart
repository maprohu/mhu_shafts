import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_pbschema/mhu_dart_pbschema.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_shafts/src/proto.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:protobuf/protobuf.dart';

part 'proto_customizer.g.dart';

part 'proto_customizer.g.has.dart';

@Customizer()
typedef LogicalFieldFeature<O> = O Function<M extends Msg>(
  LogicalFieldMarker<M> logicalFieldMarker,
  ProtoMessageShaftInterface<M> shaftInterface,
);

// @Customizer()
// typedef MapKeyFeature = K? Function<K, V>(
//   MapFieldAccess<Msg, K, V> mapFieldAccess,
// );
//
// @Customizer()
// typedef MessageValueFeature<O> = O Function<M extends Msg>(
//   M instance,
//   MessageEditingBits<M> messageEditingBits,
// );
//
// @Customizer()
// typedef MapFieldOptionsFeature = List<MenuItem>? Function<K, V>(
//   MapFieldAccess<Msg, K, V> mapFieldAccess,
//   MapEditingBits<K, V> mapEditingBits,
//   ShaftBuilderBits shaftBuilderBits,
// );

@Has()
class ProtoCustomizer {
  late final logicalFieldVisible = LogicalFieldFeatureCustomizer<bool>(
    <M extends Msg>(logicalFieldMarker, shaftInterface) => true,
  );

// late final mapEntryLabel = MapEntryFeatureCustomizer<String>(
//   <K, V>(mapFieldAccess, mapEntry) => mapEntry.key.toString(),
// );
//
// late final mapDefaultKey = MapKeyFeatureCustomizer(
//   <K, V>(mapFieldAccess) => null,
// );
//
// late final mapFieldOptions = MapFieldOptionsFeatureCustomizer(
//   <K, V>(mapFieldAccess, mapEditingBits, shaftBuilderBits) => null,
// );
//
// late final mapEntryExtraContent =
//     MapEntryFeatureCustomizer<BuildShaftContent>(
//   <K, V>(mapFieldAccess, mapEntry) => empty1,
// );
//
// late final messageEditOptions =
//     MessageValueFeatureCustomizer<BuildShaftOptions?>(
//   <M extends Msg>(instance, messageEditingBits) => null,
// );
}
