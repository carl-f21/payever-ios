import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/theme.dart';

class CollectionDetailImageView extends StatelessWidget {
  final String imageURL;
  final bool isUploading;
  final List<ProductsModel> products;

  CollectionDetailImageView(this.imageURL, {this.products = const[], this.isUploading = false});

  @override
  Widget build(BuildContext context) {
      if (imageURL != '') {
        return CachedNetworkImage(
          imageUrl: '${Env.storage}/products/$imageURL',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
          color: Colors.white,
          placeholder: (context, url) => Container(
            child: Center(
              child: Container(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) =>  Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/no_image.svg',
                color: Colors.black54,
                width: 100,
                height: 100,
              ),
            ),
          ),
        );
      } else {
        List<String> productsImages = [];
        products.forEach((element) {
          if (productsImages.length < 3) {
            if (element.images.length > 0) {
              productsImages.add(element.images.first);
            }
          }
        });
        if (productsImages.length > 0) {
          return Stack(
            children: <Widget>[
              productsImages.length > 0 ? Container(
                padding: EdgeInsets.only(bottom: Measurements.width * 0.2, right: Measurements.width * 0.2),
                child: CachedNetworkImage(
                  imageUrl: '${Env.storage}/products/${productsImages[0]}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ): Container(),
              productsImages.length > 1 ? Container(
                padding: EdgeInsets.only(left: Measurements.width * 0.1, right: Measurements.width * 0.1),
                child: CachedNetworkImage(
                  imageUrl: '${Env.storage}/products/${productsImages[1]}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ): Container(),
              productsImages.length > 2 ? Container(
                padding: EdgeInsets.only(left: Measurements.width * 0.2, top: Measurements.width * 0.2),
                child: CachedNetworkImage(
                  imageUrl: '${Env.storage}/products/${productsImages[2]}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ): Container(),
            ],
          );
        } else {
          return Container(
            height: Measurements.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            alignment: Alignment.center,
            child: isUploading ? Container(
              child: Center(child: CircularProgressIndicator()),
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset('assets/images/insertimageicon.svg', color: iconColor(),),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                ),
                Text(
                  'Upload image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }
      }
  }
}
