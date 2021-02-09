import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';

bool _isPortrait;
bool _isTablet;

List<String> dropdownItems = [
  'Verify by code',
  'Verify by ID',
];
class CheckoutDevicePaymentScreen extends StatefulWidget {

  final CheckoutScreenBloc screenBloc;

  CheckoutDevicePaymentScreen({
    this.screenBloc,
  });

  @override
  createState() => _CheckoutDevicePaymentScreenState();
}

class _CheckoutDevicePaymentScreenState extends State<CheckoutDevicePaymentScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  String selectedState = '';
  bool isOpened = true;

  @override
  void initState() {
    widget.screenBloc.add(GetDevicePaymentSettings());
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
      listener: (BuildContext context, CheckoutScreenState state) async {
        if (state is PosScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(CheckoutScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Device Payment',
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

  Widget _body(CheckoutScreenState state) {
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
          ): Column(
            children: <Widget>[
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(CheckoutScreenState state) {
    if (state.devicePaymentSettings == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: isOpened ? 64 * 5.0: 64.0,
        child: BlurEffectView(

          blur: 15,
          radius: 12,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: <Widget>[
              Container(
                height: 64,
                color: overlayBackground(),
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        isOpened = !isOpened;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.settings,
                              size: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          isOpened ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isOpened ? Divider(
                color: Colors.white30,
                height: 0,
                thickness: 0.5,
              ): Container(),
              isOpened ? Container(
                  height: 64,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Two Factor Authentication',//displayOptions.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: state.devicePaymentSettings.secondFactor,
                            onChanged: (value) {
                              DevicePaymentSettings settings = state.devicePaymentSettings;
                              settings.secondFactor = value;
                              widget.screenBloc.add(UpdateCheckoutDevicePaymentSettings(settings: settings));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
              ): Container(),
              isOpened ? Divider(
                color: Colors.white30,
                height: 0,
                thickness: 0.5,
              ): Container(),
              isOpened ? Container(
                  height: 64,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          Language.getConnectStrings('categories.communications.form.autoresponderEnabled.label'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: state.devicePaymentSettings.autoresponderEnabled,
                            onChanged: (value) {
                              DevicePaymentSettings settings = state.devicePaymentSettings;
                              settings.autoresponderEnabled = value;
                              widget.screenBloc.add(UpdateCheckoutDevicePaymentSettings(settings: settings));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
              ): Container(),
              isOpened ? Divider(
                color: Colors.white30,
                height: 0,
                thickness: 0.5,
              ): Container(),
              isOpened ? Container(
                  height: 64,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                        ),
                        Text(
                          'verify type:',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            icon: Container(),
                            underline: Container(),
                            isExpanded: true,
                            value: dropdownItems[state.devicePaymentSettings.verificationType],
                            onChanged: (value) {
                              DevicePaymentSettings settings = state.devicePaymentSettings;
                              settings.verificationType = dropdownItems.indexOf(value, 0);
                              widget.screenBloc.add(UpdateCheckoutDevicePaymentSettings(settings: settings));
                            },
                            items: dropdownItems.map((label) => DropdownMenuItem(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              value: label,
                            ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
              ): Container(),
              isOpened ? Divider(
                color: Colors.white30,
                height: 0,
                thickness: 0.5,
              ): Container(),
              isOpened ? Container(
                height: 64,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      widget.screenBloc.add(SaveCheckoutDevicePaymentSettings());
                    },
                    color: overlayBackground(),
                    child: state.isUpdating ? Container(
                      child: CircularProgressIndicator(),
                    ) : Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ): Container(),
            ],
          ),
        ),
      ),
    );
  }
}

