// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/builder/shaft.dart';
// import 'package:mhu_shafts/src/bx/boxed.dart';
// import 'package:mhu_shafts/src/bx/text.dart';
// import 'package:mhu_shafts/src/theme.dart';
// import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
//
// import '../builder/sized.dart';
// import '../sharing_box.dart';
//
// part 'string.g.has.dart';
//
// part 'string.g.compose.dart';
//
//
// SharingBox stringVerticalSharingBx({
//   required SizedShaftBuilderBits sizedBits,
//   required String string,
// }) {
//   return ComposedSharingBox(
//     intrinsicDimension:
//         sizedBits.themeCalc.stringTextStyle.calculateIntrinsicHeight(
//       stringLength: string.length,
//       width: sizedBits.width,
//     ),
//     dimensionBxBuilder: (dimension) {
//       return stringBx(
//         sizedBits: sizedBits.withHeight(dimension),
//         string: string,
//       );
//     },
//   );
// }
//
// Bx stringBx({
//   required SizedShaftBuilderBits sizedBits,
//   required String string,
// }) {
//   final style = sizedBits.themeCalc.stringTextStyle;
//
//   final GridSize(
//     columnCount: fitWidth,
//     rowCount: fitHeight,
//   ) = style.maxGridSize(sizedBits.size);
//
//   final lines =
//       string.slices(fitWidth).take(fitHeight).toList().orIfEmpty(const [""]);
//
//   final lineSize = Size(
//     style.width * fitWidth,
//     style.height,
//   );
//
//   final lineBits = sizedBits.withSize(lineSize);
//
//   final linesSize = Size(
//     style.width * fitWidth,
//     style.height * lines.length,
//   );
//
//   final linesCol = Bx.col(
//     rows: lines.map(
//       (line) {
//         final lineSpan = style.span(line);
//         return lineBits.leaf(
//           RichText(
//             text: lineSpan,
//             softWrap: false,
//           ),
//         );
//       },
//     ).toList(),
//     size: linesSize,
//   );
//
//   return sizedBits.topLeft(linesCol);
// }
//
// abstract class HasTextStyle {
//   TextStyle get textStyle;
// }
//
// extension StringHasTextStyleX on HasTextStyle {
//   TextSpan span(String text) => textStyle.span(text);
// }
//
// extension StringTextStyleX on TextStyle {
//   TextSpan span(String text) => TextSpan(
//         text: text,
//         style: this,
//       );
// }
//
// extension MonoTextStyleX on MonoTextStyle {
//   int maxColumnCount(double width) => width ~/ this.width;
//
//   int maxRowCount(double height) => height ~/ this.height;
//
//   GridSize maxGridSize(Size size) {
//     return ComposedGridSize(
//       columnCount: maxColumnCount(size.width),
//       rowCount: maxRowCount(size.height),
//     );
//   }
//
//   double calculateIntrinsicHeight({
//     required int stringLength,
//     required width,
//   }) {
//     final columnCount = maxColumnCount(width);
//
//     final intrinsicRowCount = (stringLength - 1) ~/ columnCount + 1;
//
//     return height * intrinsicRowCount;
//   }
// }
//
// extension GridSizeX on GridSize {
//   int get cellCount => columnCount * rowCount;
//
//   Size sizeFrom({
//     required Size cellSize,
//   }) =>
//       Size(
//         cellSize.width * columnCount,
//         cellSize.height * rowCount,
//       );
// }
//
// Widget stringLinesWidget({
//   required Iterable<String> lines,
//   required ThemeWrap themeCalc,
//   required bool isClipped,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: lines.mapIndexed(
//       (index, line) {
//         final textSpan = isClipped && index == 0
//             ? TextSpan(
//                 children: [
//                   themeCalc.stringTextStyle.textStyle
//                       .apply(color: themeCalc.textClipMarkerColor)
//                       .span("<"),
//                   themeCalc.stringTextStyle.span(line.substring(1)),
//                 ],
//               )
//             : themeCalc.stringTextStyle.span(line);
//
//         return RichText(
//           text: textSpan,
//           softWrap: false,
//         );
//       },
//     ).toList(),
//   );
// }
