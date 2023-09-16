import 'package:not_lame_downloader/cubits/theme_cubit/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import 'cubits/download_cubit/download_cubit.dart';
import 'main_page.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => DownloadCubit()..initialize()..getDownloadedFiles(),lazy: false,),
        BlocProvider(
            create: (context) => ThemeCubit()..initialize(context), lazy: false)
      ],
      child: BlocBuilder<ThemeCubit, Brightness>(
        builder: (context, state) => CupertinoApp(
          title: 'NotLameDownloader',
          theme: CupertinoThemeData(

              barBackgroundColor: state == Brightness.light?CupertinoColors.extraLightBackgroundGray:CupertinoColors.black,
              brightness: state, primaryColor: CupertinoColors.link),
          home: const MainPage(),
        ),
      ),
    );
  }
}
