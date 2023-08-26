import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/app.dart';
import 'package:mhu_shafts/src/context/data.dart';
import 'package:mhu_shafts/src/op.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:mhu_shafts/src/shaft/proto/content/value_browsing.dart';
import 'package:mhu_shafts/src/shaft/proto/proto_path.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

import '../../long_running.dart';
import '../../proto.dart';

part 'concrete_field.g.has.dart';

part 'concrete_field.g.compose.dart';

@Has()
@Compose()
abstract class ConcreteFieldShaftRight implements HasEditingBits {}

@Compose()
abstract class ConcreteFieldShaft
    implements
        ShaftCalcBuildBits,
        ShaftContentBits,
        ConcreteFieldShaftRight,
        ShaftCalc {
  static ConcreteFieldShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final left = shaftCalcBuildBits.leftCalc as HasEditingBits;
    final messageEditingBits = left.editingBits as MessageEditingBits;
    final tagNumber =
        shaftCalcBuildBits.shaftMsg.shaftIdentifier.concreteField.tagNumber;
    final messageType =
        messageEditingBits.messageDataType.pbiMessage.messageType;

    final fieldKey = ConcreteFieldKey(
      messageType: messageType,
      tagNumber: tagNumber,
    );

    final messageProtoPath = messageEditingBits.protoPath;

    return fieldKey.concreteFieldCalc.concreteFieldCalcGeneric(
      <M extends GeneratedMessage, F>(concreteFieldCalc) {
        messageEditingBits as MessageEditingBits<M>;

        final protoPathField = ProtoPathField(
          parent: messageProtoPath,
          fieldAccess: concreteFieldCalc.fieldAccess,
        );

        final browsingContent = ValueBrowsingContent.concreteField(
          dataType: concreteFieldCalc.dataType,
          messageUpdateBits: messageEditingBits.messageDataType.pbiMessageCalc,
          fieldCoordinates: concreteFieldCalc,
          messageValue: messageEditingBits,
          protoCustomizer: messageEditingBits.protoCustomizer,
          protoPathField: protoPathField,
        );

        final shaftRight = ComposedConcreteFieldShaftRight(
          editingBits: browsingContent.editingBits,
        );

        return ComposedConcreteFieldShaft.merge$(
          shaftCalcBuildBits: shaftCalcBuildBits,
          shaftHeaderLabel: concreteFieldCalc.protoName,
          concreteFieldShaftRight: shaftRight,
          shaftContentBits: browsingContent,
        );
      },
    );
  }
}
