import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/product_item_image_view.dart';
import 'package:payever/theme.dart';

class PosProductGridItem extends StatelessWidget {
  final ProductsModel product;
  final Function onTap;

  final formatter = new NumberFormat('###,###,###.00', 'en_US');
  PosProductGridItem(
      this.product, {
        this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(product);
      },
      child: Container(
        margin: EdgeInsets.only(left: 3, right: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: overlayBackground(),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ProductItemImage(
                  product.images.isEmpty ? null : product.images.first,
                ),
              ),
              AspectRatio(
                aspectRatio: 6/1.7,
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AutoSizeText(
                          product.title,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 1),
                          child: Text(
                            '${formatter.format(product.price)} ${Measurements.currency(product.currency)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
        ),
      ),
    );
  }
}