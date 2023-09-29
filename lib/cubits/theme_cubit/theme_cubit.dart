
import 'package:flutter/material.dart' show BuildContext,ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.values[GetStorage().read('theme-mode')??0]);

  static ThemeCubit get(BuildContext context) => BlocProvider.of<ThemeCubit>(context);

  changeBrightness(ThemeMode value) {

    GetStorage().write('theme-mode', value.index);
    emit(value);}
}
