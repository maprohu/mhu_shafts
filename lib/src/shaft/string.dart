// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/builder/text.dart';
// import 'package:mhu_shafts/src/bx/menu.dart';
// import 'package:mhu_shafts/src/bx/shaft.dart';
// import 'package:mhu_shafts/src/bx/string.dart';
//
// import '../builder/sized.dart';
// import '../screen/calc.dart';
// import '../bx/boxed.dart';
//
// Bx stringShaftBx({
//   required SizedShaftBuilderBits sizedBits,
//   required String label,
//   required String string,
// }) {
//   return sizedBits.shaft((headerBits, contentBits) {
//     return ShaftParts(
//       header: headerBits.headerText.centerLeft(label),
//       content: stringBx(
//         sizedBits: contentBits,
//         string: string,
//       ),
//     );
//   });
// }
//
// BuildShaftContent stringBuildShaftContent(
//   String? string, {
//   String nullLabel = "<null string>",
// }) {
//   if (string == null) {
//     return (sizedBits) {
//       return sizedBits.itemText
//           .left(nullLabel)
//           .shaftContentSharing
//           .toSingleElementIterable;
//     };
//   }
//
//   return (sizedBits) {
//     return stringVerticalSharingBx(
//       sizedBits: sizedBits,
//       string: string,
//     ).toSingleElementIterable;
//   };
// }
//
// ShaftContentBits stringEditorShaftContentBits({
//   required String stringValue,
// }) {
//   return ComposedShaftContentBits(
//     buildShaftContent: stringBuildShaftContent(stringValue),
//     buildShaftOptions: (shaftBits) => [
//       MenuItem(
//         label: "Paste from Clipboard",
//         callback: () {},
//       ),
//     ],
//   );
// }
