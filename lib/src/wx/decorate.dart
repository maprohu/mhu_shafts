part of 'wx.dart';

typedef WidgetDecorator = Widget Function(Widget child);

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

WidgetDecorator boxDecorator({
  @ext required BoxDecoration decoration,
}) {
  return (child) {
    return DecoratedBox(
      decoration: decoration,
      child: child,
    );
  };
}

WidgetDecorator backgroundColorDecorator({
  @ext required Color backgroundColor,
}) {
  return boxDecorator(
    decoration: BoxDecoration(
      color: backgroundColor,
    ),
  );
}
