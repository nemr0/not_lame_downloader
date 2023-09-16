import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';
import 'package:not_lame_downloader/helpers/glass_morphism_box_decoration.dart';
import 'package:not_lame_downloader/helpers/measure_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

showToast(BuildContext context, String msg,
    {Color color = CupertinoColors.systemBlue,
    Color textColor = CupertinoColors.white,
    Duration duration = const Duration(seconds: 3)}) async {
  if (msg.isEmpty) {
    msg = 'An Error Happened!';
  }
  OverlayState overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Toast(
            msg: msg,
            color: color,
            textColor: textColor,
            duration: duration,
          ));
  overlayState.insert(overlayEntry);
  await Future.delayed(duration);
  overlayEntry.remove();
}

class Toast extends HookWidget {
  const Toast(
      {super.key,
      required this.msg,
      required this.color,
      required this.textColor,
      required this.duration});

  final String msg;
  final Color color;
  final Color textColor;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final size=useState(Size.zero);
    final Duration delayDuration=Duration(milliseconds: duration.inMilliseconds-400);
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom,
      left: (context.width()*.5)-(size.value.width*.5),
      child: MeasureSize(
        onChange: (Size mSize)=>size.value=mSize,

        child: Container(
          padding: const EdgeInsets.all(6),
          height: 40,
          decoration: glassBoxDecoration(
            color: color.withOpacity(.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              msg,
              style: TextStyle(color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    )
        .animate()
        .scale()
        .slideY(delay: const Duration(milliseconds: 100),begin: 0, )
        .blur(delay: delayDuration)
        .slide(delay: delayDuration,);
  }
}
