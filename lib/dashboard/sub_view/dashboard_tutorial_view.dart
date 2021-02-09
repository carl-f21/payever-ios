import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/tutorial_cell.dart';
import 'package:payever/theme.dart';

class DashboardTutorialView extends StatefulWidget {
  final List<Tutorial> tutorials;
  final Function onWatchTutorial;
  DashboardTutorialView({
    this.tutorials,
    this.onWatchTutorial,
  });
  @override
  _DashboardTutorialViewState createState() => _DashboardTutorialViewState();
}

class _DashboardTutorialViewState extends State<DashboardTutorialView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
      isDashboard: true,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TUTORIALS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Container(
                        width: 21,
                        height: 21,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.5),
                            color: overlayDashboardButtonsBackground(),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            isExpanded ? 'assets/images/closeicon.svg' : 'assets/images/icon_plus.svg',
                            width: 8,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  height: widget.tutorials.length > 0 ? 80.0: 0,
                  child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                    return TutorialCell(
                      tutorial: widget.tutorials[index],
                      showUnderline: index == 0,
                      watchTutorial: (Tutorial tutorial) {
                        widget.onWatchTutorial(tutorial);
                      },
                    );
                  }, itemCount: widget.tutorials.length > 0 ? 2: 0,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          (isExpanded && widget.tutorials != null && widget.tutorials.length > 2) ?
            Container(
              height: 40.0 * (widget.tutorials.length - 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                  color: overlayBackground(),
              ),
              child: ListView.builder(
                itemBuilder: _itemBuilder,
                itemCount: widget.tutorials.length - 2,
                physics: NeverScrollableScrollPhysics(),
              ),
            ):
            Container(),
        ],
      ),
    );
  }
  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: TutorialCell(
        tutorial: widget.tutorials[index + 2],
        showUnderline: index != widget.tutorials.length - 3,
        watchTutorial: (Tutorial tutorial) {
          widget.onWatchTutorial(tutorial);
        },
      ),
    );
  }

}
