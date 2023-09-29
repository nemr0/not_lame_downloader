
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';
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
    final showPreview=useState(false);
    final buttonLoading = useState(false);

    /// Paste from [Clipboard] or Clear [controller]
    onPasteOrClear() async {
      /// Clear if did paste
      if (didPaste.value) {
        controller.text = '';
        didPaste.value = false;
        showPreview.value=false;
        error.value=null;
      }

      /// Paste if not
      else {
        final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
        if (clipboardData?.text != null) {
          controller.text = clipboardData!.text!;
        }
        didPaste.value = true;
        if(validateLink(controller.text)==null) {
          showPreview.value = true;
          error.value=null;
        }
      }
    }


    return GestureDetector(
        onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
      child: ModalPopups(
          title: const Text('Add Download Page'),
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.all(12),
            children: [
              SizedBox(
                height: context.bottomPadding,
              ),
             Material(
               color: Colors.transparent,

               child: AnimatedSwitcher(duration: const Duration(milliseconds: 400),
               child: (showPreview.value)?Padding(padding: const EdgeInsets.all(12),
               child: LinkPreviewGenerator(link: controller.text)):const SizedBox.shrink()),
             ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: BlocListener<DownloadCubit, DownloadState>(
                  listener: (context, state) {
                    if (state is DownloadTaskEnqueuedState) {
                      if (state.pop) Navigator.pop(context);
                    }
                    if (state is DownloadEnqueuedErrorState) {
                      showToast(context, state.error);
                    }

                    if(state is DownloadEnqueuedLoadingState){
                      buttonLoading.value=true;
                    }
                    else{
                      buttonLoading.value=false;
                    }
                  },
                  child:CupertinoButton(
                        padding: const EdgeInsets.all(12),
                        color: CupertinoColors.activeBlue,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: buttonLoading.value
                              ? const CupertinoActivityIndicator()
                              : showPreview.value?const Text(
                            'Add Download',
                            style: TextStyle(color: CupertinoColors.white),
                          ):const Text(
                            'Show Preview',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                        ),
                        onPressed: () {
                          error.value = validateLink(controller.text);
                          if (error.value == null) {
                            if(showPreview.value==false) {
                            showPreview.value = true;
                          }
                            else{
                              DownloadCubit.get(context).addDownloadTask(controller.text);
                            }
                        } else {}
                        },

                    )

                ),
              ),
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
                    onChanged: (_){
                      showPreview.value=false;
                      },
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Icon(CupertinoIcons.link),
                    ),
                    padding: const EdgeInsets.all(12),
                    suffix: CupertinoButton(
                        onPressed: onPasteOrClear,
                        child: Text(didPaste.value ? 'Clear' : 'Paste')),
                  )),

            ],
          )
      ),
    );
  }
}
