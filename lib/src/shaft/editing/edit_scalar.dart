
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/app.dart';
import 'package:mhu_shafts/src/builder/text.dart';
import 'package:mhu_shafts/src/bx/menu.dart';
import 'package:mhu_shafts/src/context/data.dart';
import 'package:mhu_shafts/src/op.dart';
import 'package:mhu_shafts/src/proto.dart';
import 'package:mhu_shafts/src/screen/calc.dart';
import 'package:mhu_shafts/src/screen/opener.dart';
import 'package:mhu_shafts/src/shaft/editing/string.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../long_running.dart';

part 'edit_scalar.g.has.dart';

part 'edit_scalar.g.compose.dart';

@Has()
@Compose()
abstract class EditScalarShaftRight {}

@Compose()
abstract class EditScalarShaftMerge
    implements HasShaftHeaderLabel, ShaftContentBits, HasOnShaftOpen {}

@Compose()
abstract class EditScalarShaft
    implements
        ShaftCalcBuildBits,
        EditScalarShaftRight,
        EditScalarShaftMerge,
        ShaftCalc {
  static EditScalarShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final left = shaftCalcBuildBits.leftCalc as HasEditingBits;

    final scalarEditingBits = left.editingBits as ScalarEditingBits;

    return scalarEditingBits.scalarEditingBitsGeneric(<T>(scalarEditingBits) {
      final shaftRight = ComposedEditScalarShaftRight();

      final ScalarDataType sdt = scalarEditingBits.scalarDataType;
      final merge = switch (sdt) {
        StringDataType() => stringType(
            shaftCalcBuildBits: shaftCalcBuildBits,
            scalarEditingBits: scalarEditingBits,
          ),
        CoreIntDataType() => ComposedEditScalarShaftMerge(
            shaftHeaderLabel: "Edit Int",
            buildShaftContent: (sizedBits) {
              logger.w("TODO: edit int");
              return [];
            },
          ),
        final other => throw other,
      };

      return ComposedEditScalarShaft.merge$(
        shaftCalcBuildBits: shaftCalcBuildBits,
        editScalarShaftMerge: merge,
        editScalarShaftRight: shaftRight,
        // shaftAutoFocus: true,
      );
    });
  }

  static const label = "Edit String";

  static void stringEditPasteFromClipboardSelf(
      ShaftCalcBuildBits shaftCalcBuildBits) {
    stringEditPasteFromClipboard(
      appBits: shaftCalcBuildBits,
      shaftIndexFromLeft: shaftCalcBuildBits.shaftCalcChain.shaftIndexFromLeft,
    );
  }

  static void stringEditPasteFromClipboard({
    required AppBits appBits,
    required ShaftIndexFromLeft shaftIndexFromLeft,
  }) async {
    final string = await getStringFromClipboard();
    final innerState = stringEditInnerState(string ?? "");
    // appBits.accessInnerState(
    //   shaftIndexFromLeft,
    //   (innerStateFw) {
    //     innerStateFw.value = innerState;
    //   },
    // );
    appBits.updateView(() {
      appBits.shaftMsgFuByIndex(shaftIndexFromLeft).update((shaftMsg) {
        shaftMsg.innerState = innerState;
      });
      // appBits.clearFocusedShaft();
    });
  }

  static MshInnerStateMsg stringEditInnerState(String text) {
    final result = MshInnerStateMsg();
    result.ensureStringEdit()
      ..text = text
      ..cursorPosition = text.length;
    return result..freeze();
  }

  static EditScalarShaftMerge stringType<T>({
    required ShaftCalcBuildBits shaftCalcBuildBits,
    required ScalarEditingBits<T> scalarEditingBits,
  }) {
    final isPasting = shaftCalcBuildBits.innerState.stringEdit.pasting;
    if (isPasting) {
      if (shaftCalcBuildBits.opBuilder.isAsyncOpRunning) {
        return ComposedEditScalarShaftMerge(
          shaftHeaderLabel: label,
          buildShaftContent: (sizedBits) {
            return sizedBits.itemText
                .left("Pasting from Clipboard...")
                .toSharingBoxes;
          },
        );
      } else {
        logger.w("pasting without AsyncOp");
      }
    }

    final bits = scalarEditingBits as ScalarEditingBits<String>;
    final currentSavedValue = bits.watchValue();

    final stringParsingBits = StringParsingBits.stringType(
      submitValue: (value) {
        bits.writeValue(value);
        shaftCalcBuildBits.closeShaft();
      },
    );

    void onShaftOpen() {
      shaftCalcBuildBits.updateShaftMsg((shaftMsg) {
        final initialValue = bits.readValue() ?? "";
        shaftMsg.ensureInnerState().ensureStringEdit().text = initialValue;
      });
      focusStringEditor(
        shaftCalcBuildBits: shaftCalcBuildBits,
        stringParsingBits: stringParsingBits,
      );
    }

    final currentParsedValue = stringParsingBits.parseString(
      shaftCalcBuildBits.innerState.stringEdit.text,
    );

    final saveItems = switch (currentParsedValue) {
      ValidationSuccessImpl(value: final parsedValue) =>
        parsedValue != currentSavedValue
            ? <MenuItem>[
                MenuItem(
                  label: "Save and Close",
                  callback: () {
                    shaftCalcBuildBits.updateView(() {
                      bits.writeValue(parsedValue);
                      shaftCalcBuildBits.closeShaft();
                    });
                  },
                ),
                MenuItem(
                  label: "Discard",
                  callback: shaftCalcBuildBits.closeShaft,
                ),
              ]
            : [],
      _ => [],
    };

    return ComposedEditScalarShaftMerge(
      shaftHeaderLabel: label,
      buildShaftContent: (sizedBits) {
        return editScalarAsStringSharingBoxes(
          sizedBits: sizedBits,
          stringParsingBits: stringParsingBits,
          extraBoxes: sizedBits.menu([
            ...saveItems,
            MenuItem(
              label: "Paste from Clipboard",
              callback: () {
                stringEditPasteFromClipboardSelf(shaftCalcBuildBits);
                shaftCalcBuildBits.updateView(() {
                  shaftCalcBuildBits.updateShaftMsg((shaftMsg) {
                    shaftMsg.ensureInnerState().ensureStringEdit().pasting =
                        true;
                  });
                  // shaftCalcBuildBits.requestFocus();
                });
              },
            ),
          ]).toSingleElementIterable,
        );
      },
      onShaftOpen: onShaftOpen,
    );
  }
}
