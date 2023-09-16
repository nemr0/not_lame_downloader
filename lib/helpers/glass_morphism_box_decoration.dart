
import 'package:flutter/cupertino.dart';

/// enabled for any container
BoxDecoration glassBoxDecoration(

    /// use a color with 35% opacity
    {
      required Color color,
      double radius = 10,
      BorderRadius? borderRadius,
      Size? size,
    }) =>
    BoxDecoration(
      border:
      Border.all(color: CupertinoColors.white.withOpacity(.1), width: 1),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(.2),
          blurRadius: 10,
          spreadRadius: 5,
          offset: size == null ? Offset.zero : Offset(0, size.height / 2),
        ),
      ],
      color: color,
      borderRadius: borderRadius ??= BorderRadius.all(
        Radius.circular(radius),
      ),
    );
