import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/settings/widgets/save_button.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:payever/theme.dart';

class BusinessInfoScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  BusinessInfoScreen(
      {this.globalStateModel, this.setScreenBloc});

  @override
  _BusinessInfoScreenState createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  bool isGridMode = true;
  bool _isPortrait;
  bool _isTablet;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController myController = TextEditingController();
  String blobName = '';

  @override
  void initState() {
    super.initState();
    myController.text = widget.globalStateModel.currentBusiness.name;
    blobName = widget.globalStateModel.currentBusiness.logo;

  }

  @override
  void dispose() {
    myController.dispose();
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
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        } else if (state is BusinessDeleteSuccessState) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: SwitcherScreen(false),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is SettingScreenUpdateSuccess) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: Appbar('Business Info'),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: state.isLoading || state.isDeleting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _getBody(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(SettingScreenState state) {
    if (state.blobName != null && state.blobName != '') {
      setState(() {
        blobName = state.blobName;
      });
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            decoration: BoxDecoration(
              color: overlayBackground(),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 60,
                          width: 60,
                          child: InkWell(
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: <Widget>[
                                state.isUpdatingBusinessImg ?
                                    Center(
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    ) :
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
                                          color: iconColor(),
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
//                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                                    ),
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => CupertinoActionSheet(
                                  title: const Text('Choose Photo'),
                                  message: const Text('Your options are '),
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                      child: const Text('Take a Picture'),
                                      onPressed: () {
                                        Navigator.pop(context, 'Take a Picture');
                                        getImage(0);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: const Text('Camera Roll'),
                                      onPressed: () {
                                        Navigator.pop(context, 'Camera Roll');
                                        getImage(1);
                                      },
                                    )
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text('Cancel'),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: overlayBackground(),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: myController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter valid name.';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Business name',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 10, 8),
                    child: MaterialButton(
                      onPressed: () {
                        showConfirmDialog();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 40,
                      color: overlayBackground(),
                      elevation: 0,
                      child: Text('Delete Business', style: TextStyle(fontSize: 13,)),
                    ),
                  ),
                  SaveBtn(
                    isUpdating: state.isUpdating,
                    onUpdate: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate() && !state.isUpdating) {
                        Map<String, dynamic> body = {
                          'logo': blobName,
                          'name': myController.text
                        };
                        widget.setScreenBloc.add(BusinessUpdateEvent(body));
                      }
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }

  showConfirmDialog() {
    showCupertinoDialog(
      context: context,
      builder: (builder) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Wrap(
                children: <Widget>[
                  BlurEffectView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        SvgPicture.asset('assets/images/info.svg', color: iconColor(),),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Text(
                          'Deleting Business',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          'Do you really want to delete your business? Because all data will be lost and you will not be able to restore it.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                Language.getSettingsStrings('actions.no'),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                widget.setScreenBloc.add(DeleteBusinessEvent());
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                Language.getSettingsStrings('actions.yes'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        );
      },
    );
  }

  Future getImage(int type) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
      source: type == 1 ? ImageSource.gallery : ImageSource.camera,
    );
    if (image != null) {
      await _cropImage(File(image.path));
    }
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      widget.setScreenBloc.add(UploadBusinessImage(file: croppedFile,));
    }

  }
}
