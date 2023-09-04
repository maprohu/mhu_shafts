import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/context/config.dart';
export 'package:mhu_shafts/src/context/config.dart';
import 'package:mhu_shafts/src/context/shaft.dart';
import 'package:mhu_shafts/src/model.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:protobuf/protobuf.dart';
export 'package:mhu_shafts/src/context/app.dart';

import 'window.dart' as $lib;

part 'window.g.dart';

part 'window.g.has.dart';

part 'window.freezed.dart';

@Has()
class WindowObj with MixDisposers, MixWindowCtx {
  late final WatchRead<Size> screenSizeWatch;

  late final renderedViewWatch = disposers.watching(
    () => windowCtx.watchWindowRenderedView(),
  );

  late final updateViewExecutor = renderedViewWatch.runPaused;

  late final Fw<BeforeAfter<ShaftsLayout>> shaftsLayoutBeforeAfterFw =
      disposers.fw(
    (
      before: renderedViewWatch.readValue().shaftsLayout,
      after: renderedViewWatch.readValue().shaftsLayout,
    ),
  );

  late final onKeyEvent = this.windowOnKeyEvent();

  // for now only one window
  late final windowStateWatchVar = windowCtx.dataObj.windowStateWatchVar;
}

@Compose()
@Has()
abstract class WindowCtx implements ConfigCtx, HasWindowObj {}

Future<WindowCtx> createWindowCtx({
  @Ext() required ConfigCtx configCtx,
  required Disposers disposers,
}) async {
  final windowObj = WindowObj()
    ..disposers = disposers
    ..screenSizeWatch =
        await ScreenSizeObserver.stream(disposers).streamWatchRead(disposers);

  final windowCtx = ComposedWindowCtx.configCtx(
    configCtx: configCtx,
    windowObj: windowObj,
  )..initMixWindowCtx(windowObj);

  windowObj.startWindowRenderStream();

  return windowCtx;
}

typedef OnKeyEvent = void Function(KeyEvent keyEvent);

@freezedStruct
class RenderedView with _$RenderedView {
  const RenderedView._();

  const factory RenderedView({
    required ShaftsLayout shaftsLayout,
    required OnKeyEvent onKeyEvent,
  }) = _RenderedView;
}

RenderedView watchWindowRenderedView({
  @Ext() required WindowCtx windowCtx,
}) {
  return windowCtx.createRenderCtx().watchRenderRenderedView();
}

void startWindowRenderStream({
  @extHas required WindowObj windowObj,
}) {
  windowObj.renderedViewWatch.distinctValues().forEach(
    (renderedView) {
      windowObj.shaftsLayoutBeforeAfterFw.value = (
        before: windowObj.shaftsLayoutBeforeAfterFw.read().after,
        after: renderedView.shaftsLayout,
      );
    },
  );
}

OnKeyEvent windowOnKeyEvent({
  @extHas required WindowObj windowObj,
}) {
  return (keyEvent) {
    windowObj.renderedViewWatch.readValue().onKeyEvent(keyEvent);
  };
}

R windowUpdateView<R>(
  @extHas WindowObj windowObj,
  R Function() action,
) {
  return windowObj.updateViewExecutor(action);
}

void windowResetView({
  @extHas required WindowObj windowObj,
}) {
  windowObj.windowUpdateView(() {
    windowObj.windowStateWatchVar.topShaft.value = createDefaultShaftMsg();
  });
}

