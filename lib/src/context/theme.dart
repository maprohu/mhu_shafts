import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_shafts/src/bx/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../proto.dart';
import '../wx/wx.dart';
import 'text.dart';
import 'theme.dart' as $lib;

part 'theme.g.dart';

part 'theme.g.has.dart';


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

  late final robotoMonoTextStyle = assetObj.robotoMonoFont.copyWith(
    fontSize: 14,
    color: Colors.white,
  );

  late final robotoSlabTextStyle = assetObj.robotoSlabFont.copyWith(
    fontSize: 14,
    color: Colors.white,
  );

  late final builtinTextStyle = const TextStyle(
    fontSize: 14,
  );

  late final defaultTextStyle = robotoMonoTextStyle;

  late final aimTextStyle = defaultTextStyle.copyWith(
    color: Colors.yellow,
  );
  late final aimPressedTextStyle = defaultTextStyle.copyWith(
    color: Colors.red,
  );

  late final shaftHeaderTextStyle = defaultTextStyle;
  late final menuItemTextStyle = defaultTextStyle;
  late final splitMarkerTextStyle = defaultTextStyle.copyWith(
    color: Colors.red,
  );

  late final aimWxSize = aimTextSpan(
    aimState: const AimState(
      pressed: "",
      notPressed: _sizerKeys,
    ),
    themeWrap: this,
  ).size;

  late final shaftHeaderTextHeight =
      mdiTextSize("M", shaftHeaderTextStyle).height;

  late final shaftHeaderContentHeight =
      max(shaftHeaderTextHeight, aimWxSize.height);

  late final shaftHeaderPadding = defaultPadding;

  late final shaftHeaderOuterHeight =
      shaftHeaderContentHeight + shaftHeaderPadding.vertical;
  late final shaftHeaderWithDividerHeight =
      shaftHeaderOuterHeight + shaftHeaderDividerThickness;

  late final menuItemInnerHeight = aimWxSize.height;

  late final menuItemHeight = menuItemPadding.vertical + menuItemInnerHeight;

  late final menuItemPadding = defaultPadding;

  late final stringTextStyle = MonoTextStyle.from(robotoMonoTextStyle);

  late final chunkedFooterTextStyle = MonoTextStyle.from(robotoMonoTextStyle);

  late final chunkedFooterInnerHeight = chunkedFooterTextStyle.height;
  late final chunkedFooterOuterHeight =
      chunkedFooterInnerHeight + chunkedFooterPadding.vertical;

  late final chunkedFooterPadding = const EdgeInsets.all(2);

  late final textCursorThickness = 2.0;
  late final textCursorColor = Colors.red;
  late final textClipMarkerColor = Colors.red;

  late final notificationTextStyle = robotoSlabTextStyle;

  static Color grayscale(double value) {
    final rgb = (value * 255).round();
    return Color.fromARGB(255, rgb, rgb, rgb);
  }

  late final openerIsOpenBackgroundColor = grayscale(0.5);

  late final longRunningTaskCompleteNotificationColor = Colors.green;
  late final longRunningTaskCompleteIconData = Icons.notification_important;

  late final textSplitMarker = this.themeTextSplitMarkBuilder();

  late final protoFieldLabelTextStyleWrap = menuItemTextStyle.textStyleWrap();
  late final protoFieldValueTextStyleWrap = robotoSlabTextStyle
      .copyWith(
        fontSize:
            protoFieldLabelTextStyleWrap.textStyle.fontSize?.let((e) => e - 1),
      )
      .textStyleWrap();
  late final protoFieldLabelValueGapHeight = 1.0;

  late final protoFieldItemInnerHeight =
      this.calculateProtoMessageFieldItemInnerHeight();

  late final protoFieldItemInnerSize = Size(0, protoFieldItemInnerHeight);

  late final protoFieldItemPadding = defaultPadding;

  late final protoFieldItemOuterSize =
      protoFieldItemPadding.inflateSize(protoFieldItemInnerSize);

  late final protoFieldItemOuterHeight = protoFieldItemOuterSize.height;
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
}) {
  final textSpan = themeWrap.splitMarkerTextStyle.createTextSpan("?");
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
