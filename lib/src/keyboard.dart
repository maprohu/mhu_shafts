import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';

import 'context/render.dart';


class OpShortcuts {
  // static const digitKeys = [
  //   LogicalKeyboardKey.digit0,
  //   LogicalKeyboardKey.digit1,
  //   LogicalKeyboardKey.digit2,
  //   LogicalKeyboardKey.digit3,
  //   LogicalKeyboardKey.digit4,
  //   LogicalKeyboardKey.digit5,
  //   LogicalKeyboardKey.digit6,
  //   LogicalKeyboardKey.digit7,
  //   LogicalKeyboardKey.digit8,
  //   LogicalKeyboardKey.digit9,
  // ];

  // unused
  // used qwertyuiop
  // used asdfghjkl;
  // used \zxcvbnm,./
  static const lowercaseKeyOrder = r"fjdksla;ghvnmruc,eix.woz/tybqp['";
  static final keyChars = lowercaseKeyOrder.characters;
  // static const keyCount = lowercaseKeyOrder.length;

  // static final uppercaseKeyLabelSet =
  //     keyChars.map((e) => e.toUpperCase()).toISet();
  // static final lowercaseKeyLabelSet =
  //     keyChars.map((e) => e.toLowerCase()).toISet();

  // static final uppercaseCharToLogicalKey = {
  //   for (final lk in LogicalKeyboardKey.knownLogicalKeys)
  //     if (uppercaseKeyLabelSet.contains(lk.keyLabel)) lk.keyLabel: lk
  // }.toIMap();

  // static final logicalKeyOrder = lowercaseKeyOrder.characters
  //     .map((e) => uppercaseCharToLogicalKey[e.toUpperCase()]!)
  //     .toIList();

  // static final shortcutKeyOrder =
  //     keyChars.map(_CharacterShortcutKey.new).toIList();

  static final characterShortcutKeys =
      keyChars.map(CharacterKey.new).toIList();

  // static final IList<OpShortcut> singleShortcutKeyOrder =
  //     shortcutKeyOrder.map((sk) => IList<CharacterKey>([sk])).toIList();

  // static final allShortcutLogicalKeys = IList([
  //   ...logicalKeyOrder,
  //   LogicalKeyboardKey.escape,
  //   LogicalKeyboardKey.backspace,
  //   LogicalKeyboardKey.enter,
  //   ...digitKeys,
  // ]);
  // static final allShortcutKeys =
  //     allShortcutLogicalKeys.map(ShortcutKey.of).toIList();

  // static Iterable<OpShortcut> generateShortcuts(int count) {
  //   final singleKeyOpShortcuts = singleShortcutKeyOrder;
  //
  //   final opShortcutsQueue = DoubleLinkedQueue.of(singleKeyOpShortcuts);
  //   var availableShortcutsCount = opShortcutsQueue.length;
  //
  //   while (availableShortcutsCount < count) {
  //     final prefixShortcut = opShortcutsQueue.removeFirst();
  //
  //     final lastKeyOfPrefixShortcut = prefixShortcut.last;
  //
  //     final suffixSingleKeysWithDoubleFirst =
  //         [lastKeyOfPrefixShortcut].followedBy(
  //       shortcutKeyOrder.where((c) => c != lastKeyOfPrefixShortcut),
  //     );
  //
  //     final newShortcuts = suffixSingleKeysWithDoubleFirst.map(
  //       (suffix) => prefixShortcut.add(suffix),
  //     );
  //
  //     opShortcutsQueue.addAll(newShortcuts);
  //
  //     availableShortcutsCount += keyCount - 1;
  //   }
  //
  //   return opShortcutsQueue;
  // }
}



// @freezed
// class ShortcutData with _$ShortcutData {
//   const factory ShortcutData({
//     required OpShortcut shortcut,
//     required int pressedCount,
//   }) = _ShortcutData;
// }
//
// @Has()
// typedef Character = String;
//
// class ShortcutSet with HasNext<ShortcutSet> {
//   final IList<CharacterKey> _keys;
//   final IList<OpShortcut> shortcutList;
//
//   @override
//   late final ShortcutSet next = ShortcutSet(
//     keys: _keys,
//     shortcutList: nextList(
//       keys: _keys,
//       list: shortcutList,
//     ),
//   );
//
//   int get count => shortcutList.length;
//
//   static IList<OpShortcut> nextList({
//     required IList<CharacterKey> keys,
//     required IList<OpShortcut> list,
//   }) {
//     final prefixShortcut = list.first;
//
//     final lastKeyOfPrefixShortcut = prefixShortcut.last;
//
//     final suffixSingleKeysWithDoubleFirst =
//         lastKeyOfPrefixShortcut.toSingleElementIterable.followedBy(
//       keys.where((c) => c != lastKeyOfPrefixShortcut),
//     );
//
//     final newShortcuts = suffixSingleKeysWithDoubleFirst.map(
//       (suffix) => prefixShortcut.add(suffix),
//     );
//
//     return IList(
//       list.skip(1).followedBy(newShortcuts),
//     );
//   }
//
//   bool collectExcluding({
//     required int count,
//     required Set<OpShortcut> exclude,
//     required List<OpShortcut> target,
//   }) {
//     if (count == 0) {
//       return true;
//     }
//     for (final sc in shortcutList) {
//       if (!exclude.contains(sc)) {
//         target.add(sc);
//         count--;
//         if (count == 0) {
//           return true;
//         }
//       }
//     }
//     return false;
//   }
//
//   ShortcutSet({
//     required this.shortcutList,
//     required IList<CharacterKey> keys,
//   }) : _keys = keys;
//
//   ShortcutSet.first(IList<CharacterKey> keys)
//       : this(
//           keys: keys,
//           shortcutList: IList(
//             keys.map(
//               (element) => IList([element]),
//             ),
//           ),
//         );
// }
