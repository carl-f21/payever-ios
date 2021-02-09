import 'package:flutter/material.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/utils/env.dart';

class AppWidgetCell extends StatelessWidget {
  final AppWidget appWidget;
  final Function onTap;

  AppWidgetCell({this.appWidget, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(appWidget);
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              '${Env.cdnIcon}${appWidget.icon}',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}