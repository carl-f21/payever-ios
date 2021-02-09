import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/product_item_image_view.dart';
import 'package:payever/theme.dart';

class ProductGridItem extends StatelessWidget {
  final ProductListModel product;
  final Function onTap;
  final Function onCheck;
  final Function onTapMenu;

  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  ProductGridItem(
      this.product, {
        this.onTap,
        this.onCheck,
        this.onTapMenu,
      });

  @override
  Widget build(BuildContext context) {

    String category = '';
    List<Categories> categories = product.productsModel.categories;
    if (categories.length > 0) {
      category = categories.first.title;
    }
    bool isPos = false;
    bool isShop = false;
    List<ChannelSet> channelSets = product.productsModel.channels;
    if (channelSets.length > 0) {
      channelSets.forEach((element) {
        if (element.type == 'pos') {
          isPos = true;
        }
        if (element.type == 'shop') {
          isShop = true;
        }
      });
    }
    return Container(
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
              child: Stack(
                children: <Widget>[
                  ProductItemImage(
                    product.productsModel.images.isEmpty ? null : product.productsModel.images.first,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 4, left: 4),
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        onCheck(product);
                      },
                      child: product.isChecked
                          ? Icon(Icons.check_circle, color: Colors.black54,)
                          : Icon(Icons.radio_button_unchecked, color: Colors.black54,)
                    ) ,
                  ),
                ],
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
                        product.productsModel.title,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                        ),
                        maxLines: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3, bottom: 1),
                        child: Text(
                          '${formatter.format(product.productsModel.price)} ${Measurements.currency(product.productsModel.currency)}',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Text(
                        product.productsModel.onSales
                            ? Language.getProductListStrings('filters.quantity.options.outStock')
                            : Language.getProductListStrings('filters.quantity.options.inStock'),
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Colors.white54,
            ),
            AspectRatio(
              aspectRatio: 6/1,
              child: Container(              
                child: InkWell(
                  onTap: (){
                    onTap(product);
                  },
                  child: Center(child: Text('Open', style: TextStyle(fontSize: 12),)),
                ),
              ),
            ),
          ],
      ),
    );
  }
}