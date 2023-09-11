part of 'wx.dart';

Wx wxPadding({
  @ext required Wx wx,
  @ext required EdgeInsets edgeInsets,
}) {
  return Padding(
    padding: edgeInsets,
    child: wx.widget,
  ).createWx(
    size: edgeInsets.inflateSize(wx.size),
  );
}
