// import 'package:flutter/material.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/builder/shaft.dart';
// import 'package:mhu_shafts/src/builder/text.dart';
// import 'package:mhu_shafts/src/bx/notification.dart';
// import 'package:mhu_shafts/src/sharing_box.dart';
// import 'package:mhu_shafts/src/bx/shortcut.dart';
// import 'package:mhu_shafts/src/screen/calc.dart';
// import 'package:mhu_shafts/src/screen/opener.dart';
// import 'package:mhu_shafts/src/theme.dart';
// import 'package:mhu_shafts/src/bx/text.dart';
// import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
//
// import '../builder/sized.dart';
// import 'divider.dart';
// import 'menu.dart';
// import 'boxed.dart';
//
// part 'shaft.freezed.dart';
//
// @freezedStruct
// class ShaftParts with _$ShaftParts {
//   ShaftParts._();
//
//   factory ShaftParts({
//     required Bx header,
//     required Bx content,
//   }) = _ShaftParts;
// }
//
// typedef ShaftBuilder = ShaftParts Function(
//   SizedShaftBuilderBits headerBits,
//   SizedShaftBuilderBits contentBits,
// );
//
//
// extension ShaftSizedBitsX on SizedShaftBuilderBits {
//   Bx shaft(
//     ShaftBuilder builder,
//   ) {
//     return shaftBx(
//       sizedBits: this,
//       builder: builder,
//     );
//   }
//
//   Bx menuShaft({
//     required String label,
//     required List<MenuItem> items,
//   }) {
//     return shaft(
//       (headerBits, contentBits) {
//         final pageBx = menuSharingBx(
//           sizedBits: contentBits,
//           itemCount: items.length,
//           itemBuilder: (index, sizedBits) {
//             return menuItemBx(
//               menuItem: items[index],
//               sizedBits: sizedBits,
//             );
//           },
//         );
//
//         return ShaftParts(
//           header: headerBits.left(
//             headerBits.centerHeight(
//               textBx(
//                 text: label,
//                 style: themeCalc.shaftHeaderTextStyle,
//               ),
//             ),
//           ),
//           content: pageBx.dimensionBxBuilder(contentBits.height),
//         );
//       },
//     );
//   }
//
//   Bx header({
//     required String label,
//     VoidCallback? callback,
//   }) {
//     if (callback == null) {
//       return headerText.centerLeft(label);
//     }
//
//     return fillLeft(
//       left: (sizedBits) => sizedBits.headerText.centerLeft(label),
//       right: centerHeight(
//         shortcut(callback),
//       ),
//     );
//   }
// }

