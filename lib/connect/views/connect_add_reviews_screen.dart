
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
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/theme.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class ConnectAddReviewsScreen extends StatefulWidget {
  final ConnectIntegration connectIntegration;
  final ConnectDetailScreenBloc screenBloc;

  ConnectAddReviewsScreen({
    this.connectIntegration,
    this.screenBloc,
  });

  @override
  State<StatefulWidget> createState() {
    return _ConnectAddReviewsScreenState();
  }
}

class _ConnectAddReviewsScreenState extends State<ConnectAddReviewsScreen> {
  bool _isPortrait;
  bool _isTablet;

  double iconSize;
  double margin;
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  FocusNode textFocus = FocusNode();

  double rate = 0;

  @override
  void initState() {
    super.initState();
    List<ReviewModel> reviews = widget.connectIntegration.reviews;
    String userId = widget.screenBloc.connectScreenBloc.dashboardScreenBloc.state.activeBusiness.userId;
    List<ReviewModel> userReviews = reviews.where((element) {
      print(userId);
      print(element.userId);
      return element.userId == userId;
    }).toList();
    if (userReviews.length > 0) {
      setState(() {
        rate = userReviews.first.rating.toDouble();
        titleController.text = userReviews.first.title ?? '';
        textController.text = userReviews.first.text ?? '';
      });
    }
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
        if (state.isReview) {
          showReviewedDialog();
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
            Language.getPosConnectStrings(widget.connectIntegration.displayOptions.title),
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
    String iconType = widget.connectIntegration.displayOptions.icon ?? '';
    iconType = iconType.replaceAll('#icon-', '');
    iconType = iconType.replaceAll('#', '');
    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;
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

            _formField(state),

            Padding(
              padding: EdgeInsets.all(margin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      widget.screenBloc.add(AddReviewEvent(
                        title: titleController.text,
                        text: textController.text,
                        rate: rate,
                      ));
                    },
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                    height: 26,
                    minWidth: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    elevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    child: Text(
                      Language.getConnectStrings('actions.submit'),
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueMed',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: margin),
                  ),
                  MaterialButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                    height: 26,
                    minWidth: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    elevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    child: Text(
                      Language.getConnectStrings('Cancel'),
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueMed',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingView(ConnectDetailScreenState state) {
    return Container(
      child: SmoothStarRating(
          allowHalfRating: false,
          onRated: (v) {
            setState(() {
              if (v < 1) {
                rate = 1;
              } else {
                rate = v;
              }
            });
          },
          starCount: 5,
          rating: rate,
          size: margin * 2,
          isReadOnly: false,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          color: iconColor(),
          borderColor: iconColor(),
          spacing:0.0
      ),
    );
  }

  Widget _formField(ConnectDetailScreenState state) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(margin / 2),
                topRight: Radius.circular(margin / 2),
              ),
              color: overlayBackground(),
            ),
            child: TextField(
              controller: titleController,
              focusNode: titleFocus,
              decoration: new InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(margin / 2),
              ),
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Helvetica Neue',
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(margin / 2),
                bottomLeft: Radius.circular(margin / 2),
              ),
              color: overlayBackground(),
            ),
            child: TextField(
              controller: textController,
              focusNode: textFocus,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: new InputDecoration(
                hintText: 'Description',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(margin / 2),
              ),
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Helvetica Neue',
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }

  void showReviewedDialog() {
    widget.screenBloc.add(ClearEvent());
    showCupertinoDialog(
      context: context,
      builder: (builder) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 250,
            width: Measurements.width * 0.8,
            child: BlurEffectView(
              color: Color.fromRGBO(50, 50, 50, 0.4),
              padding: EdgeInsets.all(margin / 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(margin / 2),
                  ),
                  Icon(Icons.info),
                  Padding(
                    padding: EdgeInsets.all(margin / 2),
                  ),
                  Text(
                    'Submitted, thanks for your feedback',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Helvetica Neue',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(margin / 2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 24,
                        elevation: 0,
                        minWidth: 0,
                        color: Colors.white10,
                        child: Text(
                          Language.getConnectStrings('Confirm'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
