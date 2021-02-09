import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/products/models/models.dart';

class ProductCell extends StatelessWidget {
  final Products product;
  final Business business;
  final Function onTap;

  ProductCell({
    this.product,
    this.business,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String currency = '';
    NumberFormat format = NumberFormat();
    if (business != null) {
      currency = format.simpleCurrencySymbol(business.currency);
    }
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          onTap(product);
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            (product.thumbnail != null && product.thumbnail.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: '${Env.storage}/products/${product.thumbnail}',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    color: Colors.white,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child: Center(
                        child: Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 0.8,
                          child: SvgPicture.asset(
                            'assets/images/no_image.svg',
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 0.8,
                        child: SvgPicture.asset(
                          'assets/images/no_image.svg',
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
//            Container(
//              width: double.infinity,
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.only(
//                    bottomLeft: Radius.circular(8.0),
//                    bottomRight: Radius.circular(8.0),
//                  ),
//                  gradient: LinearGradient(
//                    colors: [
//                      Colors.transparent,
//                      Color.fromRGBO(0, 0, 0, 1)
//                    ],
//                    begin: Alignment.topCenter,
//                    end: Alignment.bottomCenter,
//                  )),
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  SizedBox(height: 14),
//                  Text(
//                    product.name,
//                    softWrap: true,
//                    maxLines: 1,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 12,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                  Text(
//                    '$currency${product.price}',
//                    softWrap: true,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      color: Colors.grey[500],
//                      fontSize: 12,
//                    ),
//                  ),
//                  SizedBox(height: 4),
//                ],
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
