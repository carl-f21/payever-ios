import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/theme.dart';
import 'package:badges/badges.dart';

class PersonalDashboardSocialView extends StatefulWidget {
  final Function onTapEdit;
  final Function onTapWidget;

  PersonalDashboardSocialView({
    this.onTapEdit,
    this.onTapWidget,
  });

  @override
  _PersonalDashboardSocialViewState createState() =>
      _PersonalDashboardSocialViewState();
}

class _PersonalDashboardSocialViewState
    extends State<PersonalDashboardSocialView> {
  Map<String, dynamic> socials = {
    'Facebook': 'assets/images/fb.svg',
    'Pinterest': 'assets/images/pinterest-logo.svg',
    'WhatsApp': 'assets/images/whatsapp.svg',
    'Twitter': 'assets/images/twitter.svg',
    'Instagram': 'assets/images/ig.svg',
    'LinkedIn': 'assets/images/linkedin.svg'
  };

  @override
  Widget build(BuildContext context) {
    return BlurEffectView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      isDashboard: true,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: widget.onTapEdit,
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  'SOCIAL',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),
            _gridView(),
          ],
        ),
      ),
    );
  }

  Widget _gridView() {
    bool isTablet = GlobalUtils.isTablet(context);
    int crossAxisCount = isTablet ? 6 : 4;
    int columnCount = socials.length ~/ crossAxisCount + ((socials.length % crossAxisCount == 0) ? 0 : 1);
    double height = columnCount * 86.0 + (columnCount - 1) * 30.0;
    return Container(
      height: height,
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 0,
        crossAxisSpacing: (GlobalUtils.mainWidth - 64 - 68 * crossAxisCount) / (crossAxisCount - 1),
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        childAspectRatio: 10 / 16,
        children: List.generate(socials.length, (index) {
          return _socialItem(index);
        }).toList(),
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _socialItem(int index) {
    String title, image;
    title = socials.keys.toList()[index];
    image = socials[title];
    String badgCount = '0';
    Color bgColor;
    switch (index) {
      case 0:
        bgColor = Color.fromRGBO(59, 104, 181, 1);
        badgCount = '2';
        break;
      case 1:
        bgColor = Color.fromRGBO(200, 38, 31, 1);
        break;
      case 2:
        bgColor = Color.fromRGBO(37, 211, 102, 1);
        break;
      case 3:
        bgColor = Color.fromRGBO(29, 161, 242, 1);
        break;
      case 4:
        bgColor = Color.fromRGBO(241, 25, 118, 1);
        break;
      case 5:
        badgCount = '1';
        bgColor = Color.fromRGBO(0, 119, 181, 1);
        break;
    }

    return Container(
      width: 68,
      height: 86,
      padding: const EdgeInsets.only(top: 8.0, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Badge(
            badgeContent: Text(badgCount),
            showBadge: badgCount != '0',
            padding: EdgeInsets.all(GlobalUtils.isTablet(context) ? 10 : 5),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bgColor,
                ),
                child: SvgPicture.asset(image),
              ),
            ),
          ),
          SizedBox(height: 11,),
          AutoSizeText(title, style: TextStyle(fontSize: 14, color: Color.fromRGBO(238, 238, 238, 1)), maxLines: 1, minFontSize: 8,),
        ],
      ),
    );
  }
}
