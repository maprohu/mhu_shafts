import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'boxed.dart';
import 'padding.dart';

extension BxX on Bx {
  Bx centerAlongX(double width) => Bx.padOrFill(
    padding: Paddings.centerX(
      outer: width,
      inner: this.width,
    ),
    child: this,
    size: size.withWidth(width),
  );
}
