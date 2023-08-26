part of '../text.dart';

@Has()
typedef ColumnCount = int;
@Has()
typedef RowCount = int;

@Compose()
abstract class GridSize implements HasColumnCount, HasRowCount {}

@Compose()
abstract class MonoTextStyle implements HasSize, HasTextStyle {
  static const _calcCount = 10000;

  static MonoTextStyle from(TextStyle textStyle) => ComposedMonoTextStyle(
    size: mdiTextSize(
      Iterable.generate(
        _calcCount,
            (_) => "M",
      ).join(),
      textStyle,
    ).let((s) {
      return Size(s.width / _calcCount, s.height);
    }),
    textStyle: textStyle,
  );
}
