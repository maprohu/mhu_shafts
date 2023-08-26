part of '../render.dart';

const defaultAimState = 0;

typedef AimKeys = IList<CharacterKey>;

final emptyAimKeys = AimKeys();

typedef AimAction = ReadValue<VoidCallback?>;

@Has()
typedef WatchAimAction = WatchValue<VoidCallback?>;

@Has()
typedef ReadAimKeys = ReadValue<AimKeys>;

@Has()
typedef WatchAimState = WatchValue<AimState?>;

@Compose()
abstract class RegisteredAim implements HasReadAimKeys, HasWatchAimState {}

@Has()
typedef RegisterAim = RegisteredAim Function(AimAction aimAction);

typedef HandlePressedKey = void Function(PressedKey pressedKey);

@Compose()
@Has()
abstract class AimRegistry implements HasRegisterAim {}

final RegisteredAim inactiveRegisteredAim = ComposedRegisteredAim(
  readAimKeys: () => emptyAimKeys,
  watchAimState: () => null,
);

final AimRegistry focusedAimRegistry = ComposedAimRegistry(
  registerAim: (action) => inactiveRegisteredAim,
);

class RegisteredAimData {
  final AimAction aimAction;

  late final AimKeys aimKeys;
  final pressedCountFw = fw<int?>(null);

  late final aimKeysString = aimKeys.map((e) => e.character).join();

  late final aimStateFr = fr(() {
    final pressedCount = pressedCountFw();
    if (pressedCount == null) {
      return null;
    }

    final aimKeysString = this.aimKeysString;

    return AimState(
      pressed: aimKeysString.substring(0, pressedCount),
      notPressed: aimKeysString.substring(pressedCount),
    );
  });

  RegisteredAimData({
    required this.aimAction,
  });
}

class AimRegistryData {
  final aims = <RegisteredAimData>[];
}

AimsBuilder createAimsBuilder({
  required final HandlePressedKey? focusedHandler,
}) {
  if (focusedHandler == null) {
    final aimRegistryData = AimRegistryData();

    return ComposedAimsBuilder(
      aimRegistry: aimRegistryData.createUnfocusedAimRegistry(),
      buildAims: (aimKeysCollectionProvider) {
        final aims = aimRegistryData.aims;
        final aimCount = aims.length;
        final aimKeysCollection = aimKeysCollectionProvider(aimCount);

        iterableZip2ForEach(
          left: aims,
          right: aimKeysCollection,
          action: (left, right) {
            left.aimKeys = right;
          },
        );

        final aimHandlerData = createAimHandlerData(aims: aims);

        return (pressedKey) {
          aimHandlerData.handleAimPressedKey(
            pressedKey: pressedKey,
          );
        };
      },
    );
  } else {
    return ComposedAimsBuilder(
      aimRegistry: focusedAimRegistry,
      buildAims: (_) => focusedHandler,
    );
  }
}

class AimHandlerData {
  late AimHandlerNode currentNode;
}

AimHandlerData createAimHandlerData({
  required List<RegisteredAimData> aims,
}) {
  final aimHandlerData = AimHandlerData();

  late final AimHandlerNode rootNode;

  void resetState() {
    for (final aim in aims) {
      aim.pressedCountFw.value = defaultAimState;
    }
    aimHandlerData.currentNode = rootNode;
  }

  // TODO
  AimHandlerNode processLevel({
    required int level,
    required List<RegisteredAimData> aims,
  }) {
    final byKey = aims.groupListsBy((aim) => aim.aimKeys[level]);

    return (pressedKey) {
      switch (pressedKey) {
        case PressedKey.escape:
          resetState();
        case CharacterKey():
          final foundAims = byKey[pressedKey];

          if (foundAims != null) {
            final enabledAims = foundAims
                .map((aim) {
                  final action = aim.aimAction();
                  if (action != null) {
                    return (aim: aim, action: action);
                  }
                  return null;
                })
                .whereNotNull()
                .toList();

            if (enabledAims.isEmpty) {
              return;
            }

            switch (foundAims) {
              case [final singleAim]:
                assert(enabledAims.single.aim == singleAim);
                resetState();
                enabledAims.first.action();
              default:
                assert(foundAims.isNotEmpty);
                final nextLevel = level + 1;
                byKey.forEach(
                  (key, aims) {
                    if (key == pressedKey) {
                      for (final aim in aims) {
                        aim.pressedCountFw.value = nextLevel;
                      }
                    } else {
                      for (final aim in aims) {
                        aim.pressedCountFw.value = null;
                      }
                    }
                  },
                );

                aimHandlerData.currentNode = (pressedKey) {
                  processLevel(
                    level: nextLevel,
                    aims: foundAims,
                  );
                };
            }
          }
        case ControlKey():
      }
    };
  }

  rootNode = processLevel(level: 0, aims: aims);

  resetState();

  return aimHandlerData;
}

void handleAimPressedKey({
  @ext required AimHandlerData aimHandlerData,
  required PressedKey pressedKey,
}) {
  aimHandlerData.currentNode(pressedKey);
}

@Compose()
abstract class AimHandlerParent {}

@Has()
typedef HandleAimNodePressedKey = void Function(
  PressedKey pressedKey,
  AimHandlerParent parent,
);

typedef AimHandlerNode = HandlePressedKey;

@Has()
typedef BuildAims = HandlePressedKey Function(
  ProviderAimKeysCollection providerAimKeysCollection,
);

@Compose()
abstract class AimsBuilder implements HasAimRegistry, HasBuildAims {}

AimRegistry createUnfocusedAimRegistry({
  @ext required AimRegistryData aimRegistryData,
}) {
  return ComposedAimRegistry(
    registerAim: (aimAction) {
      final registeredAimData = RegisteredAimData(
        aimAction: aimAction,
      );

      aimRegistryData.aims.add(registeredAimData);

      return ComposedRegisteredAim(
        readAimKeys: () => registeredAimData.aimKeys,
        watchAimState: registeredAimData.aimStateFr.watch,
      );
    },
  );
}

sealed class PressedKey {
  static const escape = ControlKey(LogicalKeyboardKey.escape);
  static const backspace = ControlKey(LogicalKeyboardKey.backspace);
  static const enter = ControlKey(LogicalKeyboardKey.enter);
}

@freezed
class CharacterKey with _$CharacterKey implements PressedKey {
  const factory CharacterKey(String character) = _CharacterShortcutKey;
}

@freezed
class ControlKey with _$ControlKey implements PressedKey {
  const factory ControlKey(LogicalKeyboardKey logicalKeyboardKey) =
      _LogicalShortcutKey;
}

PressedKey? keyEventToPressedKey({
  @ext required KeyEvent keyEvent,
}) {
  if (keyEvent is KeyDownEvent) {
    PressedKey shortcutKey;
    final character = keyEvent.character;
    if (character != null) {
      shortcutKey = CharacterKey(character);
    } else {
      shortcutKey = ControlKey(keyEvent.logicalKey);
    }
    return shortcutKey;
  }

  return null;
}

@freezed
class AimState with _$AimState {
  const factory AimState({
    required String pressed,
    required String notPressed,
  }) = _AimState;
}
