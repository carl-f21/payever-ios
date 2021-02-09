import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';

class SearchResultTransactionView extends StatelessWidget {

  final Collection collection;
  final Function onTap;

  SearchResultTransactionView({this.collection, this.onTap,});

  @override
  Widget build(BuildContext context) {
    String currency = collection.currency;
    final numberFormat = NumberFormat();
    String symbol = numberFormat.simpleCurrencySymbol(currency);
    return InkWell(
      onTap: () {
        onTap(collection);
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          collection.originalId,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              collection.customerName,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Text(
                              '$symbol${collection.total}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
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