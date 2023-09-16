import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';
import 'package:not_lame_downloader/helpers/overlays/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../helpers/link_validator.dart';

class AddDownloadPage extends HookWidget {
  const AddDownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final error = useState<String?>(null);
    final didPaste = useState<bool>(false);
    /// Paste from [Clipboard] or Clear [controller]
    onPasteOrClear() async {
      /// Clear if did paste
      if (didPaste.value) {
        controller.text = '';
        didPaste.value = false;
      }

      /// Paste if not
      else {
        final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
        if (clipboardData?.text != null) {
          controller.text = clipboardData!.text!;
        }
        didPaste.value = true;
      }
    }

    return SizedBox(
      height: context.height()*.6,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.down,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            // backgroundColor: CupertinoColors.black,
            leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.chevron_down),
                onPressed: () {
                  Navigator.pop(context);
                }),
            middle: const Text('Add A New Download'),
          ),
          child: Column(
            // margin: const EdgeInsets.all(8),
            // header: Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     CupertinoButton(
            //         padding: EdgeInsets.zero,
            //         child: const Icon(CupertinoIcons.back), onPressed: (){
            //       Navigator.pop(context);
            //     }),
            //     const Text('Add A New Download'),
            //   ],
            // ),

            children: [
              CupertinoFormRow(
                  padding: const EdgeInsets.all(15),
                  error: error.value == null
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            error.value!,
                            style: const TextStyle(
                                color: CupertinoColors.destructiveRed),
                          ),
                        ),
                  child: CupertinoTextField(
                    controller: controller,
                    maxLines: 4,
                    minLines: 1,
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Icon(CupertinoIcons.link),
                    ),
                    padding: const EdgeInsets.all(12),
                    suffix: CupertinoButton(
                        onPressed: onPasteOrClear,
                        child: Text(didPaste.value ? 'Clear' : 'Paste')),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: BlocConsumer<DownloadCubit, DownloadState>(
                  listener: (context, state) {
                    if (state is DownloadTaskEnqueuedState) {
                      Navigator.pop(context);
                    }
                    if (state is DownloadEnqueuedErrorState) {
                      showToast(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        // CupertinoButton(child: Text('Delete Old Tasks'),color: CupertinoColors.destructiveRed, onPressed: (){
                        //   FileDownloader().database.deleteAllRecords();
                        //   DownloadCubit.get(context).tasks.clear();
                        // }),
                        CupertinoButton(
                            padding: const EdgeInsets.all(12),
                            color: CupertinoColors.activeBlue,
                            child: state is DownloadEnqueuedLoadingState
                                ? const CupertinoActivityIndicator()
                                : const Text(
                                    'Add Download',
                                    style: TextStyle(
                                        color: CupertinoColors.white),
                                  ),
                            onPressed: () {
                              error.value = validateLink(controller.text);
                              if (error.value == null) {
                                //add download
                                DownloadCubit.get(context)
                                    .addDownloadTask(controller.text);
                              } else {}
                            }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
