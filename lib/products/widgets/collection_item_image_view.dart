import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/utils/env.dart';

class CollectionItemImage extends StatelessWidget {
  final String imageURL;
  final File imageFile;

  CollectionItemImage(this.imageURL, {this.imageFile});

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
        return Container(
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
        );
      }
    }
  }
}
