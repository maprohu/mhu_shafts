import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

part 'proto_path.g.has.dart';
// part 'proto_path.g.compose.dart';

@Has()
sealed class ProtoPath {
  const ProtoPath();

  static const root = ProtoPathRoot.instance;
}

final class ProtoPathRoot extends ProtoPath {
  static const instance = ProtoPathRoot._();

  const ProtoPathRoot._();
}

@Has()
final class ProtoPathField extends ProtoPath {
  final ProtoPath parent;
  final FieldAccess fieldAccess;

  const ProtoPathField({
    required this.parent,
    required this.fieldAccess,
  });
}

final class ProtoPathMapItem extends ProtoPath {
  final ProtoPathField parent;
  final dynamic key;

  const ProtoPathMapItem({
    required this.parent,
    required this.key,
  });
}

final class ProtoPathRepeatedItem extends ProtoPath {
  final ProtoPathField parent;
  final int index;

  const ProtoPathRepeatedItem({
    required this.parent,
    required this.index,
  });
}
