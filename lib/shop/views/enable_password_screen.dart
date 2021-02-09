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

class EnablePasswordScreen extends StatefulWidget {

  final ShopScreenBloc screenBloc;
  final String businessId;
  final ShopDetailModel detailModel;

  EnablePasswordScreen({
    this.screenBloc,
    this.businessId,
    this.detailModel,
  });

  @override
  createState() => _EnablePasswordScreenState();
}

class _EnablePasswordScreenState extends State<EnablePasswordScreen> {
  String imageBase = Env.storage + '/images/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController visitorController = TextEditingController();
  bool isError = false;
  bool isButtonPressed = false;
  bool buttonEnabled = false;
  bool isPrivate = false;

  @override
  void initState() {
    isPrivate = widget.detailModel.accessConfig.isPrivate ?? false;

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
      title: Row(
        children: <Widget>[
          Text(
            'Password',
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
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Enable the password to restrict access to your online store Only customers with the password can access it'
                ),
              ),
              Container(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextFormField(
                    controller: passwordController,
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
                        return 'Password should not be empty';
                      } else {
                        isError = false;
                        return null;
                      }
                    },
                    decoration: new InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      contentPadding: _isTablet
                          ? EdgeInsets.all(
                          Measurements.height * 0.007)
                          : null,
                    ),
                    obscureText: true,
                    style: TextStyle(fontSize: 16),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              Divider(height: 0, thickness: 0.5, color: Colors.white54,),
              Container(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    controller: visitorController,
                    decoration: new InputDecoration(
                      hintText: 'Message for visitors',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16),
                    keyboardType: TextInputType.text,
                    // maxLines: 2,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () {
                    setState(() {
                      isPrivate = !isPrivate;
                    });
                  },
                  leading: isPrivate
                      ? Icon(Icons.check_box)
                      : Icon(Icons.check_box_outline_blank),
                  title: Text(
                    'Enable password',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: buttonEnabled ? () async {
                      AccessConfig config = state.activeShop.accessConfig;
                      config.privateMessage = visitorController.text;
                      config.privatePassword = passwordController.text;
                      config.isPrivate = isPrivate;
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

