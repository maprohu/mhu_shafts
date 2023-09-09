import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/io.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_dart_model/proto.dart';
import 'package:mhu_shafts/mhu_shafts.dart';

import 'io.dart' as $lib;
part 'io.g.has.dart';
part 'io.g.dart';

part 'filesystem.dart';

part 'io.freezed.dart';

final initializeIoShaftFactories = once(() {
  ioShaftActions = buildIoShaftActions;
});

final ShaftFactories ioShaftFactories = Singletons.mixin({
  0: FileSystemShaftFactory(),
});

abstract class IoShaftFactoryMarker extends ShaftFactory {}

ShaftActions buildIoShaftActions(ShaftCtx shaftCtx) {
  final shaftIdentifier = shaftCtx.shaftObj.shaftIdentifier;

  return ioShaftFactories
      .shaftFactoriesLookupKey(
        shaftFactoryKey: shaftIdentifier.shaftFactoryKeyPath[1],
      )
      .buildShaftActions(shaftCtx);
}

ShaftOpener ioShaftOpener<F extends IoShaftFactoryMarker>({
  CmnAnyMsg? identifierAnyData,
}) {
  assert(F != IoShaftFactory);
  return ioShaftFactories
      .factoriesShaftOpenerOf<F>(
        identifierAnyData: identifierAnyData,
      )
      .mshIoShaftOpener();
}
