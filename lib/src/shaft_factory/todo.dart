part of '../shaft_factory.dart';

ShaftDirectContentActions todoShaftDirectContentActions({
  required Object message,
  StackTrace? stackTrace,
}) {
  logger.w(
    message,
    stackTrace: stackTrace ?? StackTrace.current,
  );
  return ComposedShaftDirectContentActions(
    shaftContent: message.toString().constantStringTextShaftContent(),
    shaftInterface: voidShaftInterface,
  );
}
