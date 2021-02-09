import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';

bool _isPortrait;
bool _isTablet;

class PosCreateTerminalScreen extends StatefulWidget {

  final PosScreenBloc screenBloc;
  final Terminal editTerminal;
  final bool fromDashBoard;

  PosCreateTerminalScreen({
    this.screenBloc,
    this.editTerminal,
    this.fromDashBoard = false,
  });

  @override
  createState() => _PosCreateTerminalScreenState();
}

class _PosCreateTerminalScreenState extends State<PosCreateTerminalScreen> {
  String imageBase = Env.storage + '/images/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  final TextEditingController terminalNameController = TextEditingController();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    if (widget.editTerminal != null) {
      terminalNameController.text = widget.editTerminal.name;
      widget.screenBloc.add(UpdateBlobImage(logo: widget.editTerminal.logo));
    }
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
      listener: (BuildContext context, PosScreenState state) async {
        if (state is PosScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is PosScreenSuccess) {
          if(widget.fromDashBoard) {
            Navigator.pop(context, 'Terminal Updated');
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(PosScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            widget.editTerminal != null ? 'Edit Terminal': 'Create Terminal',
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

  Widget _body(PosScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
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

  Widget _getBody(PosScreenState state) {
    String blobName = state.blobName;
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 90.0 + 64.0,
        child: BlurEffectView(
          radius: 12,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: <Widget>[
              Container(
                  height: 90,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          child: InkWell(
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: <Widget>[
                                blobName != null && blobName != ''
                                    ? Center(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage('$imageBase$blobName'),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                ): Center(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/images/newpicicon.svg",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                state.isLoading
                                    ? Center(
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                                    ),
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                            onTap: () {
                              getImage();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24),
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            child: BlurEffectView(
                              radius: 12,
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: TextFormField(
                                controller: terminalNameController,
                                onSaved: (val) {},
                                onChanged: (val) {
                                  isButtonPressed = false;
                                  if (isError) {
                                    formKey.currentState.validate();
                                  }
                                },
                                onFieldSubmitted: (val) {
                                  if (formKey.currentState.validate()) {
                                    submitTerminal(state);
                                  }
                                },
                                validator: (value) {
                                  if (!isButtonPressed) {
                                    return null;
                                  }
                                  isError = true;
                                  if (value.isEmpty) {
                                    return 'Terminal name required';
                                  } else {
                                    isError = false;
                                    return null;
                                  }
                                },
                                decoration: new InputDecoration(
                                  labelText: "Terminal name",
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
                      ],
                    ),
                  )
              ),
              Container(
                height: 64,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        submitTerminal(state);
                      }
                    },
                    child: state.isUpdating ? Center(
                      child: CircularProgressIndicator(),
                    ) : Text(
                      'Done',
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
      ),
    );
  }

  void submitTerminal(PosScreenState state) {
    if (widget.editTerminal != null) {
      widget.screenBloc.add(UpdatePosTerminalEvent(
        name: terminalNameController.text,
        logo: state.blobName != '' ? state.blobName : null,
        terminalId: widget.editTerminal.id,
      ));
    } else {
      widget.screenBloc.add(CreatePosTerminalEvent(
        name: terminalNameController.text,
        logo: state.blobName != '' ? state.blobName : null,
      ));
    }
  }

  Future getImage() async {
    PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);
    if (img.path != null) {
      print("_image: $img");
      widget.screenBloc.add(UploadTerminalImage(file: File(img.path)));
    }
  }


}

