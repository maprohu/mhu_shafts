part of '../../rect.dart';

RigidWidget linearRigid({
  @ext required LinearCtx linearCtx,
  required CreateLinearWx createLinearWx,
}) {
  final intrinsicDimension = linearCtx.runWxSizing$(
    () => createLinearWx(0).sizeAxisDimension(
      axis: linearCtx.axis,
    ),
  );
  return ComposedRigidWidget(
    intrinsicDimension: intrinsicDimension,
    createLinearWx: (extraCrossDimension) {
      final wx = createLinearWx(extraCrossDimension);
      assert(
        assertDoubleRoughlyEqual(
          intrinsicDimension,
          wx.sizeAxisDimension(
            axis: linearCtx.axis,
          ),
        ),
      );

      return wx;
    },
  );
}

RigidWidget linearRigidStretched({
  @ext required LinearCtx linearCtx,
  required Call<Wx> createWx,
}) {
  return linearRigid(
    linearCtx: linearCtx,
    createLinearWx: (extraCrossDimension) {
      assert(
        assertDoubleRoughlyEqual(extraCrossDimension, 0),
      );
      final wx = createWx();
      assert(
        linearCtx.assertOrientedCrossRoughlyEqual(size: wx.size),
      );
      return wx;
    },
  );
}
