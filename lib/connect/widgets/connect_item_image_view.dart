import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/theme.dart';

class ConnectItemImageView extends StatelessWidget {
  final String imageURL;
  final File imageFile;

  ConnectItemImageView(this.imageURL, {this.imageFile});

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return Container(
        child: Image.file(imageFile),
      );
    } else {
      if (imageURL != null) {
        return CachedNetworkImage(
          imageUrl: imageURL,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
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
            child: SvgPicture.asset('assets/images/no_image.svg', color: overlayBackground(), width: 100, height: 100,),
          ),
        );
      } else {
        return Container(
          child: SvgPicture.asset('assets/images/no_image.svg', color: overlayBackground(), width: 100, height: 100,),
        );
      }
    }
  }
}
