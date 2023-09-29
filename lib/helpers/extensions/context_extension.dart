import 'package:flutter/cupertino.dart';

extension ContextExtension on BuildContext{
  double get height=>MediaQuery.sizeOf(this).height;
  double get bottomViewInsetsPadding=>MediaQuery.of(this).viewInsets.bottom;
  double get bottomPadding=>MediaQuery.of(this).padding.bottom;
  double get width=>MediaQuery.sizeOf(this).width;
}