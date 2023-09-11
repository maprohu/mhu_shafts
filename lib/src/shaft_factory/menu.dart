part of '../shaft_factory.dart';

CallShaftContent shaftMenuContent<D>(
  List<MenuItem> Function(
    ShaftCtx shaftCtx,
  ) items,
) {
  return () {
    return (rectCtx) {
      return [
        menuRectSharingBox(
          rectCtx: rectCtx,
          items: items(rectCtx),
          pageNumber: 0,
        ),
      ];
    };
  };
}
