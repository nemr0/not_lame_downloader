import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:not_lame_downloader/helpers/overlays/toast.dart';

import '../../../helpers/link_validator.dart';
import 'modal_popups.dart';


class AddDownloadModalPopUp extends HookWidget {
  const AddDownloadModalPopUp({super.key});

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

    return ModalPopups(
        title: 'Add Download Page',
        child: Column(


          children: [
            CupertinoButton(
                child: const Text('Test'),
                onPressed: () async {
                  DownloadCubit.get(context).exampleDownload();
                }),
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
                  autofocus: true,
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
                    if (state.pop) Navigator.pop(context);
                  }
                  if (state is DownloadEnqueuedErrorState) {
                    showToast(context, state.error);
                  }
                },
                builder: (context, state) {
                  return CupertinoButton(
                      padding: const EdgeInsets.all(12),
                      color: CupertinoColors.activeBlue,
                      child: state is DownloadEnqueuedLoadingState
                          ? const CupertinoActivityIndicator()
                          : const Text(
                              'Add Download',
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                      onPressed: () {
                        error.value = validateLink(controller.text);
                        if (error.value == null) {
                          //add download
                          DownloadCubit.get(context)
                              .addDownloadTask(controller.text);
                        } else {}
                      });
                },
              ),
            ),
          ],
        )
    );
  }
}
