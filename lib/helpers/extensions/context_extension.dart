import 'package:flutter/cupertino.dart';

extension ContextExtension on BuildContext{
  double height()=>MediaQuery.sizeOf(this).height;
  double width()=>MediaQuery.sizeOf(this).width;
}