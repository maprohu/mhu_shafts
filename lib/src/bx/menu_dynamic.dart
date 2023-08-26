// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/builder/shaft.dart';
// import 'package:mhu_shafts/src/builder/text.dart';
// import 'package:mhu_shafts/src/bx/menu.dart';
// import 'package:mhu_shafts/src/bx/shortcut.dart';
//
// import '../builder/sized.dart';
// import '../builder/static.dart';
// import '../op.dart';
// import '../screen/opener.dart';
// import '../sharing_box.dart';
// import '../theme.dart';
// import 'boxed.dart';
// import 'paginate.dart';
//
// part 'menu_dynamic.freezed.dart';
//
// part 'menu_dynamic.g.has.dart';
// // part 'menu_dynamic.g.compose.dart';
//
// @Has()
// @freezedStruct
// class DynamicMenuItem with _$DynamicMenuItem {
//   DynamicMenuItem._();
//
//   factory DynamicMenuItem({
//     required LabelBuilder labelBuilder,
//     required OpCallbackIndirect opCallbackIndirect,
//     @Default(OpenerState.closed) OpenerState openerState,
//   }) = _DynamicMenuItem;
//
//   static DynamicMenuItem direct({
//     required LabelBuilder labelBuilder,
//     required OpCallback opCallback,
//     OpenerState openerState = OpenerState.closed,
//   }) =>
//       DynamicMenuItem(
//         labelBuilder: labelBuilder,
//         opCallbackIndirect: () => opCallback,
//         openerState: openerState,
//       );
// }
//
// Bx dynamicMenuItemBx({
//   required DynamicMenuItem menuItem,
//   required SizedShaftBuilderBits sizedBits,
// }) {
//   final themeCalc = sizedBits.themeCalc;
//
//   final DynamicMenuItem(
//     :openerState,
//     :labelBuilder,
//     :opCallbackIndirect,
//   ) = menuItem;
//
//   return sizedBits.padding(
//     padding: themeCalc.menuItemPadding,
//     builder: (sizedBits) {
//       return sizedBits.fillRight(
//         left: sizedBits.centerHeight(
//           sizedBits.shortcutIndirect(opCallbackIndirect),
//         ),
//         right: (sizedBits) {
//           return labelBuilder(sizedBits.size);
//         },
//       );
//     },
//     backgroundColor: sizedBits.openerBackgroundColor(openerState),
//   );
// }
