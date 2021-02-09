
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/connect/views/connect_add_reviews_screen.dart';
import 'package:payever/connect/widgets/connect_top_button.dart';
import 'package:payever/theme.dart';

class ConnectReviewsScreen extends StatefulWidget {
  final ConnectIntegration connectModel;
  final ConnectDetailScreenBloc screenBloc;
  final bool installed;

  ConnectReviewsScreen({
    this.connectModel,
    this.screenBloc,
    this.installed = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _ConnectReviewsScreenState();
  }
}

class _ConnectReviewsScreenState extends State<ConnectReviewsScreen> {
  bool _isPortrait;
  bool _isTablet;

  double iconSize;
  double margin;
  List<ConnectPopupButton> uninstallPopUp(BuildContext context, ConnectScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getConnectStrings('actions.uninstall'),
        onTap: () async {
        },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, ConnectDetailScreenState state) async {
        if (state is ConnectDetailScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ConnectDetailScreenBloc, ConnectDetailScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ConnectDetailScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: _getBody(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(ConnectDetailScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            Language.getPosConnectStrings(widget.connectModel.displayOptions.title),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
            maxHeight: 32,
            maxWidth: 32,
            minHeight: 32,
            minWidth: 32,
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(ConnectDetailScreenState state) {
    String iconType = state.editConnect.displayOptions.icon ?? '';
    iconType = iconType.replaceAll('#icon-', '');
    iconType = iconType.replaceAll('#', '');
    String imageUrl = state.editConnect.installationOptions.links.length > 0
        ? state.editConnect.installationOptions.links.first.url ?? '': '';

    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;
    double rate = 0;
    List<ReviewModel> reviews = state.editConnect.reviews;
    if (reviews.length > 0) {
      double sum = 0;
      reviews.forEach((element) {
        sum = sum + element.rating;
      });
      rate = sum / reviews.length;
    }
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(margin),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: margin),
                    child: SvgPicture.asset(
                      Measurements.channelIcon(iconType),
                      width: iconSize,
                      color: iconColor(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      Language.getPosConnectStrings(state.editConnect.displayOptions.title),
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeueMed',
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      Language.getPosConnectStrings(state.editConnect.installationOptions.price),
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeueLight',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      Language.getPosConnectStrings(state.editConnect.installationOptions.developer),
                                      style: TextStyle(
                                        fontFamily: 'Helvetica Neue',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: margin,
              thickness: 0.5,
              endIndent: margin,
              indent: margin,
            ),

            _ratingView(state),

          ],
        ),
      ),
    );
  }

  Widget _ratingView(ConnectDetailScreenState state) {
    double rate = 0;
    List<ReviewModel> reviews = state.editConnect.reviews;
    if (reviews.length > 0) {
      double sum = 0;
      reviews.forEach((element) {
        sum = sum + element.rating;
      });
      rate = sum / reviews.length;
    }
    int count = 1;
    if (_isTablet) {
      if (_isPortrait) {
        count = 2;
      } else {
        count = 3;
      }
    } else {
      if (_isPortrait) {
        count = 1;
      } else {
        count = 2;
      }
    }
    int length = 2;
    if (_isTablet) {
      length = count;
    } else {
      length = 2;
    }

    return Container(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Language.getConnectStrings('Ratings & Reviews'),
                style: TextStyle(
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 18,
                ),
              ),
              widget.installed ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ConnectAddReviewsScreen(
                        screenBloc: widget.screenBloc,
                        connectIntegration: widget.connectModel,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Text(
                  Language.getConnectStrings('Write Review'),
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 14,
                  ),
                ),
              ): Container(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: margin / 2),
          ),
          reviews.length > 0 ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              rate > 0 ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '$rate',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeueMed',
                      fontSize: 60,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      'out of 5',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueBold',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ): Container(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${reviews.length} Ratings',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 14,
                    ),
                  ),
                  !_isTablet && _isPortrait ? Container() : Padding(
                    padding: EdgeInsets.only(right: margin / 2),
                  ),
                  !_isTablet && _isPortrait ? Container() : _allRateView(state),
                ],
              ),
            ],
          ): Container(
            child: Text(
              'No Ratings',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'HelveticaNeueMed',
              ),
            ),
          ),
          !_isTablet && _isPortrait ? _allRateView(state): Container(),
          Flexible(
            fit: FlexFit.loose,
            child: reviews.length == 0 ? Container(): GridView.count(
              padding: EdgeInsets.only(top: 16,),
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: margin,
              shrinkWrap: true,
              childAspectRatio: 3,
              crossAxisCount: count,
              children: reviews.map((review) {
                return Container(
                  height: 200,
                  padding: EdgeInsets.all(margin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: overlayBackground(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                review.title ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'HelveticaNeueMed',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: margin / 4),
                              ),
                              _rateView(review.rating),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                review.reviewDate ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Helvetica Neue',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: margin / 4),
                              ),
                              Text(
                                review.userFullName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Helvetica Neue',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: margin / 2),
                      ),
                      Text(
                        review.text ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList().sublist(0, reviews.length > length ? length: reviews.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateView(num rate) {
    return Container(
      child: Row(
          children: List.generate(5, (index) {
            return Container(
              child: SvgPicture.asset(
                index < rate ? 'assets/images/star_fill.svg'
                    : 'assets/images/star_outline.svg',
                width: 14,
                height: 14,
                color: iconColor(),
              ),
            );
          }).toList()
      ),
    );
  }

  Widget _allRateView(ConnectDetailScreenState state) {
    double width = Measurements.width;
    if (!_isTablet) {
      width = Measurements.width - margin * 6;
    } else {
      width = (Measurements.width - margin * 4) / 2;
    }
    List<Map<int, double>> percents = [];
    List<ReviewModel> reviews = state.editConnect.reviews;
    List.generate(5, (index) {
      num count = 0;
      reviews.forEach((element) {
        if (element.rating == (index + 1)) {
          count++;
        }
      });
      percents.add({
        index + 1: count.toDouble() / reviews.length.toDouble()
      });
    });
    percents = percents.reversed.toList();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: percents.map((p) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: List.generate(p.keys.toList().first, (index) {
                    return SvgPicture.asset(
                      'assets/images/star_fill.svg',
                      width: margin / 2,
                      height: margin / 2,
                      color: iconColor(),
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(right: margin / 2),
                ),
                Container(
                  width: width,
                  child: SizedBox(
                    height: margin / 5,
                    child: LinearProgressIndicator(
                      value: p.values.first,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

}