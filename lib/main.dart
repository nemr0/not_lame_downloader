import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:not_lame_downloader/cubits/downloaded_loader_cubit/downloaded_loader_cubit.dart';
import 'package:not_lame_downloader/cubits/theme_cubit/theme_cubit.dart';

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
        BlocProvider(
          create: (BuildContext context) =>
              DownloadedLoaderCubit()..initializeOrUpdate(firstLoad: true),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) => DownloadCubit()
            ..initialize()
            ..getDownloadedFiles(),
        ),
        BlocProvider(
          create: (BuildContext context) => ThemeCubit()..initialize(context),
        )
      ],
      child: BlocBuilder<ThemeCubit, Brightness>(
        builder: (context, state) => CupertinoApp(
          navigatorKey: navigatorKey,
          title: 'NotLameDownloader',
          theme: CupertinoThemeData(
              barBackgroundColor: state == Brightness.light
                  ? CupertinoColors.extraLightBackgroundGray
                  : CupertinoColors.darkBackgroundGray,
              brightness: state,
              primaryColor: CupertinoColors.link),
          home: const MainPage(),
        ),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
