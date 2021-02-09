import 'package:flutter/material.dart';

class WorkshopHeader extends StatelessWidget {

  final String title;
  final String subTitle;
  final bool isExpanded;
  final bool isApproved;
  final Function onTap;
  const WorkshopHeader({
    this.title,
    this.subTitle = '',
    this.isExpanded,
    this.isApproved = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Visibility(
                  visible: isApproved,
                  child: InkWell(
                    child: Icon(
                      this.isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                    onTap: () {
                      this.onTap();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
