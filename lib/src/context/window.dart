import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_shafts/proto.dart';
export 'package:mhu_shafts/src/context/config.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/model.dart';
export 'package:mhu_shafts/src/context/app.dart';

import 'window.dart' as $lib;

part 'window.g.dart';

part 'window.g.has.dart';

part 'window.freezed.dart';

part 'window/persist.dart';

typedef ShaftElementId = ({
  ShaftSeq shaftSeq,
  dynamic elementId,
});

typedef FocusedShaftElement = ({
  HandlePressedKey handlePressedKey,
  ShaftElementId shaftElementId,
});

typedef ShaftEphemeralRecord = DisposableRecord<ShaftEphemeralData>;
typedef ShaftPersistedRecord<D> = DisposableRecord<WatchWrite<D>>;

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

  final focusedShaftVar = watchVar<FocusedShaftElement?>(null);

  final shaftEphemeralStore = <ShaftSeq, ShaftEphemeralRecord>{};

  final shaftPersistedStore = <ShaftSeq, ShaftPersistedRecord>{};
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

  final loaders = await DspReg.perform((disposers) {
    return disposers
        .watching(
          () => run(() sync* {
            final shafts = windowCtx
                .createRenderCtx()
                .renderObj
                .shaftOnRightEnd
                .shaftCtxLeftIterable();
            // .toList()
            // .reversed;

            for (final shaftCtx in shafts) {
              final shaftActions = shaftCtx.shaftObj.shaftActions;
              final loadEphemeral = shaftActions.callLoadShaftEphemeralData();

              late final shaftSeq = shaftCtx.shaftCtxShaftSeq();
              if (loadEphemeral != null) {
                final disposers = DspImpl();
                final loading = loadEphemeral(disposers).value;
                yield () async {
                  windowObj.shaftEphemeralStore[shaftSeq] = (
                    disposers: disposers,
                    data: await loading,
                  );
                };
              }

              final persistence = shaftActions.callShaftDataPersistence();

              if (persistence != null) {
                yield () async {
                  windowObj.shaftPersistedStore[shaftSeq] =
                      await configCtx.loadShaftPersistedRecord(
                    shaftSeq: shaftSeq,
                    persistedDataActions: persistence,
                  );
                };
              }
            }
          }).toList(),
        )
        .readValue();
  });

  await Future.wait(
    loaders.map((fn) => fn()),
  );
  // for (final loader in loaders) {
  //   await loader();
  // }

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

@Has()
@Compose()
typedef ReleaseFocus = VoidCallback;

HasReleaseFocus shaftCtxRequestWindowFocus({
  @ext required ShaftCtx shaftCtx,
  required dynamic elementId,
  required void Function(
    PressedKey pressedKey,
    ReleaseFocus release,
  ) handlePressedKey,
}) {
  final focusedShaftVar = shaftCtx.windowObj.focusedShaftVar;

  assert(
    focusedShaftVar.readValue() == null,
    'window already focused',
  );

  late final ReleaseFocus releaseFocus;

  final FocusedShaftElement focusedShaft = (
    handlePressedKey: (pressedKey) {
      handlePressedKey(
        pressedKey,
        releaseFocus,
      );
    },
    shaftElementId: shaftCtx.shaftCtxElementId(
      elementId: elementId,
    ),
  );

  focusedShaftVar.value = focusedShaft;

  return ComposedReleaseFocus(
    releaseFocus: releaseFocus = () {
      assert(
        focusedShaftVar.readValue() == focusedShaft,
        'window focus mismatch',
      );

      focusedShaftVar.value = null;
    },
  );
}

ShaftElementId shaftCtxElementId({
  @ext required ShaftCtx shaftCtx,
  required dynamic elementId,
}) {
  return (
    shaftSeq: shaftCtx.shaftCtxShaftSeq(),
    elementId: elementId,
  );
}
