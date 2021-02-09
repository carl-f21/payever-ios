import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/collection_item_image_view.dart';

class CollectionGridItem extends StatelessWidget {
  final CollectionListModel collection;
  final Function onTap;
  final Function onCheck;
  final bool addCollection;

  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  CollectionGridItem(
      this.collection, {
        this.onTap,
        this.onCheck,
        this.addCollection = false,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Color.fromRGBO(0, 0, 0, 0.3)
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            addCollection ? Container() : Container(
              padding: EdgeInsets.only(top: 16, left: 24),
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  onCheck(collection);
                },
                child: collection.isChecked
                    ? Icon(Icons.check_circle, color: Colors.white,)
                    : Icon(Icons.radio_button_unchecked, color: Colors.white54,),
              ) ,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () {
                    onTap(collection);
                  },
                  child: CollectionItemImage(
                    collection.collectionModel.image,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Text(
                    collection.collectionModel.name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}