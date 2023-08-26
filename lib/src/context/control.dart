import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';

import '../keyboard.dart';
import 'render.dart';

import 'control.dart' as $lib;

// part 'control.g.has.dart';
part 'control.g.dart';

typedef AimKeysCollection = IList<AimKeys>;

class ControlWrap {
  final IList<CharacterKey> shortcutKeys = OpShortcuts.characterShortcutKeys;

  late final shortcutKeyCount = shortcutKeys.length;

  late final List<AimKeysCollection> shortcutCollectionsCache = [
    shortcutKeys.map((e) => IList([e])).toIList(),
  ];
}

typedef ProviderAimKeysCollection = AimKeysCollection Function(int minimumSize);

ProviderAimKeysCollection controlAimKeysCollectionProvider({
  @ext required ControlWrap controlWrap,
}) {
  return (minimumSize) {
    return controlWrap.controlAimKeysCollectionOfSize(size: minimumSize);
  };
}

AimKeysCollection controlAimKeysCollectionOfSize({
  @ext required ControlWrap controlWrap,
  required int size,
}) {
  final shortcutKeys = controlWrap.shortcutKeys;
  final shortcutKeyCount = shortcutKeys.length;

  late int cacheIndex;

  if (size <= shortcutKeyCount) {
    cacheIndex = 0;
  } else {
    final shortcutKeyGrowth = shortcutKeyCount - 1;
    cacheIndex = (size - shortcutKeyGrowth) ~/ shortcutKeyGrowth + 1;
  }

  final cache = controlWrap.shortcutCollectionsCache;

  final requiredLength = cacheIndex + 1;

  while (cache.length < requiredLength) {
    final lastCollection = cache.last;
    final aimKeysToBeExtended = lastCollection.first;
    final CharacterKey lastKeyInAimKeysToBeExtended = aimKeysToBeExtended.last;

    Iterable<CharacterKey> extendingKeys() sync* {
      yield lastKeyInAimKeysToBeExtended;
      for (final key in shortcutKeys) {
        if (key != lastKeyInAimKeysToBeExtended) {
          yield key;
        }
      }
    }

    Iterable<AimKeys> newAimKeysCollection() sync* {
      yield* lastCollection.tail;

      for (final key in extendingKeys()) {
        yield aimKeysToBeExtended.add(key);
      }
    }

    cache.add(
      newAimKeysCollection().toIList(),
    );
  }

  return cache[cacheIndex];
}
