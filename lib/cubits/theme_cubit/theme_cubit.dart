
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class ThemeCubit extends Cubit<Brightness> {
  ThemeCubit() : super(Brightness.values[GetStorage().read('brightness')??1]);
  initialize(BuildContext context) {
   if( GetStorage().read('brightness') != null) return;

    WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) =>
            emit(MediaQuery
                .of(context)
                .platformBrightness));
  }
  static get(BuildContext context) => BlocProvider.of<ThemeCubit>(context);

  changeBrightness(Brightness value) {
    GetStorage().write('brightness', value.index);
    emit(value);}
}
