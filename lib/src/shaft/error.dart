import 'package:mhu_dart_commons/commons.dart';

import '../context/shaft.dart';
import '../shaft_factory.dart';

// // part 'error.g.has.dart';
//
// ShaftCalc notImplementedShaftCalc({
//   required ShaftCalcBuildBits shaftCalcBuildBits,
//   required String message,
//   StackTrace? stackTrace,
// }) {
//   if (stackTrace == null) {
//     MhuLogger.cut1.e(
//       message,
//       message,
//       StackTrace.current,
//     );
//   } else {
//     logger.e(
//       message,
//       message,
//       stackTrace,
//     );
//   }
//
//   return ComposedShaftCalc.shaftCalcBuildBits(
//     shaftCalcBuildBits: shaftCalcBuildBits,
//     shaftHeaderLabel: "<not implemented>",
//     buildShaftContent: stringBuildShaftContent(message),
//   );
// }

class InvalidShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) => ComposedShaftActions.shaftLabel(
        shaftLabel: staticShaftLabel("Invalid"),
        callShaftContent: () => (rectCtx) => [],
        callShaftFocusHandler: shaftWithoutFocus,
        callShaftInterface: voidShaftInterface,
      );
}
