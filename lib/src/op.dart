// // ignore_for_file: unused_import
//
// import 'package:collection/collection.dart';
// import 'package:fast_immutable_collections/fast_immutable_collections.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/proto.dart';
// import 'package:mhu_shafts/src/bx/screen.dart';
// import 'package:mhu_shafts/src/keyboard.dart';
// import 'package:mhu_shafts/src/model.dart';
//
// import 'context/data.dart';
// import 'screen/calc.dart';
//
// part 'op.freezed.dart';
//
// part 'op.g.has.dart';
// // part 'op.g.compose.dart';
//
// typedef OpCallback = VoidCallback;
// typedef OpCallbackIndirect = OpCallback? Function();
//
//
//
//
//
// class _OpBuild {
//   final OpBuilder builder;
//   final ops = <_BuildReg>[];
//
//   final _callbackSet = <OpCallback>{};
//   final _callbackIndirectSet = <OpCallbackIndirect>{};
//
//   _OpBuild(
//     this.builder,
//   );
//
//   OpBuildHandle register(OpCallback callback) {
//     assert(
//       _callbackSet.add(callback),
//       "callback already added: $callback",
//     );
//
//     return registerIndirect(() => callback);
//   }
//
//   OpBuildHandle registerIndirect(OpCallbackIndirect callback) {
//     assert(
//       _callbackIndirectSet.add(callback),
//       "callback already added: $callback",
//     );
//
//     final reg = _BuildReg(callback);
//
//     ops.add(reg);
//
//     return OpBuildHandle(
//       shortcut: () => reg.shortcut,
//       watchState: () {
//         return reg.pressed();
//       },
//     );
//   }
//
//   late final node = _OpNode(
//     regs: ops,
//     level: 0,
//     build: this,
//   );
//
//   late _OpNode currentNode = node;
//
//   // void invokeRawKeyListeners(KeyEvent keyEvent) {
//   //   for (final listener in rawKeyListeners) {
//   //     listener(keyEvent);
//   //   }
//   // }
//
//   void keyPressed(PressedKey key) {
//     currentNode.keyPressed(key);
//   }
// }
//
// class _OpNode {
//   final Iterable<_BuildReg> regs;
//   final int level;
//   final _OpBuild build;
//
//   _OpNode({
//     required this.regs,
//     required this.level,
//     required this.build,
//   });
//
//   late final map = regs
//       .where((r) => r.shortcut.length > level)
//       .groupListsBy((r) => r.shortcut[level])
//       .map(
//         (key, value) => MapEntry(
//           key,
//           _OpNode(
//             regs: value,
//             level: level + 1,
//             build: build,
//           ),
//         ),
//       );
//
//   void keyPressed(PressedKey key) {
//     if (level != 0 && key == PressedKey.escape) {
//       build.builder._clearPressed();
//       return;
//     }
//     final node = map[key];
//
//     if (node != null) {
//       node.click(this, key);
//     }
//   }
//
//   late final isLeaf = regs.length == 1;
//
//   void click(_OpNode parent, PressedKey key) {
//     if (!isLeaf) {
//       for (final reg in regs) {
//         reg.pressed.value = level;
//       }
//       for (final entry in parent.map.entries) {
//         if (entry.key != key) {
//           for (final reg in entry.value.regs) {
//             reg.pressed.value = null;
//           }
//         }
//       }
//       build.currentNode = this;
//     } else {
//       final action = regs.single.actionIndirect();
//       if (action != null) {
//         build.builder._clearPressed();
//         action();
//       }
//     }
//   }
// }
//
// typedef ShortcutKeyListener = void Function(PressedKey key);
//
// @Has()
// class OpBuilder {
//   final DataCtx configBits;
//   late _OpBuild _opBuild;
//
//   final _exclude = <OpShortcut>{};
//
//   late final shortcutKeysInOrder = OpShortcuts.shortcutKeyOrder;
//
//   late final _shortcutChain = ShortcutSet.first(
//     shortcutKeysInOrder,
//   );
//
//   OpBuilder(this.configBits);
//
//   void _clearPressed() {
//     for (final reg in _opBuild.ops) {
//       reg.pressed.value = 0;
//     }
//   }
//
//   void keyPressed(PressedKey key) {
//     _opBuild.keyPressed(key);
//   }
//
//   static const shortuctEq = IterableEquality<PressedKey>();
//
//   final _runningAsyncOp = fw<_RunningAsyncOp?>(null);
//
//   late final runningAsyncOpShaftIndex = fr(
//     () => _runningAsyncOp()?.shaftIndexFromLeft,
//   );
//
//   OpBuildHandle register(OpCallback callback) {
//     assert(!_built);
//
//     if (_runningAsyncOp.watch() != null) {
//       return OpBuildHandle.empty;
//     }
//
//     return _opBuild.register(callback);
//   }
//
//   OpBuildHandle registerIndirect(OpCallbackIndirect callback) {
//     assert(!_built);
//
//     if (_runningAsyncOp.watch() != null) {
//       return OpBuildHandle.empty;
//     }
//
//     return _opBuild.registerIndirect(callback);
//   }
//
//   var _built = true;
//
//   Iterable<OpShortcut> _findShortcuts(int count) {
//     final exclude = _exclude;
//     if (exclude.isEmpty) {
//       return _shortcutChain.iterable
//           .firstWhere((s) => s.count >= count)
//           .shortcutList;
//     } else {
//       final target = <OpShortcut>[];
//       for (final set in _shortcutChain.iterable) {
//         final found = set.collectExcluding(
//           count: count,
//           exclude: exclude,
//           target: target,
//         );
//         if (found) {
//           return target;
//         }
//         target.clear();
//       }
//       throw "never";
//     }
//   }
//
//   void _build() {
//     assert(!_built);
//     _built = true;
//
//     final shortcuts = _findShortcuts(_opBuild.ops.length);
//     _opBuild.ops.zipForEachWith(shortcuts, (reg, shortcut) {
//       reg.shortcut = shortcut;
//     });
//   }
//
//   T build<T>(
//     T Function() builder,
//   ) {
//     assert(_built);
//     _built = false;
//
//     _opBuild = _OpBuild(this);
//
//     try {
//       return builder();
//     } finally {
//       _build();
//     }
//   }
//
//   void onKeyEvent(KeyEvent keyEvent) {
//     final shortcutKey = keyEvent.toShortcutKey;
//     if (shortcutKey == null) {
//       return;
//     }
//
//     final runningAsyncOp = _runningAsyncOp.read();
//
//     if (runningAsyncOp == null) {
//       _opBuild.keyPressed(shortcutKey);
//     } else {
//       runningAsyncOp.invokeKeyListeners(shortcutKey);
//     }
//   }
//
//   bool get isAsyncOpRunning => _runningAsyncOp.read() != null;
//
//   void startAsyncOp({
//     required ShaftIndexFromLeft shaftIndexFromLeft,
//     required Future<VoidCallback> Function(
//       AddShortcutKeyListener addShortcutKeyListener,
//     ) start,
//   }) async {
//     assert(_runningAsyncOp.read() == null);
//
//     final running = _RunningAsyncOp(
//       shaftIndexFromLeft: shaftIndexFromLeft,
//     );
//     _runningAsyncOp.value = running;
//
//     VoidCallback? result;
//     try {
//       final future = start(
//         running.addShortcutKeyListener,
//       );
//       result = await future;
//     } finally {
//       configBits.updateView(() {
//         if (result != null) {
//           result();
//         }
//
//         _runningAsyncOp.value = null;
//       });
//     }
//   }
// }
//
// class _RunningAsyncOp {
//   final ShaftIndexFromLeft shaftIndexFromLeft;
//   final keyListeners = <ShortcutKeyListener>{};
//
//   late final AddShortcutKeyListener addShortcutKeyListener = keyListeners.add;
//
//   void invokeKeyListeners(PressedKey key) {
//     for (final listener in keyListeners) {
//       listener(key);
//     }
//   }
//
//   _RunningAsyncOp({
//     required this.shaftIndexFromLeft,
//   });
// }
//
// extension KeyEventX on KeyEvent {
//   PressedKey? get toShortcutKey {
//     final keyEvent = this;
//     if (keyEvent is KeyDownEvent) {
//       PressedKey shortcutKey;
//       final character = keyEvent.character;
//       if (character != null) {
//         shortcutKey = CharacterKey(character);
//       } else {
//         shortcutKey = ControlKey(keyEvent.logicalKey);
//       }
//       return shortcutKey;
//     }
//
//     return null;
//   }
// }
//
// typedef AddShortcutKeyListener = void Function(
//   ShortcutKeyListener shortcutKeyListener,
// );
