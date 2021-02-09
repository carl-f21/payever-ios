import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';


class AddVariantColorScreen extends StatefulWidget {

  AddVariantColorScreen();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddVariantColorScreenState();
  }
}

class _AddVariantColorScreenState extends State<AddVariantColorScreen> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  Color pickerColor = Color(0xFFFFFFFF);
  Color currentColor = Color(0xff443a49);
  TextEditingController _colorNameController = TextEditingController();
  TextEditingController _colorValueController= TextEditingController();

  @override
  void initState() {
    _colorValueController.text = '#FFFFFF';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: Form(
            key: formKey,
            autovalidate: false,
            child: Container(
              child: _getBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Choose option',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 0,
            minWidth: 0,
            child: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody() {
    return Center(
      child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BlurEffectView(
                color: Color.fromRGBO(20, 20, 20, 0.4),
                blur: 12,
                radius: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: const Text('Pick a color!'),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: changeColor,
                                      showLabel: true,
                                      pickerAreaHeightPercent: 0.8,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: const Text('Got it'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          var hex = '#${pickerColor.value.toRadixString(16)}';
                                          _colorValueController.text = hex;
                                          currentColor = pickerColor;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              width: 16,
                              height: 50,
                              color: pickerColor,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                          ),
                          Flexible(
                            child: TextField(
                              controller: _colorValueController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  pickerColor = hexToColor(val);
                                });
                              },
                              decoration: InputDecoration(
                                fillColor: Color(0x80111111),
                                labelText: Language.getProductStrings('Color String'),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w200,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: _colorNameController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              validator: (val) {
                                if (val == ''){
                                  return 'Color name required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                fillColor: Color(0x80111111),
                                labelText: Language.getProductStrings('Color Name'),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w200,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Color(0x80888888),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState.validate()){
                          Navigator.pop(context, {'color': pickerColor, 'name': _colorNameController.text});
                        }
                      },
                      child: Container(
                        width: Device.width,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        height: 50,
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            'Save',
                          ),
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
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
}