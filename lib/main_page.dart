import 'package:flutter_svg/svg.dart';
import 'package:not_lame_downloader/app_assets.dart';
import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';
import 'package:not_lame_downloader/screens/add_download_page.dart';
import 'package:not_lame_downloader/screens/downloaded_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'cubits/theme_cubit/theme_cubit.dart';

class MainPage extends HookWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: BlocBuilder<ThemeCubit, Brightness>(
          builder: (context, state) => CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(state == Brightness.light
                ? CupertinoIcons.brightness_solid
                : CupertinoIcons.moon_fill),
            onPressed: () => ThemeCubit.get(context).changeBrightness(
                state == Brightness.dark ? Brightness.light : Brightness.dark),
          ),
        ),
        middle: const Text('NotLameDownloader'),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => const AddDownloadPage());
            },
            child: const Icon(CupertinoIcons.add)),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: const [
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.down_arrow,
              ),
              label: 'Downloads'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.archivebox_fill), label: 'Files')
        ]),
        tabBuilder: (context, index) {
          return Stack(
            children: [
              Center(
                child: SvgPicture.asset(
                  AppAssets.assets_notlamedownloader_svg,
                  fit: BoxFit.contain,
                  height: context.height()*.2,
                  width: context.width()*.2,
                  theme: SvgTheme(
                      currentColor:
                          CupertinoTheme.of(context).barBackgroundColor),
                  colorFilter: ColorFilter.mode(
                      CupertinoTheme.of(context).barBackgroundColor,
                      BlendMode.hardLight),
                ),
              ),
              const DownloadedPage(),
            ],
          );
        },
      ),
    );
  }
}
