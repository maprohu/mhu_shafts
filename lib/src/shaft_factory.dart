import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/shaft/custom.dart';
import 'package:mhu_shafts/src/shaft/error.dart';
import 'package:mhu_shafts/src/shaft/main_menu.dart';
import 'package:mhu_shafts/src/shaft/options.dart';
import 'package:mhu_shafts/src/wx/wx.dart';

import 'shaft_factory.dart' as $lib;

part 'shaft_factory.g.has.dart';

part 'shaft_factory.g.dart';

part 'shaft_factory/label.dart';

part 'shaft_factory/data.dart';

part 'shaft_factory/focus.dart';

part 'shaft_factory/menu.dart';

typedef ShaftFactoryKey = int;

@Has()
typedef ShaftHeaderLabel = WxRectBuilder;

@Has()
typedef ShaftOpenerLabel = WxRectBuilder;

@Has()
@HasDefault(shaftWithoutFocus)
typedef ShaftFocusHandler = HandlePressedKey?;

@Has()
typedef ShaftContent = BuildSharingBoxes;

@Has()
typedef ShaftInterface = dynamic;

@Compose()
abstract class ShaftLabel
    implements HasCallShaftHeaderLabel, HasCallShaftOpenerLabel {}

@Compose()
@Has()
abstract class ShaftActions
    implements
        ShaftLabel,
        HasCallShaftFocusHandler,
        HasCallShaftContent,
        HasCallShaftInterface {}

@Has()
typedef BuildShaftActions = ShaftActions Function(ShaftCtx shaftCtx);

abstract class ShaftFactory with MixSingletonKey<ShaftFactoryKey> {
  ShaftActions buildShaftActions(ShaftCtx shaftCtx);
}

typedef ShaftFactories = Singletons<ShaftFactoryKey, ShaftFactory>;

final ShaftFactories mshShaftFactories = Singletons.mixin({
  0: InvalidShaftFactory(),
  1: MainMenuShaftFactory(),
  2: OptionsShaftFactory(),
  3: CustomShaftFactory(),
});

ShaftFactoryKey getShaftFactoryKey({
  @Ext() required ShaftFactory shaftFactory,
}) {
  return shaftFactory.singletonKey;
}

ShaftFactory shaftFactoriesLookupKey({
  @ext required ShaftFactories shaftFactories,
  required ShaftFactoryKey shaftFactoryKey,
}) {
  return shaftFactories.singletonsByKey[shaftFactoryKey] ??
      shaftFactories.lookupSingletonByType<InvalidShaftFactory>();
}

F shaftFactoriesLookupType<F extends ShaftFactory>({
  @ext required ShaftFactories shaftFactories,
}) {
  return shaftFactories.lookupSingletonByType<F>();
}

ShaftFactory mshLookupKeyShaftFactory({
  required ShaftFactoryKey shaftFactoryKey,
}) {
  return mshShaftFactories.shaftFactoriesLookupKey(
    shaftFactoryKey: shaftFactoryKey,
  );
}

F mshLookupTypeShaftFactory<F extends ShaftFactory>() {
  return mshShaftFactories.shaftFactoriesLookupType<F>();
}

ShaftFactoryKey mshLookupTypeShaftFactoryKey<F extends ShaftFactory>() {
  return mshLookupTypeShaftFactory<F>().singletonKey;
}
