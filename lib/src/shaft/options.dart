import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/shaft/main_menu.dart';

import '../shaft_factory.dart';

class OptionsShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Options"),
      callShaftContent: () {
        final closeAction = shaftCtx.shaftObj.shaftOnLeft?.shaftCloseAction();
        return (rectCtx) sync* {
          yield rectCtx.menuRectSharingBox(
            items: [
              shaftCtx.mshShaftOpenerMenuItem<MainMenuShaftFactory>(),
              if (closeAction != null)
                menuItemStatic(
                  action: closeAction,
                  label: "Close Shaft",
                ),
            ],
            pageNumber: shaftCtx.singleChunkedContentPageNumber(),
          );
        };
      },
      callShaftInterface: voidShaftInterface,
      callParseShaftIdentifier: keyOnlyShaftIdentifier,
      callLoadShaftEphemeralData: shaftWithoutEphemeralData,
      callShaftDataPersistence: shaftWithDefaultPersistence,
    );
  }
}
