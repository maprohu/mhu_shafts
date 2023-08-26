import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/builder/shaft.dart';
import 'package:mhu_shafts/src/builder/sized.dart';
import 'package:mhu_shafts/src/bx/menu.dart';
import 'package:mhu_shafts/src/context/data.dart';
import 'package:mhu_shafts/src/sharing_box.dart';
import 'package:mhu_shafts/src/bx/string.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:mhu_shafts/src/screen/notification.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:protobuf/protobuf.dart';

import '../../bx/boxed.dart';
import '../../keyboard.dart';
import '../../op.dart';
import '../../theme.dart';

part 'string.g.has.dart';

part 'string.g.compose.dart';

@Has()
typedef MaxStringLength = int?;

@Has()
typedef SubmitValue<T> = void Function(T value);

@Has()
typedef ParseString<T> = ValidatingFunction<String, T>;

@Compose()
abstract class StringParsingBits<T>
    implements HasMaxStringLength, HasSubmitValue<T>, HasParseString<T> {
  static StringParsingBits<String> stringType({
    required SubmitValue<String> submitValue,
  }) {
    return ComposedStringParsingBits(
      submitValue: submitValue,
      parseString: ValidationSuccessImpl.new,
    );
  }

  static final _maxIntLength = 0x7FFFFFFF.toString().length;

  static StringParsingBits<int> intType({
    required SubmitValue<int> submitValue,
  }) {
    return ComposedStringParsingBits(
      submitValue: submitValue,
      parseString: parseIntValidatingFunction,
      maxStringLength: _maxIntLength,
    );
  }
}

SharingBoxes editScalarAsStringSharingBoxes<T>({
  required SizedShaftBuilderBits sizedBits,
  required StringParsingBits<T> stringParsingBits,
  SharingBoxes extraBoxes = const Iterable.empty(),
}) {
  final isFocused = sizedBits.shaftMsg.innerState.stringEdit.focused;

  if (isFocused) {
    if (sizedBits.opBuilder.isAsyncOpRunning) {
      return [
        focusedStringEditorSharingBox(
          sizedBits: sizedBits,
          stringParsingBits: stringParsingBits,
        ),
      ];
    } else {
      logger.w("focused string edit without AsyncOp");
    }
  }

  return unfocusedStringEditSharingBoxes(
    sizedBits: sizedBits,
    extraBoxes: extraBoxes,
    stringParsingBits: stringParsingBits,
  );
}

Widget stringWidgetWithCursor({
  required String text,
  required GridSize gridSize,
  required ThemeWrap themeCalc,
  required bool isFocused,
}) {
  final GridSize(
    :cellCount,
  ) = gridSize;

  final ThemeWrap(
    :textCursorThickness,
    :stringTextStyle,
  ) = themeCalc;

  final textLength = text.length;

  final clipCount = textLength - cellCount;
  final isClipped = clipCount > 0;

  final textAfterClipping = isClipped ? text.substring(clipCount) : text;

  final lineSlices = textAfterClipping.slices(gridSize.columnCount);

  final lines = lineSlices.isEmpty ? const [""] : lineSlices;

  final cursorLineIndex = lines.length - 1;
  final cursorColumnIndex = lines.last.length;

  return Stack(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: textCursorThickness / 2,
        ),
        child: stringLinesWidget(
          lines: lines,
          isClipped: isClipped,
          themeCalc: themeCalc,
        ),
      ),
      Positioned(
        left: cursorColumnIndex * stringTextStyle.width,
        top: cursorLineIndex * stringTextStyle.height,
        child: SizedBox(
          width: textCursorThickness,
          height: stringTextStyle.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: themeCalc.textCursorColor,
            ),
          ),
        ),
      ),
    ],
  );
}

ShortcutKeyListener createStringEditorShortcutKeyListener({
  required void Function() onEnter,
  required void Function() onEscape,
  required bool Function(String text, String character) acceptCharacter,
  required UpdateValue<MshStringEditStateMsg> updateStringEdit,
}) {
  return (key) {
    switch (key) {
      case PressedKey.enter:
        onEnter();
        return;
      case PressedKey.escape:
        onEscape();
        return;
      default:
    }
    updateStringEdit((stringEdit) {
      final text = stringEdit.text;
      switch (key) {
        case PressedKey.backspace:
          final length = text.length;
          if (length > 0) {
            stringEdit.text = text.substring(0, length - 1);
          }
        case CharacterKey(:final character):
          if (acceptCharacter(text, character)) {
            stringEdit.text = "$text$character";
          }

        case _:
      }
    });
  };
}

SharingBox stringEditorSharingBoxFromGridSizeBuilder({
  required SizedShaftBuilderBits sizedBits,
  required double intrinsicHeight,
  required Widget Function(
    GridSize gridSize,
  ) builder,
}) {
  return ComposedSharingBox(
    intrinsicDimension: intrinsicHeight,
    dimensionBxBuilder: (height) {
      final widgetSize = sizedBits.size.withHeight(height);
      final gridSize =
          sizedBits.themeCalc.stringTextStyle.maxGridSize(widgetSize);

      final widget = builder(gridSize);

      return Bx.leaf(
        size: widgetSize,
        widget: widget,
      );
    },
  );
}

typedef FocusedStringEditorState = HasWatchValue<MshStringEditStateMsg?>;
typedef FocusedStringEditorController = ScalarValue<MshStringEditStateMsg>;

SharingBox focusedStringEditorSharingBox<T>({
  required SizedShaftBuilderBits sizedBits,
  required StringParsingBits<T> stringParsingBits,
}) {
  final SizedShaftBuilderBits(
    themeCalc: ThemeWrap(
      :textCursorThickness,
      :stringTextStyle,
    ),
  ) = sizedBits;

  final StringParsingBits(
    :maxStringLength,
  ) = stringParsingBits;

  final FocusedStringEditorState focusedStringEditorState =
      sizedBits.shaftDataStore[sizedBits.shaftIndexFromLeft];

  final availableWidth = sizedBits.width - textCursorThickness;
  final intrinsicHeight = maxStringLength == null
      ? sizedBits.height
      : stringTextStyle.calculateIntrinsicHeight(
          stringLength: maxStringLength,
          width: availableWidth,
        );

  return stringEditorSharingBoxFromGridSizeBuilder(
    sizedBits: sizedBits,
    intrinsicHeight: intrinsicHeight,
    builder: (gridSize) {
      return flcFrr(() {
        final state = focusedStringEditorState.watchValue()!;

        return stringWidgetWithCursor(
          text: state.text,
          gridSize: gridSize,
          themeCalc: sizedBits.themeCalc,
          isFocused: true,
        );
      });
    },
  );
}

SharingBoxes unfocusedStringEditSharingBoxes<T>({
  required SizedShaftBuilderBits sizedBits,
  required StringParsingBits<T> stringParsingBits,
  SharingBoxes extraBoxes = const Iterable.empty(),
}) {
  final SizedShaftBuilderBits(
    themeCalc: ThemeWrap(
      :textCursorThickness,
      :stringTextStyle,
    ),
  ) = sizedBits;
  final availableWidth = sizedBits.width - textCursorThickness;

  final stringEdit = sizedBits.shaftMsg.innerState.stringEdit;
  final text = stringEdit.text;
  final intrinsicHeight = stringTextStyle.calculateIntrinsicHeight(
    stringLength: text.length,
    width: availableWidth,
  );
  final stringSharingBox = stringEditorSharingBoxFromGridSizeBuilder(
    sizedBits: sizedBits,
    intrinsicHeight: intrinsicHeight,
    builder: (gridSize) {
      return stringWidgetWithCursor(
        text: text,
        gridSize: gridSize,
        themeCalc: sizedBits.themeCalc,
        isFocused: false,
      );
    },
  );

  return [
    sizedBits.menu([
      MenuItem(
        label: "Focus",
        callback: () {
          focusStringEditor(
            shaftCalcBuildBits: sizedBits,
            stringParsingBits: stringParsingBits,
          );
        },
      ),
    ]),
    stringSharingBox,
    ...extraBoxes,
  ];
}

void focusStringEditor<T>({
  required ShaftCalcBuildBits shaftCalcBuildBits,
  required StringParsingBits<T> stringParsingBits,
}) {
  final StringParsingBits(
    :parseString,
    :submitValue,
  ) = stringParsingBits;

  shaftCalcBuildBits.updateView(() {
    shaftCalcBuildBits.opBuilder.startAsyncOp(
      shaftIndexFromLeft: shaftCalcBuildBits.shaftIndexFromLeft,
      start: (addShortcutKeyListener) async {
        final completer = Completer();

        final initialStringEdit = shaftCalcBuildBits.shaftCalcChain.shaftMsgFu
            .read()
            .innerState
            .stringEdit;
        FocusedStringEditorController controller =
            fw(initialStringEdit).toScalarValue;
        shaftCalcBuildBits
            .shaftDataStore[shaftCalcBuildBits.shaftIndexFromLeft] = controller;

        void defocus(MshStringEditStateMsg stringEdit) {
          shaftCalcBuildBits.shaftCalcChain.shaftMsgFu.update(
            (shaftMsg) {
              shaftMsg.innerState.stringEdit = stringEdit.rebuild(
                (b) {
                  b.focused = false;
                },
              );
            },
          );

          completer.complete();
        }

        addShortcutKeyListener(
          createStringEditorShortcutKeyListener(
            onEnter: () {
              final stringEdit = controller.readValue()!;
              final text = stringEdit.text;

              final parseResult = parseString(text);

              switch (parseResult) {
                case ValidationSuccess<T>(:final value):
                  shaftCalcBuildBits.updateView(() {
                    defocus(stringEdit);
                    submitValue(value);
                  });
                case ValidationFailure<T>():
                  shaftCalcBuildBits.showNotifications(
                    parseResult.validationFailureMessages,
                  );
              }
            },
            onEscape: () {
              shaftCalcBuildBits.updateView(() {
                defocus(controller.readValue()!);
              });
            },
            acceptCharacter: (text, character) =>
                character == " " ||
                !TextLayoutMetrics.isWhitespace(character.codeUnitAt(0)),
            updateStringEdit: controller.updateMessage(
              lookupPbiMessageOf<MshStringEditStateMsg>().calc,
            ),
          ),
        );

        shaftCalcBuildBits.updateShaftMsg((shaftMsg) {
          shaftMsg.ensureInnerState().ensureStringEdit().focused = true;
        });

        return await completer.future;
      },
    );
  });
}
