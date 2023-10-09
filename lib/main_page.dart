import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:not_lame_downloader/app_assets.dart';
import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';
import 'package:not_lame_downloader/screens/download_task_page.dart';
import 'package:not_lame_downloader/screens/widgets/modal_popups/add_download_modal_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'cubits/theme_cubit/theme_cubit.dart';

class MainPage extends HookWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          leading: BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(state == ThemeMode.system
                  ? Icons.brightness_4
                  : state == ThemeMode.light
                      ? CupertinoIcons.brightness_solid
                      : CupertinoIcons.moon_fill),
              onPressed: () {
                final ThemeMode newThemeMode = (state == ThemeMode.system)
                    ? ThemeMode.dark
                    : state == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.system;
                ThemeCubit.get(context).changeBrightness(newThemeMode);
              },
            );
          }),
          middle: const Text('NotLameDownloader'),
          trailing: PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                title: 'Add Download',
                onTap: () {
                  showCupertinoModalPopup(context: context, builder: (context) => const AddDownloadModalPopUp());
                },
              ),
              PullDownMenuItem(
                title: 'Delete All Tasks',
                onTap: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                            title: const Text('Delete All Tasks!'),
                            content: const Text('Are you sure you want to delete all tasks?'),
                            actions: [
                              CupertinoDialogAction(
                                onPressed: () =>
                                  FileDownloader().database.deleteAllRecords().then((value) {
                    FileDownloader().destroy(); DownloadCubit
                        .get(context)
                        .getDownloadedTasks()
                        .then((value) => Navigator.of(context).pop());}),
                                isDestructiveAction: true,
                                child: const Text(
                                  'Yes',
                                )
                              ),
                              CupertinoDialogAction(
                                child: const Text(
                                  'No',
                                ),
                                onPressed: () =>Navigator.of(context).pop(),
                              ),
                            ],
                          ));
                },
              ),
            ],
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.ellipsis_circle),
            ),
          )),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: const [
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.down_arrow,
              ),
              label: 'Downloads'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.archivebox_fill), label: 'Files')
        ]),
        tabBuilder: (context, index) {
          return Stack(
            children: [
              Center(
                child: SvgPicture.asset(
                  AppAssets.assets_notlamedownloader_svg,
                  fit: BoxFit.contain,
                  height: context.height * .2,
                  width: context.width * .2,
                  theme: SvgTheme(currentColor: CupertinoTheme.of(context).barBackgroundColor),
                  colorFilter: ColorFilter.mode(CupertinoTheme.of(context).barBackgroundColor, BlendMode.hardLight),
                ),
              ),
              const DownloadTasksPage(),
            ],
          );
        },
      ),
    );
  }
}
