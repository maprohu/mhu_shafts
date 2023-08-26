import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/bx/string.dart';
import 'package:mhu_shafts/src/bx/shortcut.dart';
import 'package:mhu_shafts/src/bx/text.dart';
import 'package:mhu_shafts/src/context/data.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'bx/boxed.dart';
import 'bx/padding.dart';


// class FontAssets {
//   final robotoMono = GoogleFonts.robotoMono();
//   final robotoSlab = GoogleFonts.robotoSlab();
// }

// class ThemeWrap {
//   static Future<void> init() async {
//     _fontAssets = FontAssets();
//     await GoogleFonts.pendingFonts();
//   }
//
//   static late final FontAssets _fontAssets;
//
//   static const _sizerKeys = 'MMM';
//   final MshThemeMsg theme;
//
//   ThemeWrap(this.theme);
//
//   late final shaftsDividerThickness = theme.dividerThicknessOpt?.shaftsOpt ?? 3;
//   late final shaftHeaderDividerThickness =
//       theme.dividerThicknessOpt?.shaftHeaderOpt ?? 2;
//   late final menuItemsDividerThickness =
//       theme.dividerThicknessOpt?.menuItems ?? 1;
//   late final paginatorFooterDividerThickness =
//       theme.dividerThicknessOpt?.paginatorFooterOpt ?? 2;
//   late final shaftSharingDividerThickness =
//       theme.dividerThicknessOpt?.shaftSharingOpt ?? 2;
//
//   late final shaftBackgroundColor = grayscale(3 / 16);
//
//   static final robotoMonoTextStyle = _fontAssets.robotoMono.copyWith(
//     fontSize: 14,
//     color: Colors.white,
//   );
//
//   static final robotoSlabTextStyle = _fontAssets.robotoSlab.copyWith(
//     fontSize: 14,
//     color: Colors.white,
//   );
//
//   late final builtinTextStyle = const TextStyle(
//     fontSize: 14,
//   );
//
//   late final defaultTextStyle = robotoMonoTextStyle;
//
//   late final shortcutTextStyle = defaultTextStyle.copyWith(
//     color: Colors.yellow,
//   );
//   late final shortcutPressedTextStyle = defaultTextStyle.copyWith(
//     color: Colors.red,
//   );
//
//   late final shaftHeaderTextStyle = defaultTextStyle;
//   late final menuItemTextStyle = defaultTextStyle;
//   late final splitMarkerTextStyle = defaultTextStyle.copyWith(
//     color: Colors.red,
//   );
//
//   late final shortcutSize = shortcutTextSpan(
//     pressed: "",
//     notPressed: _sizerKeys,
//     themeCalc: this,
//   ).size;
//
//   late final shaftHeaderTextHeight =
//       mdiTextSize("M", shaftHeaderTextStyle).height;
//
//   late final shaftHeaderContentHeight =
//       max(shaftHeaderTextHeight, shortcutSize.height);
//
//   late final shaftHeaderPadding = const EdgeInsets.all(2);
//
//   late final shaftHeaderOuterHeight =
//       shaftHeaderContentHeight + shaftHeaderPadding.vertical;
//   late final shaftHeaderWithDividerHeight =
//       shaftHeaderOuterHeight + shaftHeaderDividerThickness;
//
//   late final menuItemInnerHeight = shortcutSize.height;
//
//   late final menuItemHeight = menuItemPadding.vertical + menuItemInnerHeight;
//
//   late final menuItemPadding = const EdgeInsets.all(2);
//
//   late final stringTextStyle = MonoTextStyle.from(robotoMonoTextStyle);
//
//   late final paginatorFooterTextStyle = MonoTextStyle.from(robotoMonoTextStyle);
//
//   late final paginatorFooterInnerHeight = paginatorFooterTextStyle.height;
//   late final paginatorFooterOuterHeight =
//       paginatorFooterInnerHeight + paginatorFooterPadding.vertical;
//
//   late final paginatorFooterPadding = const EdgeInsets.all(2);
//
//   late final textCursorThickness = 2.0;
//   late final textCursorColor = Colors.red;
//   late final textClipMarkerColor = Colors.red;
//
//   late final notificationTextStyle = robotoSlabTextStyle;
//
//   static Color grayscale(double value) {
//     final rgb = (value * 255).round();
//     return Color.fromARGB(255, rgb, rgb, rgb);
//   }
//
//   late final openItemColor = grayscale(0.5);
//
//   late final longRunningTaskCompleteNotificationColor = Colors.green;
//   late final longRunningTaskCompleteIconData = Icons.notification_important;
//
//   late final Bx Function(double height) defaultSplitMarker = run(() {
//     final textSpan = splitMarkerTextStyle.span("?");
//     final size = textSpan.size;
//     final spanHeight = size.height;
//     final widget = RichText(
//       text: textSpan,
//     );
//     final child = Bx.leaf(
//       size: size,
//       widget: widget,
//     );
//
//     return (height) {
//       return Bx.pad(
//         size: size,
//         padding: Paddings.centerY(
//           outer: height,
//           inner: spanHeight,
//         ),
//         child: child,
//       );
//     };
//   });
// }

// mixin HasThemeCalc {
//   ThemeCalc get themeCalc;
// }

// extension HasThemeCalcFrX on HasThemeCalcFr {
//   ThemeWrap get themeCalc => themeCalcFr.watch();
// }
