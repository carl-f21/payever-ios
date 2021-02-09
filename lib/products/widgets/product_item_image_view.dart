import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/utils/env.dart';

class ProductItemImage extends StatelessWidget {
  final String imageURL;
  final File imageFile;

  ProductItemImage(this.imageURL, {this.imageFile});

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.file(imageFile),
      );
    } else {
      if (imageURL != null) {
        return CachedNetworkImage(
          imageUrl: '${Env.storage}/products/$imageURL',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/images/no_image.svg',
              color: Colors.black54,
              width: 100,
              height: 100,
            ),
          ),
        );
      }
    }
  }
}
