import 'dart:convert';

import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_dart_pbschema/mhu_dart_pbschema.dart';
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

part 'shaft_factory/ephemeral.dart';

part 'shaft_factory/persist.dart';

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

@Has()
typedef ShaftEphemeralData = dynamic;

@Has()
typedef LoadShaftEphemeralData = CancelableOperation<ShaftEphemeralData>
    Function(
  DspReg disposers,
)?;

@freezed
class ShaftIdentifierObj<T> with _$ShaftIdentifierObj<T> {
  const factory ShaftIdentifierObj({
    required IList<ShaftFactoryKey> shaftFactoryKeyPath,
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
    implements
        // HasShaftFocusHandler,
        HasLoadShaftEphemeralData,
        HasShaftContent {}

@Compose()
abstract class ShaftDirectContentActions
    implements
        ShaftDirectFocusContentActions,
        HasShaftInterface,
        HasShaftDataPersistence {}

@Compose()
abstract class ShaftContentActions
    implements
        HasCallShaftDataPersistence,
        HasCallLoadShaftEphemeralData,
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
  4: IoShaftFactory(),
  5: PagerShaftFactory(),
  100: ProtoFieldShaftFactory(),
});

late final mshCustomShaftFactoryKey = mshShaftFactories
    .lookupSingletonByType<CustomShaftFactory>()
    .getShaftFactoryKey();

// ShaftActions mshCustomShaftActions({
//   @ext required ShaftActions shaftActions,
// }) {
//   return shaftActions.shaftActionsWithCallParseShaftIdentifier(
//     lazy(() {
//       return (shaftIdentifierMsg) {
//         return ShaftIdentifierObj(
//           shaftFactoryKey: mshCustomShaftFactoryKey,
//           shaftIdentifierData: shaftActions.callParseShaftIdentifier().call(
//                 shaftIdentifierMsg.innerShaftIdentifierMsg(),
//               ),
//         );
//       };
//     }),
//   );
// }

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
    callShaftContent: () => contentActions.shaftContent,
    callShaftInterface: () => contentActions.shaftInterface,
    callLoadShaftEphemeralData: () => contentActions.loadShaftEphemeralData,
    callShaftDataPersistence: () => contentActions.shaftDataPersistence,
  );
}

typedef ShaftIdentifierLift<T> = AnyMsgLift<T>;
