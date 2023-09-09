import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/context/text.dart';
import 'package:mhu_shafts/src/screen/opener.dart';
import 'package:mhu_shafts/src/shaft/main_menu.dart';
import 'package:mhu_shafts/src/wx/wx.dart';

import '../shaft_factory.dart';

class OptionsShaftFactory extends ShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("Options"),
      callShaftContent: shaftMenuContent((shaftCtx) {
        final closeAction = shaftCtx.shaftObj.shaftOnLeft?.shaftCloseAction();
        return [
          shaftCtx.mshShaftOpenerMenuItem<MainMenuShaftFactory>(),
          if (closeAction != null)
            menuItemStatic(
              action: closeAction,
              label: "Close Shaft",
            ),
        ];
      }),
      callShaftInterface: voidShaftInterface,
      callParseShaftIdentifier: keyOnlyShaftIdentifier,
      callLoadShaftEphemeralData: shaftWithoutEphemeralData,
    );
  }
}
