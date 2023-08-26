import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:protobuf/protobuf.dart';

extension NotificationHasShaftCalcChainX on HasShaftCalcChain {
  void showNotification(String message) {
    showNotifications(message.toSingleElementIterable);
  }

  void showNotifications(Iterable<String> messages) {
    shaftCalcChain.notificationsFw.rebuild((notifications) {
      final shaftIndexFromLeft = shaftCalcChain.shaftIndexFromLeft;

      final selfNotifications =
          notifications.byIndexFromLeft[shaftIndexFromLeft] ??
              MshShaftNotificationMsg.getDefault();

      notifications.byIndexFromLeft[shaftIndexFromLeft] =
          selfNotifications.rebuild((selfNotifications) {
        for (final message in messages) {
          selfNotifications.notifications
              .add(MshNotificationMsg()..text = message);
        }
      });
    });
  }
}
