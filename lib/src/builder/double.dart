import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';

import '../screen/calc.dart';

part 'double.g.has.dart';

part 'double.g.dart';

@Has()
typedef ShaftDoubleChainRight = ShaftDoubleChain?;

@Compose()
@Has()
abstract base class ShaftDoubleChain
    implements HasShaftCalcChain, HasShaftDoubleChainRight {
  late final shaftDoubleChainLeft = shaftCalcChain.shaftCalcChainLeft?.let(
    (shaftCalcChainLeft) => ComposedShaftDoubleChain(
      shaftDoubleChainRight: this,
      shaftCalcChain: shaftCalcChainLeft,
    ),
  );

  Iterable<ShaftDoubleChain> get iterableRight =>
      finiteIterable((item) => shaftDoubleChainRight);

  Iterable<ShaftDoubleChain> get iterableLeft =>
      finiteIterable((item) {
        return item.shaftDoubleChainLeft;
      });

  late int widthOnRight = shaftDoubleChainRight?.widthTillRightEnd ?? 0;

  late int widthTillRightEnd =
      widthOnRight + shaftCalcChain.shaftWidth;
}

