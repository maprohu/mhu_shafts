part of 'wx.dart';

@Has()
typedef CheckWxSizing = Call<bool>;

@Has()
typedef RunSizing = Execute;

@Compose()
@Has()
abstract class WxSizer implements HasRunSizing, HasCheckWxSizing {}

WxSizer createWxSizer() {
  bool sizing = false;

  return ComposedWxSizer(
    checkWxSizing: () => sizing,
    runSizing: <R>(action) {
      if (sizing) {
        return action();
      } else {
        sizing = true;
        try {
          return action();
        } finally {
          sizing = false;
        }
      }
    },
  );
}

