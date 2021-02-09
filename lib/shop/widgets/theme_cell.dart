import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

class ThemeCell extends StatelessWidget {
  final ThemeListModel themeListModel;
  final Function onTapInstall;
  final Function onCheck;
  final Function onTapPreview;
  final bool isInstall;
  final String installThemeId;

  ThemeCell({
    this.themeListModel,
    this.onTapInstall,
    this.onCheck,
    this.onTapPreview,
    this.isInstall,
    this.installThemeId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Measurements.width - 38,
      height: (Measurements.width - 38) * 1.8,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                themeListModel.themeModel.picture != null
                    ? CachedNetworkImage(
                        imageUrl:
                            '${Env.storage}${themeListModel.themeModel.picture}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
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
                          color: Colors.white,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/no_image.svg',
                              color: Colors.black54,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/no_image.svg',
                            color: Colors.black54,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                Container(
                  padding: EdgeInsets.only(top: 4, left: 4),
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        onCheck(themeListModel);
                      },
                      child: themeListModel.isChecked
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.black87,
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.black87,
                            )),
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 6/1.7,
            child: Container(
              padding: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
              color: overlayBackground(),
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    themeListModel.themeModel.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    themeListModel.themeModel.type,
                    style: TextStyle(
                      color: Color(0xffff9000),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 6/1,
            child: Container(
              color: Colors.black87,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: onTapPreview,
                      child: Container(child: Center(child: Text('Preview', style: TextStyle(color: Colors.white),))),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Color(0xFF888888),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        onTapInstall(themeListModel.themeModel);
                      },
                      child: Container(
                          child: Center(
                              child: isInstall &&
                                      installThemeId == themeListModel.themeModel.id
                                  ? Container(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text('Install', style: TextStyle(color: Colors.white),))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
