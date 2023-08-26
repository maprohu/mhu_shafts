import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';

import '../bx/boxed.dart';

part 'static.g.has.dart';
// part 'static.g.compose.dart';


typedef StaticBuilder = Bx Function(Size size);

@Has()
typedef LabelBuilder = StaticBuilder;