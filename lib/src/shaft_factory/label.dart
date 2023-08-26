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

ShaftLabel staticShaftLabel(
  String label,
) {
  return stringShaftLabel(
    label.toCall,
  );
}

ShaftLabel stringShaftLabel(
  String Function() label,
) {
  return ComposedShaftLabel(
    callShaftHeaderLabel: stringShaftHeaderLabel(label),
    callShaftOpenerLabel: stringShaftOpenerLabel(label),
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
