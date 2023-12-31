part of '../shaft_factory.dart';

CallShaftHeaderLabel staticShaftHeaderLabel(String label) {
  return stringShaftHeaderLabel(
    label.toCall,
  );
}

CallShaftHeaderLabel stringShaftHeaderLabel(
  String Function() label,
) {
  return () {
    return (rectCtx) {
      return rectCtx.wxShaftHeaderLabelString(
        label: label(),
      );
    };
  };
}

ShaftLabel stringConstantShaftLabel(
  String label,
) {
  return stringCallShaftLabel(
    label.toCall,
  );
}

ShaftLabel stringCallShaftLabel(
  String Function() label,
) {
  return ComposedShaftLabel(
    // callShaftHeaderLabel: stringShaftHeaderLabel(label),
    // callShaftOpenerLabel: stringShaftOpenerLabel(label),
    callShaftLabelString: label,
  );
}

CallShaftOpenerLabel stringShaftOpenerLabel<D>(
  String Function() label,
) {
  return () {
    return (rectCtx) {
      return rectCtx.wxMenuItemLabelString(
        label: label(),
      );
    };
  };
}
