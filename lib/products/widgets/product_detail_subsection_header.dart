import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/theme.dart';

class ProductDetailSubSectionHeaderView extends StatelessWidget {
  final String type;
  final bool isExpanded;
  final Function onTap;

  ProductDetailSubSectionHeaderView({
    this.type,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 16, right: 16),
        color: overlayRow(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                type == 'pos'
                    ? SvgPicture.asset('assets/images/pos.svg', width: 24, height: 24, color: iconColor(),)
                    : SvgPicture.asset('assets/images/shopicon.svg', width: 24, height: 24, color: iconColor(),),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Text(
                  type == 'pos' 
                      ? Language.getCommerceOSStrings('dashboard.apps.pos')
                      : Language.getCommerceOSStrings('dashboard.apps.store'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),

              ],
            ),
            isExpanded ? Icon(
              Icons.remove,
            ): Icon(
              Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}