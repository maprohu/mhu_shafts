import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_shafts/src/bx/menu.dart';
import 'package:mhu_shafts/src/screen/opener.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';
import '../../../builder/sized.dart';
import '../../../proto.dart';
import 'package:mhu_shafts/src/screen/calc.dart';


// part 'message.g.has.dart';
part 'message.g.compose.dart';

@Compose()
abstract class MessageContent implements ShaftContentBits {
  static MessageContent create<M extends GeneratedMessage>({
    required MessageEditingBits<M> messageEditingBits,
    BuildShaftContent extraContent = emptyContent,
  }) {
    assert(M != GeneratedMessage);

    late final messageCalc = messageEditingBits.messageDataType.pbiMessageCalc;
    return ComposedMessageContent(
      buildShaftContent: (SizedShaftBuilderBits sizedBits) {
        return [
          sizedBits.menu(
            messageCalc.topFieldKeys.map((fieldKey) {
              switch (fieldKey) {
                case ConcreteFieldKey():
                  return ShaftTypes.concreteField.opener(
                    sizedBits,
                    shaftKey: (key) => key.tagNumber = fieldKey.tagNumber,
                  );
                case OneofFieldKey():
                  return ShaftTypes.oneofField.opener(
                    sizedBits,
                    shaftKey: (key) => key.oneofIndex = fieldKey.oneofIndex,
                  );
              }
            }).toList(),
          ),
          ...extraContent(sizedBits),
        ];
      },
    );
  }
}
