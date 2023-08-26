// import 'package:flutter/material.dart';
// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_shafts/src/bx/menu.dart';
// import 'package:mhu_shafts/src/keyboard.dart';
// import 'package:mhu_shafts/src/op.dart';
// import 'package:mhu_shafts/src/screen/opener.dart';
// import 'package:mhu_shafts/src/theme.dart';
// import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
//
// import '../builder/shaft.dart';
// import 'boxed.dart';
//
// part 'shortcut.g.has.dart';
// // part 'shortcut.g.compose.dart';
//
// @Has()
// typedef ShortcutCallback = VoidCallback;
//
//
// Widget shortcutWidget({
//   required ShortcutData data,
//   required ThemeWrap themeCalc,
// }) {
//   final ShortcutData(
//     :shortcut,
//     :pressedCount,
//   ) = data;
//   String str(Iterable<CharacterShortcutKey> sc) =>
//       sc.map((e) => e.character).join();
//   return RichText(
//     textAlign: TextAlign.center,
//     softWrap: false,
//     overflow: TextOverflow.visible,
//     maxLines: 1,
//     text: shortcutTextSpan(
//       pressed: str(shortcut.take(pressedCount)),
//       notPressed: str(shortcut.skip(pressedCount)),
//       themeCalc: themeCalc,
//     ),
//   );
// }
//
// Bx shortcutBx({
//   required ShortcutData? data,
//   required ThemeWrap themeCalc,
// }) {
//   Widget? child;
//
//   if (data != null) {
//     child = shortcutWidget(
//       data: data,
//       themeCalc: themeCalc,
//     );
//   }
//
//   final size = themeCalc.shortcutSize;
//
//   return Bx.leaf(
//     size: size,
//     widget: child,
//   );
// }
//
// extension NodeBuildBitxX on ShaftBuilderBits {
//   Bx openerShortcutFromBits(
//     OpenerBits openerBits,
//   ) {
//     return shortcut(
//       openerBits.shortcutCallback,
//       backgroundColor: openerBackgroundColor(openerBits.openerState),
//     );
//   }
//
//   Bx shortcut(
//     VoidCallback callback, {
//     Color? backgroundColor,
//   }) {
//     return shortcutRegistered(
//       handle: opBuilder.register(callback),
//       backgroundColor: backgroundColor,
//     );
//   }
//
//   Bx shortcutIndirect(
//     OpCallbackIndirect callback, {
//     Color? backgroundColor,
//   }) {
//     return shortcutRegistered(
//       handle: opBuilder.registerIndirect(callback),
//       backgroundColor: backgroundColor,
//     );
//   }
//
//   Bx shortcutRegistered({
//     required OpBuildHandle handle,
//     Color? backgroundColor,
//   }) {
//     return Bx.leaf(
//       size: themeCalc.shortcutSize,
//       widget: flcFrr(() {
//         ShortcutData? data;
//         final pressedCount = handle.watchState();
//         if (pressedCount != null) {
//           data = ShortcutData(
//             shortcut: handle.shortcut(),
//             pressedCount: pressedCount,
//           );
//         }
//         return shortcutBx(
//           data: data,
//           themeCalc: themeCalc,
//         ).layout();
//       }),
//       backgroundColor: backgroundColor,
//     );
//   }
// }
