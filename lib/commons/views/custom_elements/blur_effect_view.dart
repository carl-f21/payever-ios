import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/theme.dart';

class BlurEffectView extends StatelessWidget {
  final Widget child;
  final double radius;
  final double blur;
  final Color color;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final isDashboard;

  BlurEffectView({
    this.child,
    this.radius = 12,
    this.blur = 15,
    this.borderRadius,
    this.color,
    this.padding = EdgeInsets.zero,
    this.isDashboard = false,
  });

  @override
  Widget build(BuildContext context) {
    if (this.isDashboard &&
        (GlobalUtils.theme == 'dark' || GlobalUtils.theme == 'light')) {
      if (GlobalUtils.theme == 'dark')
        return Container(
          padding: padding,
          decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(radius),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(30, 30, 30, 1),
                  Color.fromRGBO(15, 15, 15, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
          ),
          child: child,
        );
      else {
        return Container(
          padding: padding,
          decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(radius),
              color: Color.fromRGBO(247, 247, 247, 1)
          ),
          child: child,
        );
      }
    } else {
      return BlurryContainer(
        borderRadius:
        borderRadius != null ? borderRadius : BorderRadius.circular(radius),
        bgColor: color == null ? overlayColor() : color,
        blur: blur,
        padding: padding,
        child: child,
      );
    }
  }
}
