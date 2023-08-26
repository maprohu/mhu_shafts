part of 'wx.dart';

Wx wxDecoratedBox({
  @ext required Wx wx,
  required BoxDecoration boxDecoration,
}) {
  return wx.createWx(
    widget: DecoratedBox(
      decoration: boxDecoration,
      child: wx.widget,
    ),
  );
}

Wx wxBackgroundColor({
  @ext required Wx wx,
  required Color color,
}) {
  return wx.wxDecoratedBox(
    boxDecoration: BoxDecoration(
      color: color,
    ),
  );
}
