import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../proto.dart';
import '../wx/wx.dart';
import 'text.dart';
import 'theme.dart' as $lib;

part 'theme.g.dart';

part 'theme.g.has.dart';

part 'theme/padding.dart';

@Has()
typedef ThemeMsg = MshThemeMsg;

final mdiDefaultTheme = MshThemeMsg$.create(
  dividerThickness: MshDividerThicknessThemeMsg$.create(
    shafts: 2,
    shaftHeader: 2,
    menuItems: 1,
  ),
)..freeze();

@Has()
class ThemeWrap with MixAppCtx, MixThemeMsg {
  late final defaultPaddingThickness = 2.0;

  late final defaultPadding = EdgeInsets.all(defaultPaddingThickness);

  static const _sizerKeys = 'MMM';

  late final assetObj = appCtx.assetObj;

  late final minShaftWidthPixels = themeMsg.minShaftWidthOpt ?? 200.0;

  late final shaftsDividerThickness =
      themeMsg.dividerThicknessOpt?.shaftsOpt ?? 3;
  late final shaftHeaderDividerThickness =
      themeMsg.dividerThicknessOpt?.shaftHeaderOpt ?? 2;
  late final menuItemsDividerThickness =
      themeMsg.dividerThicknessOpt?.menuItems ?? 1;
  late final chunkedFooterDividerThickness =
      themeMsg.dividerThicknessOpt?.paginatorFooterOpt ?? 2;
  late final shaftSharingDividerThickness =
      themeMsg.dividerThicknessOpt?.shaftSharingOpt ?? 2;

  late final shaftBackgroundColor = grayscale(3 / 16);
  late final dividerColor = grayscale(5 / 16);

  late final defaultTextStyleSize = 14.0;
  late final defaultTextStyleColor = Colors.white;

  late final defaultMonoTextStyle = assetObj.robotoMonoFont
      .themeTextStyleWithDefaults(themeWrap: this)
      .wrapTextStyle()
      .createMonoTextStyle();
  late final defaultTextStyleWrap = assetObj.robotoSlabFont
      .themeTextStyleWithDefaults(themeWrap: this)
      .wrapTextStyle();

  late final aimTextStyleWrap = defaultMonoTextStyle.textStyleWrap
      .textStyleWrapWithColor(color: Colors.yellow);
  late final aimPressedTextStyleWrap = defaultMonoTextStyle.textStyleWrap
      .textStyleWrapWithColor(color: Colors.red);

  late final shaftHeaderTextStyleWrap = defaultTextStyleWrap;
  late final menuItemTextStyleWrap = defaultTextStyleWrap;
  late final textSplitMarkerColor = Colors.red;

  late final aimWxSize = aimTextSpan(
    aimState: const AimState(
      pressed: "",
      notPressed: _sizerKeys,
    ),
    themeWrap: this,
  ).size;

  late final shaftHeaderPaddingSizer =
      shaftHeaderTextStyleWrap.themeAimWithTextPaddingSizer(themeWrap: this);
  late final menuItemPaddingSizer =
      menuItemTextStyleWrap.themeAimWithTextPaddingSizer(themeWrap: this);

  late final stringMonoTextStyle = defaultMonoTextStyle;

  late final chunkedFooterTextStyleWrap = defaultTextStyleWrap;

  late final chunkedFooterPaddingSizer =
      chunkedFooterTextStyleWrap.themeAimWithTextPaddingSizer(themeWrap: this);

  late final textCursorThickness = 2.0;
  late final textCursorColor = Colors.red;
  late final textClipMarkerColor = Colors.red;

  late final notificationTextStyleWrap = defaultTextStyleWrap;

  static Color grayscale(double value) {
    final rgb = (value * 255).round();
    return Color.fromARGB(255, rgb, rgb, rgb);
  }

  late final openerIsOpenBackgroundColor = grayscale(0.5);

  late final longRunningTaskCompleteNotificationColor = Colors.green;
  late final longRunningTaskCompleteIconData = Icons.notification_important;

  late final protoFieldLabelTextStyleWrap = menuItemTextStyleWrap;
  late final protoFieldLabelHeight =
      protoFieldLabelTextStyleWrap.themeAimWithTextHeight(themeWrap: this);

  late final protoFieldValueTextStyleWrap =
      defaultTextStyleWrap.textStyleWrapWithFontSize(
    fontSize: protoFieldLabelTextStyleWrap.textStyle.fontSize! - 1,
  );

  late final protoFieldLabelValueGapHeight = 1.0;

  late final protoFieldItemInnerHeight =
      this.calculateProtoMessageFieldItemInnerHeight();

  late final protoFieldPaddingSizer =
      this.themePaddingSizer(innerHeight: protoFieldItemInnerHeight);


  late final pagerSelectedBackgroundColor = Colors.green;
  late final pagerItemPadding = defaultPadding;
  late final pagerItemTextStyleWrap = defaultTextStyleWrap;
  late final double? pagerDividerThickness = 1.0;
}

ThemeWrap createThemeWrap({
  @Ext() required AppCtx appCtx,
  required ThemeMsg themeMsg,
}) {
  final themeObj = ThemeWrap()
    ..appCtx = appCtx
    ..themeMsg = themeMsg;
  return themeObj;
}

WxHeightBuilder themeTextSplitMarkBuilder({
  @ext required ThemeWrap themeWrap,
  required TextStyle textStyle,
}) {
  final textSpan = textStyle
      .copyWith(color: themeWrap.textSplitMarkerColor)
      .createTextSpan("?");
  final size = textSpan.size;
  final widget = RichText(
    text: textSpan,
  );
  final child = createWx(
    size: size,
    widget: widget,
  );

  return (height) {
    return wxAlignAxis(
      size: size,
      wx: child,
      axis: Axis.vertical,
      axisAlignment: AxisAlignment.center,
    );
  };
}

TextStyle themeTextStyleWithDefaults({
  @ext required TextStyle textStyle,
  @ext required ThemeWrap themeWrap,
}) {
  return textStyle.copyWith(
    fontSize: themeWrap.defaultTextStyleSize,
    color: themeWrap.defaultTextStyleColor,
  );
}

double themeAimWithTextHeight({
  @ext required ThemeWrap themeWrap,
  @ext required TextStyleWrap textStyleWrap,
}) {
  return max(
    themeWrap.aimWxSize.height,
    textStyleWrap.callTextHeight(),
  );
}
