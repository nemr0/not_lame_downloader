import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:not_lame_downloader/cubits/downloaded_loader_cubit/downloaded_loader_cubit.dart';
import 'package:not_lame_downloader/cubits/theme_cubit/theme_cubit.dart';

import 'cubits/download_cubit/download_cubit.dart';
import 'main_page.dart';

Future<void> main() async {
  await GetStorage.init();
  await FileDownloader().trackTasks();
  FileDownloader().destroy();
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
            ..initialize(),
        ),
        BlocProvider(
          create: (BuildContext context) => ThemeCubit(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
        final Brightness brightness = state == ThemeMode.system
            ? MediaQuery.of(context).platformBrightness
            : state == ThemeMode.light
                ? Brightness.light
                : Brightness.dark;
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'NotLameDownloader',
          themeMode: state,
          theme: brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  primaryColor: CupertinoColors.link,
                  cupertinoOverrideTheme: CupertinoThemeData(
                    scaffoldBackgroundColor: CupertinoColors.black,
                    textTheme: const CupertinoTextThemeData(
                        navTitleTextStyle: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    barBackgroundColor: CupertinoColors.darkBackgroundGray,
                    brightness: brightness,
                  ))
              : ThemeData.light().copyWith(
                  primaryColor: CupertinoColors.link,
                  cupertinoOverrideTheme: CupertinoThemeData(
                    barBackgroundColor:
                        CupertinoColors.extraLightBackgroundGray,
                    brightness: brightness,
                  )),
          // ThemeData(

          //         primaryColor: )),
          home: const MainPage(),
        );
      }),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
