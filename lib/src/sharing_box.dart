// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/bx/padding.dart';
// import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
//
// import 'bx/boxed.dart';
// import 'bx/divider.dart';
//
// part 'sharing_box.g.has.dart';
//
// part 'sharing_box.g.compose.dart';
//
// @Has()
// typedef IntrinsicDimension = double;
//
// @Has()
// typedef DimensionBxBuilder = Bx Function(double dimension);
//
// @Compose()
// abstract class SharingBox
//     implements HasIntrinsicDimension, HasDimensionBxBuilder {
//   static SharingBox fixed({
//     required Bx bx,
//     required Axis axis,
//   }) {
//     final intrinsicDimension = bx.size.axis(axis);
//     return ComposedSharingBox(
//       intrinsicDimension: bx.size.axis(axis),
//       dimensionBxBuilder: (dimension) {
//         return Bx.padOrFill(
//           padding: Paddings.start(
//             axis: axis,
//             outer: dimension,
//             inner: intrinsicDimension,
//           ),
//           child: bx,
//           size: bx.size.withAxisDimension(
//             axis: axis,
//             dimension: dimension,
//           ),
//         );
//       },
//     );
//   }
//
//   static SharingBox fixedVertical(Bx bx) => fixed(
//         bx: bx,
//         axis: Axis.vertical,
//       );
//
//   static SharingBox empty({
//     required Axis layoutAxis,
//     required double crossAxisDimension,
//   }) {
//     return ComposedSharingBox(
//       intrinsicDimension: 0,
//       dimensionBxBuilder: (dimension) {
//         return Bx.fill(
//           Size.zero
//               .withAxisDimension(
//                 axis: layoutAxis,
//                 dimension: dimension,
//               )
//               .withAxisDimension(
//                 axis: layoutAxis.flip,
//                 dimension: crossAxisDimension,
//               ),
//         );
//       },
//     );
//   }
// }
//
// @Has()
// typedef Index = int;
//
// @Has()
// typedef Dimension = double;
//
// @Compose()
// abstract class SharingSize implements HasIndex, HasIntrinsicDimension {}
//
// @Compose()
// abstract class SharedSize implements HasIndex, HasDimension {}
//
// Map<int, double> distributeSharedSpace({
//   required double space,
//   required List<SharingSize> items,
// }) {
//   final itemCount = items.length;
//
//   final quota = space / itemCount;
//
//   final (positive: overQuota, negative: withinQuota) =
//       items.partition((item) => item.intrinsicDimension > quota);
//
//   if (withinQuota.isEmpty) {
//     return {
//       for (final item in overQuota) item.index: quota,
//     };
//   }
//
//   final withinQuotaTotal =
//       withinQuota.sumByDouble((item) => item.intrinsicDimension);
//
//   final overQuotaSpace = space - withinQuotaTotal;
//
//   return {
//     ...distributeSharedSpace(
//       space: overQuotaSpace,
//       items: overQuota,
//     ),
//     for (final item in withinQuota) item.index: item.intrinsicDimension,
//   };
// }
//
// Bx sharedLayoutBx({
//   required Size size,
//   required Axis axis,
//   required Iterable<SharingBox> items,
//   double? dividerThickness,
// }) {
//   final itemList = items.toList();
//
//   if (itemList.isEmpty) {
//     return Bx.fill(size);
//   }
//
//   final itemCount = itemList.length;
//
//   final totalDividerThickness =
//       dividerThickness == null ? 0 : ((itemCount - 1) * dividerThickness);
//
//   final availableSpace = size.axis(axis) - totalDividerThickness;
//
//   Iterable<Bx> Function(Iterable<Bx> items) addDividers =
//       dividerThickness != null
//           ? (items) {
//               return items.separatedBy(
//                 dividerByLayoutAxis(
//                   axis: axis,
//                   thickness: dividerThickness,
//                   crossAxisSize: size.axis(axis.flip),
//                 ),
//               );
//             }
//           : identity;
//
//   final intrinsicDimensionTotal =
//       items.sumByDouble((item) => item.intrinsicDimension);
//
//   Bx linear(Iterable<Bx> items) {
//     return Bx.linear(
//       axis: axis,
//       items: items.toList(),
//       size: size,
//     );
//   }
//
//   if (intrinsicDimensionTotal <= availableSpace) {
//     final fill = availableSpace - intrinsicDimensionTotal;
//
//     return [
//       ...items
//           .map(
//             (e) => e.dimensionBxBuilder(e.intrinsicDimension),
//           )
//           .let(addDividers),
//       if (fill > 0)
//         Bx.fill(
//           size.withAxisDimension(
//             axis: axis,
//             dimension: fill,
//           ),
//         ),
//     ].let(linear);
//   } else {
//     final sharedSizes = distributeSharedSpace(
//       space: availableSpace,
//       items: items
//           .mapIndexed(
//             (index, item) => ComposedSharingSize(
//               index: index,
//               intrinsicDimension: item.intrinsicDimension,
//             ),
//           )
//           .toList(),
//     );
//
//     return itemList
//         .mapIndexed(
//           (index, element) => element.dimensionBxBuilder(
//             sharedSizes[index]!,
//           ),
//         )
//         .let(addDividers)
//         .let(linear);
//   }
// }
//
// typedef SharingBoxes = Iterable<SharingBox>;
