import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';

class CheckoutChannelSetScreen extends StatefulWidget {

  final CheckoutScreenBloc checkoutScreenBloc;
  final String business;
  final String category;
  final String checkoutId;

  CheckoutChannelSetScreen({
    this.checkoutScreenBloc,
    this.business,
    this.category,
    this.checkoutId,
  });

  @override
  _CheckoutChannelSetScreenState createState() => _CheckoutChannelSetScreenState();
}

class _CheckoutChannelSetScreenState extends State<CheckoutChannelSetScreen> {
  bool _isPortrait;
  bool _isTablet;
  double iconSize;
  double margin;

  CheckoutChannelSetScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = CheckoutChannelSetScreenBloc(checkoutScreenBloc: widget.checkoutScreenBloc);
    screenBloc.add(CheckoutChannelSetScreenInitEvent(business: widget.business, type: widget.category,));
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
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
      bloc: screenBloc,
      listener: (BuildContext context, CheckoutChannelSetScreenState state) async {
        if (state is CheckoutChannelSetScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutChannelSetScreenBloc, CheckoutChannelSetScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutChannelSetScreenState state) {
          iconSize = _isTablet ? 120: 80;
          margin = _isTablet ? 24: 16;
          return Scaffold(
            backgroundColor: Colors.black,
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
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: _getBody(state),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(CheckoutChannelSetScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getCommerceOSStrings('dashboard.apps.${widget.category}'),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
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

  Widget _getBody(CheckoutChannelSetScreenState state) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ChannelSet channelSet = state.channelSets[index];
                    return Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: margin / 2),
                                ),
                                Flexible(
                                  child: Text(
                                    channelSet.name ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Helvetica Neue',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: channelSet.checkout == widget.checkoutId,
                              onChanged: (val) {
                                screenBloc.add(UpdateChannelSet(
                                  channelSet: channelSet,
                                  checkoutId: widget.checkoutId,
                                ));
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Colors.white70,
                    );
                  },
                  itemCount: state.channelSets.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}