// import 'package:flutter/cupertino.dart';
// import 'package:mhu_shafts/src/builder/shaft.dart';
// import 'package:mhu_shafts/src/builder/sized.dart';
// import 'package:mhu_shafts/src/sharing_box.dart';
// import 'package:mhu_shafts/src/bx/string.dart';
// import 'package:mhu_shafts/src/bx/text.dart';
// import 'package:mhu_shafts/src/theme.dart';
// import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
//
// import '../../proto.dart';
// import 'boxed.dart';
//
// SharingBox notificationSharingBx({
//   required SizedShaftBuilderBits sizedShaftBuilderBits,
//   required MshNotificationMsg notificationMsg,
// }) {
//   final textStyle = sizedShaftBuilderBits.themeCalc.notificationTextStyle;
//   final message = notificationMsg.text;
//
//   final textSpan = textStyle.span(message);
//   final intrinsicTextSize = textSpan.wrapSize(sizedShaftBuilderBits.width);
//
//   return ComposedSharingBox(
//     intrinsicDimension: intrinsicTextSize.height,
//     dimensionBxBuilder: (height) {
//       final size = sizedShaftBuilderBits.size.withHeight(height);
//
//       return Bx.leaf(
//         size: size,
//         widget: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxWidth: size.width,
//             maxHeight: size.height,
//           ),
//           child: RichText(
//             text: textSpan,
//             overflow: TextOverflow.fade,
//           ),
//         ),
//       );
//     },
//   );
// }
