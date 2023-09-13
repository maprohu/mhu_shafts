part of '../../rect.dart';

RigidWidget linearDivider({
  @ext required LinearCtx linearCtx,
  required Dimension thickness,
}) {
  return linearCtx.linearRigid(
    createLinearWx: (extraCrossDimension) {
      return wxRectDivider(
        rectCtx: linearCtx.rectWithSize(
          size: linearCtx
              .orientedBoxWithCrossDimension(
                dimension: extraCrossDimension,
              )
              .size,
        ),
        layoutAxis: linearCtx.axis,
        thickness: thickness,
      );
    },
  );
}

Wx wxLinearDividerStretch({
  @ext required LinearCtx linearCtx,
  required Dimension thickness,
}) {
  return wxRectDivider(
    rectCtx: linearCtx,
    layoutAxis: linearCtx.axis,
    thickness: thickness,
  );
}

Dimension itemsWithDividersDimension({
  required int itemCount,
  required Dimension itemDimension,
  required Dimension? dividerThickness,
}) {
  assert(itemCount >= 1);
  return (itemDimension * itemCount) +
      ((itemCount - 1) * (dividerThickness ?? 0));
}
