import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/widgets/busy.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

extension MshWidgetFutureStreamX<T> on Future<Stream<T>> {
  Widget futureStreamWidget(Widget Function(T value) builder) {
    return futureBuilder(
      future: this,
      busy: (context) => mdiBusyWidget,
      builder: (context, stream) {
        return streamBuilder(
          stream: stream,
          busy: (context) => mdiBusyWidget,
          builder: (context, value) {
            return builder(value);
          },
        );
      },
    );
  }
}

extension MshWidgetFutureStreamNullableX<T extends Object>
    on Future<Stream<T?>> {
  Widget futureStreamWidgetOrBusy(Widget Function(T value) builder) {
    return futureStreamWidget((value) {
      if (value == null) {
        return mdiBusyWidget;
      }
      return builder(value);
    });
  }
}

extension MsiAsyncDspFunctionX<T> on Future<T> Function(DspReg disposers) {
  Widget dspAsyncWidget(Widget Function(T value) builder) {
    return flcAsyncDisposeWidget(
      waiting: mdiBusyWidget,
      builder: (disposers) async {
        final value = await this(disposers);
        return builder(value);
      },
    );
  }
}
