// import 'package:collection/collection.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/builder/sized.dart';
// import 'package:mhu_shafts/src/builder/text.dart';
// import 'package:mhu_shafts/src/bx/menu.dart';
// import 'package:mhu_shafts/src/proto.dart';
// import 'package:mhu_shafts/src/screen/opener.dart';
//
// import '../screen/calc.dart';
// import '../sharing_box.dart';
//
// SharingBoxes browseMapSharingBoxes<K, V>({
//   required SizedShaftBuilderBits sizedShaftBuilderBits,
//   required MapEditingBits<K, V> mapEditingBits,
// }) {
//   final MapEditingBits(
//     :mapDataType,
//   ) = mapEditingBits;
//   final value = mapEditingBits.watchValue();
//
//   if (value == null) {
//     return sizedShaftBuilderBits.itemText
//         .left("<missing item>")
//         .shaftContentSharing
//         .toSingleElementIterable;
//   }
//
//   if (value.isEmpty) {
//     return sizedShaftBuilderBits.itemText
//         .left("<empty map>")
//         .shaftContentSharing
//         .toSingleElementIterable;
//   }
//
//   final sorted = value.entries.sortedByCompare(
//     (e) => e.key,
//     mapDataType.mapKeyDataType.mapKeyComparator,
//   );
//
//   return [
//     sizedShaftBuilderBits.menu(
//       sorted.map(
//         (entry) {
//           return sizedShaftBuilderBits.opener(
//             ShaftIdentifiers.mapEntry(
//               mapKeyDataType: mapDataType.mapKeyDataType,
//               key: entry.key,
//             ),
//           );
//         },
//       ).toList(),
//     ),
//   ];
// }
