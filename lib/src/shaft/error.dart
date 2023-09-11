import 'package:mhu_dart_commons/commons.dart';

import '../context/shaft.dart';
import '../shaft_factory.dart';

class InvalidShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) =>
      ComposedShaftActions.shaftLabel(
        shaftLabel: stringConstantShaftLabel("Invalid"),
        callShaftContent: () => (rectCtx) => [],
        callShaftInterface: voidShaftInterface,
        callParseShaftIdentifier: keyOnlyShaftIdentifier,
        callLoadShaftEphemeralData: shaftWithoutEphemeralData,
        callShaftDataPersistence: shaftWithoutDataPersistence,
      );
}
