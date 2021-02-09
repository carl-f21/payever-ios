import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';

bool _isPortrait;
bool _isTablet;

class CreateShopScreen extends StatefulWidget {

  final ShopScreenBloc screenBloc;
  final String businessId;
  final bool fromDashBoard;

  CreateShopScreen({
    this.screenBloc,
    this.businessId,
    this.fromDashBoard = false,
  });

  @override
  createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  String imageBase = Env.storage + '/images/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  final TextEditingController shopNameController = TextEditingController();
  bool isError = false;
  bool isButtonPressed = false;
  bool buttonEnabled = false;

  @override
  void initState() {
//    if (widget.editShop != null) {
//      terminalNameController.text = widget.editShop.name;
//      widget.screenBloc.add(UpdateBlobImage(logo: widget.editTerminal.logo));
//    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.fromDashBoard) {
      widget.screenBloc.close();
    }
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
          if (widget.fromDashBoard) {
            Navigator.pop(context, 'refresh');
          } else {
            widget.screenBloc.add(
                ShopScreenInitEvent(
                  currentBusinessId: widget.businessId,
                )
            );
            Navigator.pop(context);
          }
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

  Widget _body(ShopScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: Appbar('Create  Shop'),
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
    String blobName = state.blobName;
    String avatarName = '';
    if (shopNameController.text.isNotEmpty) {
      String name = shopNameController.text;
      if (name.contains(' ') && name.split(' ').length > 1) {
        avatarName = name.substring(0, 1);
        if (name.split(' ')[1].length > 0) {
          avatarName = avatarName + name.split(' ')[1].substring(0, 1);
        } else {
          avatarName = name.substring(0, 1) + name.substring(name.length - 1);
          avatarName = avatarName.toUpperCase();
        }
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 64),
              child: GestureDetector(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    blobName != null
                        ? Center(
                      child: CircleAvatar(
                        minRadius: 40,
                        maxRadius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage: Image.network('$imageBase$blobName').image,
                      ),
                    ): CircleAvatar(
                      minRadius: 40,
                      backgroundColor: Colors.grey,
                      child: Container(
                        child: Text(
                          avatarName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    state.isUploading
                        ? Center(
                      child: Container(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                        : Container(),
                  ],
                ),
                onTap: () async {
                  getImage();
                },
              ),
            ),
            BlurEffectView(
              radius: 12,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: <Widget>[
                  Container(
                      height: 72,
                      padding: EdgeInsets.all(12),
                      child: Container(
                        child: Container(
                          height: 60,
                          child: BlurEffectView(
                            blur: 15,
                            radius: 12,
                            child: TextFormField(
                              controller: shopNameController,
                              onSaved: (val) {},
                              onChanged: (val) {
                                isButtonPressed = false;
                                if (isError) {
                                  formKey.currentState.validate();
                                }
                                setState(() {
                                  buttonEnabled = val.isNotEmpty;
                                });
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
                                  return 'Shop name required';
                                } else {
                                  isError = false;
                                  return null;
                                }
                              },
                              decoration: new InputDecoration(
                                hintText: "Shop name",
                                border: InputBorder.none,
                                contentPadding: _isTablet
                                    ? EdgeInsets.all(
                                    Measurements.height * 0.007)
                                    : EdgeInsets.only(left: 12, right: 12),
                              ),
                              style: TextStyle(fontSize: 16),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      )
                  ),
                  Container(
                    height: 64,
                    child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: buttonEnabled ? () {
                          submitShop(state);
                        } : null,
                        child: state.isUpdating ? Center(
                          child: CircularProgressIndicator(),
                        ) : Text(
                          'Create',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        color: overlayBackground(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        )
      ),
    );
  }

  void submitShop(ShopScreenState state) {
    widget.screenBloc.add(CreateShopEvent(
      businessId: widget.businessId,
      name: shopNameController.text,
      logo: state.blobName != '' ? state.blobName : null,
    ));
  }

  Future getImage() async {
    PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);
    if (img == null) {
      return;
    }
    if (img.path != null) {
      print("_image: $img");
      widget.screenBloc.add(UploadShopImage(file: File(img.path), businessId: widget.businessId));
    }
  }


}

