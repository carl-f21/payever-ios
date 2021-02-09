import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CheckoutTopButton extends StatelessWidget {
  final Function onTap;
  final int selectedIndex;
  final String title;
  final int index;

  CheckoutTopButton({
    Key key,
    this.onTap,
    this.selectedIndex = 0,
    this.title = '',
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final makeContent = InkWell(
      child: Material(
        color: index == selectedIndex ? Colors.white10: Colors.transparent,
        child: index == 0 ? Container(
          height: 44,
          constraints:  BoxConstraints(minWidth: 40, maxWidth: 120),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 8, right: 8),
          child: AutoSizeText(
            title,
            minFontSize: 8,
            maxLines: 2,
            maxFontSize: 14,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ): Container(
          height: 44,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
    return makeContent;
  }
}

class CheckOutPopupButton {
  final String title;
  final Color textColor;
  final Function onTap;
  final Widget icon;

  CheckOutPopupButton({
    this.title,
    this.textColor = Colors.black,
    this.onTap,
    this.icon,
  });
}