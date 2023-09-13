part of '../../rect.dart';

typedef LinearPaddingBuilder<W extends SizingWidget> = W Function(
  LinearCtx deflatedCtx,
  AssignedDimension assignedDimension,
);

LinearPaddingBuilder<RigidWidget> rigidPaddingBuilder({
  @ext required LinearCtx linearCtx,
  required Wx Function(
    LinearCtx deflatedCtx,
  ) builder,
}) {
  return (deflatedCtx, assignedDimension) {
    return builder(deflatedCtx).rigidWidgetWx(
      linearCtx: linearCtx,
    );
  };
}

W linearPadding<W extends SizingWidget>({
  @ext required LinearCtx linearCtx,
  required EdgeInsets edgeInsets,
  required LinearPaddingBuilder<W> builder,
  WidgetDecorator? widgetDecorator,
}) {
  final innerCtx = linearCtx
      .rectWithSize(
        size: edgeInsets.deflateSize(linearCtx.size),
      )
      .createLinearCtx(
        axis: linearCtx.axis,
      );

  final innerHolder = createDimensionHolder();

  final innerWidget = builder(
    innerCtx,
    innerHolder.assignedDimension,
  );

  final paddingMainAxisDimension = edgeInsets.edgeInsetsAxisDimension(
    axis: linearCtx.axis,
  );

  final intrinsicDimension =
      innerWidget.intrinsicDimension + paddingMainAxisDimension;

  late final assignDimensionBits = ComposedAssignDimensionBits(
    assignDimension: (value) =>
        innerHolder.assignDimension(value + paddingMainAxisDimension),
  );

  Wx createWx(Dimension crossExtra) => innerWidget
      .createLinearWx(crossExtra)
      .wxPadding(
        edgeInsets: edgeInsets,
      )
      .wxDecorateWidget(
        decorator: widgetDecorator,
      );

  final sizingWidgetBits = ComposedSizingWidgetBits(
    intrinsicDimension: intrinsicDimension,
    createLinearWx: createWx,
  );

  final SizingWidget result = switch (innerWidget) {
    RigidWidget() => ComposedRigidWidget.sizingWidgetBits(
        sizingWidgetBits: sizingWidgetBits,
      ),
    GrowingWidget() => ComposedGrowingWidget.merge$(
        sizingWidgetBits: sizingWidgetBits,
        assignDimensionBits: assignDimensionBits,
      ),
    ShrinkingWidget() => ComposedShrinkingWidget.merge$(
        sizingWidgetBits: sizingWidgetBits,
        assignDimensionBits: assignDimensionBits,
      ),
  };

  return result as W;
}
