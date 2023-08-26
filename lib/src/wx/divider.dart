part of 'wx.dart';

Wx wxDivider({
  required Size rectSize,
  required Axis layoutAxis,
  required double thickness,
  required ThemeWrap themeWrap,
}) {
  final size = rectSize.sizeWithAxisDimension(
    axis: layoutAxis,
    dimension: thickness,
  );
  return createWx(
    widget: SizedBox.fromSize(
      size: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: themeWrap.dividerColor,
        ),
      ),
    ),
    size: size,
  );
}

