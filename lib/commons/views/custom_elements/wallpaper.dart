import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:payever/theme.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../../view_models/view_models.dart';

class BackgroundBase extends StatefulWidget {
  final bool _isBlur;
  final Widget body, endDrawer, bottomNav;
  final AppBar appBar;
  final Key currentKey;
  final String wallPaper;
  final Color backgroundColor;

  BackgroundBase(this._isBlur, {
    this.body,
    this.endDrawer,
    this.bottomNav,
    this.appBar,
    this.currentKey,
    this.wallPaper,
    this.backgroundColor,
  });

  @override
  _BackgroundBaseState createState() => _BackgroundBaseState();
}

class _BackgroundBaseState extends State<BackgroundBase> {
  GlobalStateModel globalStateModel;

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);
    return Stack(
        //overflow: Overflow.visible,
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            top: 0.0,
            child: Container(
              child: CachedNetworkImage(
                imageUrl: widget._isBlur
                    ? widget.wallPaper != null ? '${widget.wallPaper}-blurred': globalStateModel.currentWallpaperBlur
                    : widget.wallPaper != null ? widget.wallPaper: globalStateModel.currentWallpaper,
                placeholder: (context, url) => Center(
                  child: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (FocusScope.of(context).hasFocus) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Container(
              height: Measurements.height,
              width: Measurements.width,
              child: Scaffold(
                key: widget.currentKey,
                backgroundColor: widget.backgroundColor != null ? widget.backgroundColor: overlayColor(),
                appBar: widget.appBar,
                endDrawer: widget.endDrawer,
                body: widget.body,
                bottomNavigationBar: widget.bottomNav,
              ),
            ),
          )
        ],
    );
  }
}
