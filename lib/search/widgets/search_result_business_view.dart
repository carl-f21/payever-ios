import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

class SearchResultBusinessView extends StatelessWidget {

  final Business business;
  final Function onTap;

  SearchResultBusinessView({this.business, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(business);
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    business.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    business.email,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
            ),
            Icon(Icons.chevron_right, size: 24,),
          ],
        ),
      ),
    );
  }
}