import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/theme.dart';

class TutorialCell extends StatelessWidget {
  final Tutorial tutorial;
  final bool showUnderline;
  final Function watchTutorial;

  TutorialCell({this.tutorial, this.showUnderline = false, this.watchTutorial,});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 39,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/images/video.svg', color: iconColor(),),
                  SizedBox(width: 12),
                  Text(
                    tutorial.title ?? '',
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 12),
                ],
              ),
              Row(
                children: [
                  tutorial.watched ? Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SvgPicture.asset('assets/images/icon_eye.svg', color: iconColor().withOpacity(0.5),),
                  ): Container(),
                  InkWell(
                    onTap: () {
                      watchTutorial(tutorial);
                    },
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: overlayDashboardButtonsBackground(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 6),
                          SvgPicture.asset('assets/images/icon_arrow.svg',),
                          SizedBox(width: 4),
                          Text(
                            Language.getWidgetStrings('widgets.tutorial.watch'),
                            style: TextStyle(
                                fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        if (showUnderline) Container(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          height: 1,
          color: Colors.white12,
        ),
      ],
    );
  }
}
