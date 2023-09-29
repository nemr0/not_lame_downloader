import 'package:flutter/cupertino.dart';
import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';

class ModalPopups extends StatelessWidget {
  const ModalPopups(
      {super.key,
      required this.child,
      required this.title,
      this.heightRatio = 1});

  final Widget child;
  final String title;

  /// 0 - 1 of device's height, defaults to one
  final double heightRatio;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.down,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: SizedBox(
          width: context.width,
          height: context.height * heightRatio,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: MediaQuery.of(context).padding.copyWith(
                  top: heightRatio == 1
                      ? MediaQuery.of(context).padding.top
                      : 12),
            ),
            child: CupertinoPageScaffold(
              resizeToAvoidBottomInset: true,
              navigationBar: CupertinoNavigationBar(
                // padding: EdgeInsetsDirectional.zero,
                leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.chevron_down),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                middle: Text(title),
              ),
              child: child,
            ),
          ),
        ));
  }
}
