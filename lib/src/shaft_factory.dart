import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/shaft/custom.dart';
import 'package:mhu_shafts/src/shaft/error.dart';
import 'package:mhu_shafts/src/shaft/main_menu.dart';
import 'package:mhu_shafts/src/shaft/options.dart';
import 'package:mhu_shafts/src/wx/wx.dart';
import 'package:protobuf/protobuf.dart';

import 'shaft_factory.dart' as $lib;

part 'shaft_factory.g.has.dart';

part 'shaft_factory.g.dart';

part 'shaft_factory.freezed.dart';

part 'shaft_factory/label.dart';

part 'shaft_factory/data.dart';

part 'shaft_factory/focus.dart';

part 'shaft_factory/menu.dart';

part 'shaft_factory/identifier.dart';
part 'shaft_factory/todo.dart';


typedef ShaftFactoryKey = int;

@Has()
typedef ShaftHeaderLabel = WxRectBuilder;

@Has()
typedef ShaftOpenerLabel = WxRectBuilder;

@Has()
typedef ShaftFocusHandler = HandlePressedKey?;

@Has()
typedef ShaftContent = BuildSharingBoxes;

@Has()
typedef ShaftInterface = dynamic;

@freezed
class ShaftIdentifierObj<T> with _$ShaftIdentifierObj<T> {
  const factory ShaftIdentifierObj({
    required ShaftFactoryKey shaftFactoryKey,
    required T shaftIdentifierData,
  }) = _ShaftIdentifierObj;
}

@Has()
typedef ParseShaftIdentifier<T> = ShaftIdentifierObj<T> Function(
  MshShaftIdentifierMsg shaftIdentifierMsg,
);

@Compose()
abstract class ShaftLabel
    implements HasCallShaftHeaderLabel, HasCallShaftOpenerLabel {}

@Compose()
abstract class ShaftDirectFocusContentActions
    implements HasShaftFocusHandler, HasShaftContent {}

@Compose()
abstract class ShaftDirectContentActions
    implements ShaftDirectFocusContentActions, HasShaftInterface {}

@Compose()
abstract class ShaftContentActions
    implements
        HasCallShaftFocusHandler,
        HasCallShaftContent,
        HasCallShaftInterface {}

@Compose()
@Has()
abstract class ShaftActions
    implements ShaftLabel, ShaftContentActions, HasCallParseShaftIdentifier {}

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
  100: ProtoFieldShaftFactory(),
});

late final mshCustomShaftFactoryKey = mshShaftFactories
    .lookupSingletonByType<CustomShaftFactory>()
    .getShaftFactoryKey();

ShaftActions mshCustomShaftActions({
  @ext required ShaftActions shaftActions,
}) {
  return shaftActions.shaftActionsWithCallParseShaftIdentifier(
    lazy(() {
      return (shaftIdentifierMsg) {
        return ShaftIdentifierObj(
          shaftFactoryKey: mshCustomShaftFactoryKey,
          shaftIdentifierData: shaftActions.callParseShaftIdentifier().call(
                shaftIdentifierMsg.innerShaftIdentifierMsg(),
              ),
        );
      };
    }),
  );
}

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

ShaftInterface shaftCtxInterface({
  @extHas required ShaftObj shaftObj,
}) {
  return shaftObj.shaftActions.callShaftInterface();
}

ShaftContentActions callContentActions({
  required Call<ShaftDirectContentActions> call,
}) {
  late final contentActions = call();

  return ComposedShaftContentActions(
    callShaftFocusHandler: () => contentActions.shaftFocusHandler,
    callShaftContent: () => contentActions.shaftContent,
    callShaftInterface: () => contentActions.shaftInterface,
  );
}
