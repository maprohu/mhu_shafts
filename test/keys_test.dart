import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("keys", (tester) async {
    for (final key in LogicalKeyboardKey.knownLogicalKeys) {
      print(key);
    }
  });
}
