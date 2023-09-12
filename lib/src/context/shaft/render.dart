part of '../shaft.dart';

ShaftLayout renderShaft({
  @Ext() required RectCtx rectCtx,
}) {
  final shaftObj = rectCtx.shaftObj;

  final themeWrap = rectCtx.renderObj.themeWrap;

  final optionsOpener = mshShaftOpenerOf<OptionsShaftFactory>();

  final shaftLinear = rectCtx.createColumnCtx();
  final shaftActions = shaftObj.shaftActions;

  final headerWx = shaftLinear.linearPadding(
    edgeInsets: themeWrap.shaftHeaderPaddingSizer.edgeInsets,
    builder: (paddingCtx) {
      final headerRow = paddingCtx.createRowCtx();

      return headerRow.wxLinearWidgets(widgets: [
        headerRow.textShrinkingWidget(
          textStyleWrap: themeWrap.defaultTextStyleWrap,
          text: shaftActions.callShaftLabelString(),
        ),
        headerRow.linearGrowEmpty(),
        headerRow
            .wxAim(
              watchAction: () => optionsOpener.openShaftAction(
                shaftCtx: headerRow,
              ),
            )
            .wxDecorateShaftOpener(
              shaftOpener: optionsOpener,
              shaftCtx: headerRow,
            )
            .solidWidgetWx(
              linearCtx: headerRow,
            ),
      ]).solidWidgetWx(linearCtx: paddingCtx);
    },
  );

  final wx = shaftLinear.wxLinearWidgets(widgets: [
    headerWx,
    shaftLinear.linearDivider(
      thickness: themeWrap.shaftHeaderDividerThickness,
    ),
    ...shaftActions.callShaftContent().call(shaftLinear),
  ]).wxBackgroundColor(
    color: themeWrap.shaftBackgroundColor,
  );

  // final wx = rectCtx.wxRectFillBottom(
  //   top: [
  //     headerWx,
  //     rectCtx.wxRectVerticalLayoutDivider(
  //       thickness: themeWrap.shaftHeaderDividerThickness,
  //     ),
  //   ],
  //   bottom: (rectCtx) {
  //     return wxLinearShared(
  //       size: rectCtx.size,
  //       axis: Axis.vertical,
  //       items: [
  //         ...shaftObj.shaftActions.callShaftContent().call(rectCtx),
  //       ],
  //       themeWrap: themeWrap,
  //       dividerThickness: themeWrap.shaftSharingDividerThickness,
  //     );
  //   },
  // ).wxBackgroundColor(
  //   color: themeWrap.shaftBackgroundColor,
  // );
  final shaftMsg = shaftObj.shaftMsg;
  return ShaftLayout(
    shaftSeq: shaftMsg.shaftSeq,
    shaftWidthUnits: shaftObj.visibleWidthUnits,
    wx: wx,
  );
}

// Bx shaftBx({
//   required RectCtx rectCtx,
// }) {
//   final SizedShaftBuilderBits(
//     :size,
//     :width,
//     :height,
//     :themeCalc,
//   ) = sizedBits;
//
//   final ThemeWrap(
//     :shaftHeaderDividerThickness,
//     :shaftHeaderWithDividerHeight,
//     :shaftHeaderPadding,
//     :shaftHeaderContentHeight,
//     :shaftHeaderOuterHeight,
//   ) = themeCalc;
//
//   final headerContentWidth = width - shaftHeaderPadding.horizontal;
//   final contentHeight = height - shaftHeaderWithDividerHeight;
//
//   final parts = builder(
//     sizedBits.withSize(Size(headerContentWidth, shaftHeaderContentHeight)),
//     sizedBits.withSize(Size(width, contentHeight)),
//   );
//
//   return Bx.col(
//     size: size,
//     rows: [
//       Bx.pad(
//         padding: shaftHeaderPadding,
//         child: parts.header,
//         size: size.withHeight(shaftHeaderOuterHeight),
//       ),
//       horizontalDividerBx(
//         thickness: shaftHeaderDividerThickness,
//         width: width,
//       ),
//       parts.content,
//     ],
//     backgroundColor: themeCalc.shaftBackgroundColor,
//   );
// }
//
// Bx defaultShaftBx({
//   required SizedShaftBuilderBits sizedBits,
//   Bx? headerExtra,
// }) {
//   return shaftBx(
//     sizedBits: sizedBits,
//     builder: (headerBits, contentBits) {
//       final content = contentBits.buildShaftContent(contentBits);
//       final options = contentBits.buildShaftOptions(contentBits);
//
//       final contentSharing = sharedLayoutBx(
//         size: contentBits.size,
//         axis: Axis.vertical,
//         items: [
//           ...content,
//           for (final notification in contentBits
//                   .notificationsFw()
//                   .byIndexFromLeft[
//                       contentBits.shaftCalcChain.shaftIndexFromLeft]
//                   ?.notifications ??
//               [])
//             notificationSharingBx(
//               sizedShaftBuilderBits: contentBits,
//               notificationMsg: notification,
//             ),
//           if (options.isNotEmpty) contentBits.menu(options),
//         ],
//         dividerThickness: contentBits.themeCalc.shaftSharingDividerThickness,
//       );
//
//       return ShaftParts(
//         header: headerBits.fillLeft(
//           left: (sizedBits) {
//             return sizedBits.fillLeft(
//               left: (sizedBits) => sizedBits.headerText.centerLeft(
//                 sizedBits.shaftHeaderLabel,
//               ),
//               right: headerExtra,
//             );
//           },
//           right: headerBits.centerHeight(
//             ShaftTypes.options.openerShortcut(headerBits),
//           ),
//         ),
//         content: contentSharing,
//       );
//     },
//   );
// }
