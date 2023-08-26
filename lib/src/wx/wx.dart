import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'wx.dart' as $lib;

part 'wx.freezed.dart';
part 'wx.g.has.dart';

part 'wx.g.dart';

part 'linear.dart';
part 'align.dart';
part 'fill.dart';
part 'decorate.dart';
part 'sharing.dart';
part 'divider.dart';

typedef WxHeightBuilder = Wx Function(double height);

@freezedStruct
class Wx with _$Wx implements HasSize {
  const factory Wx({
    required Widget widget,
    required Size size,
  }) = _Wx;
}

Wx createWx({
  @extHas required Widget widget,
  @extHas required Size size,
}) {
  return Wx(
    widget: widget,
    size: size,
  );
}

Wx wxSizedBox({
  @extHas required Widget widget,
  @extHas required Size size,
}) {
  return size.createWx(
    widget: SizedBox.fromSize(
      size: size,
      child: widget,
    ),
  );
}

Widget wxWidgetSizedBox({
  @ext required Wx wx,
}) {
  return SizedBox.fromSize(
    size: wx.size,
    child: wx. widget,
  );
}

Wx wxPlaceholder({
  @extHas required Size size,
}) {
  return size.wxSizedBox(
    widget: const Placeholder(),
  );
}

Wx wxEmpty({
  @extHas required Size size,
}) {
  return createWx(
    widget: SizedBox.fromSize(
      size: size,
    ),
    size: size,
  );
}
