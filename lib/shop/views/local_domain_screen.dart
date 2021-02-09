import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';

bool _isPortrait;
bool _isTablet;

class LocalDomainScreen extends StatefulWidget {

  final ShopScreenBloc screenBloc;
  final String businessId;
  final ShopDetailModel detailModel;

  LocalDomainScreen({
    this.screenBloc,
    this.businessId,
    this.detailModel,
  });

  @override
  createState() => _LocalDomainScreenState();
}

class _LocalDomainScreenState extends State<LocalDomainScreen> {
  String imageBase = Env.storage + '/images/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  final TextEditingController domainTextController = TextEditingController();
  bool isError = false;
  bool isButtonPressed = false;
  bool buttonEnabled = false;

  @override
  void initState() {
    if (widget.detailModel.accessConfig.internalDomain != null) {
      domainTextController.text = widget.detailModel.accessConfig.internalDomain;
    }
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
      listener: (BuildContext context, ShopScreenState state) async {
        if (state is ShopScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is ShopScreenStateSuccess) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<ShopScreenBloc, ShopScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ShopScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(ShopScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Local Domain',
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

  Widget _body(ShopScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: Form(
            key: formKey,
            autovalidate: false,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                width: Measurements.width,
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
        ),
      ),
    );
  }

  Widget _getBody(ShopScreenState state) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: BlurEffectView(
          radius: 12,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Wrap(
            children: <Widget>[
              Container(
                  height: 72,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            height: 50,
                            child: BlurEffectView(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: TextFormField(
                                controller: domainTextController,
                                onSaved: (val) {},
                                onChanged: (val) {
                                  setState(() {
                                    buttonEnabled = val.isNotEmpty;
                                  });
                                  isButtonPressed = false;
                                  if (isError) {
                                    formKey.currentState.validate();
                                  }
                                },
                                onFieldSubmitted: (val) {
                                  if (formKey.currentState.validate()) {
                                  }
                                },
                                validator: (value) {
                                  if (!isButtonPressed) {
                                    return null;
                                  }
                                  isError = true;
                                  if (value.isEmpty) {
                                    return 'Domain required';
                                  } else {
                                    isError = false;
                                    return null;
                                  }
                                },
                                decoration: new InputDecoration(
                                  hintText: "Domain",
                                  border: InputBorder.none,
                                  contentPadding: _isTablet
                                      ? EdgeInsets.all(
                                      Measurements.height * 0.007)
                                      : null,
                                ),
                                style: TextStyle(fontSize: 16),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            '.new.payever.shop',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              ),
              Container(
                height: 50,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: buttonEnabled ? () async {
                      AccessConfig config = state.activeShop.accessConfig;
                      config.internalDomain = domainTextController.text;
                      widget.screenBloc.add(
                        UpdateShopSettings(
                          businessId: widget.businessId,
                          shopId: state.activeShop.id,
                          config: config,
                        ),
                      );
                      await Future.delayed(const Duration(milliseconds: 500)).then((value) {
                        Navigator.pop(context);
                      });
                    } : null,
                    color: overlayBackground(),
                    child: state.isUpdating ? Center(
                      child: CircularProgressIndicator(),
                    ) : Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitTerminal(ShopScreenState state) {
  }

}

