import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/theme.dart';

class ProfileImageView extends StatelessWidget {
  final String imageUrl;
  final double avatarSize;
  final bool isUploading;

  ProfileImageView({this.imageUrl, this.avatarSize = 50, this.isUploading = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: avatarSize,
      width: avatarSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(avatarSize / 2),
        color: iconColor().withOpacity(0.2),
      ),
      child: isUploading ? Container(
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ) : CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: avatarSize,
          width: avatarSize,
          decoration: BoxDecoration(
            color: iconColor(),
            borderRadius: BorderRadius.circular(avatarSize / 2),
            image: DecorationImage(
              image: imageProvider,
            ),
          ),
        ),
        placeholder: (context, url) => Center(
          child: Container(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          return Container(
            height: avatarSize,
            width: avatarSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              color: iconColor(),
            ),
            child: SvgPicture.asset('assets/images/add_contacts.svg', color: overlayColor(),),
          );
        },
      ),
    );
  }
}