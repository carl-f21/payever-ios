import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/models/version.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/login/register_business_screen.dart';
import 'package:payever/login/wiget/dashboard_background.dart';
import 'package:payever/login/wiget/select_language.dart';
import 'package:payever/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_validator/the_validator.dart';

class RegisterInitScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RegisterScreen();
  }
}

class RegisterScreen extends StatefulWidget {

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterScreenBloc screenBloc;
  final double _widthFactorPhone = 1.1;

  double _paddingText = 16.0;

  bool _isTablet = false;
  bool _isPortrait = true;

  final formKey = new GlobalKey<FormState>();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // ignore: close_sinks

  @override
  void initState() {
    screenBloc = RegisterScreenBloc();
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
    if (_isTablet) Measurements.width = Measurements.width * 0.5;

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, RegisterScreenState state) async {
        if (state is RegisterScreenFailure) {
          Fluttertoast.showToast(msg: state.error);
        } else if (state is RegisterScreenSuccess) {
          Fluttertoast.showToast(msg: 'Successfully Registered, Please confirm your email address to get started.');
          Future.delayed(Duration(milliseconds: 2000)).then((value) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: RegisterBusinessScreen(),
                ));
          });
        } else if (state is LoadedRegisterCredentialsState) {
          firstNameController.text = state.firstName;
          lastNameController.text = state.lastName;
          emailController.text = state.email;
          passwordController.text = state.password;
        }
      },
      child: BlocBuilder<RegisterScreenBloc, RegisterScreenState>(
          bloc: screenBloc,
          builder: (BuildContext context, RegisterScreenState state) {
            return _getBody(state);
          }),
    );
  }

  Widget _getBody(RegisterScreenState state) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            DashBoardBackGround(),
            _registerBody(state),
            SelectLanguage(),
            tabletTermsOfService(_isTablet),
          ],
        ),
      ),
    );
  }

  Widget _registerBody(RegisterScreenState state) {
    return Container(
      width: Measurements.width /
          (_isTablet ? _widthFactorPhone : _widthFactorPhone),
      padding: EdgeInsets.symmetric(vertical:20),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    width: Measurements.width /
                        ((_isTablet ? 1.5 : 1.5) * 2),
                    child: Image.asset(
                        'assets/images/logo-payever-${GlobalUtils.theme == 'light' ? 'black' : 'white'}.png')),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 28),
                  child: Text(
                    'Setup your business',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 1.0),
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: authScreenBgColor(),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: _paddingText, right: _paddingText),
                            child: TextFormField(
                              controller: firstNameController,
                              enabled: !state.isRegister,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Name is required!';
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              decoration: new InputDecoration(
                                labelText: 'First Name',
                                border: InputBorder.none,
                                contentPadding: _isTablet
                                    ? EdgeInsets.all(
                                        Measurements.height * 0.007,
                                      )
                                    : null,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 1),
                        width: Measurements.width /
                            (_isTablet ? _widthFactorPhone : _widthFactorPhone),
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: authScreenBgColor(),
                            shape: BoxShape.rectangle,
                          ),
                          child: Container(
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: _paddingText, right: _paddingText),
                                  child: TextFormField(
                                    controller: lastNameController,
                                    enabled: !state.isRegister,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Name is required';
                                      }
                                      return null;
                                    },
                                    textCapitalization: TextCapitalization.words,
                                    decoration: new InputDecoration(
                                      labelText: 'Last Name',
                                      border: InputBorder.none,
                                      contentPadding: _isTablet
                                          ? EdgeInsets.all(
                                              Measurements.height * 0.007,
                                            )
                                          : null,
                                    ),
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 1.0),
                        height: 55,
                        child: Container(
                          color: authScreenBgColor(),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: _paddingText, right: _paddingText),
                            child: TextFormField(
                              controller: emailController,
                              enabled: !state.isRegister,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email is required!';
                                }
                                if (!value.contains('@')) {
                                  return 'Enter valid email address';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
                                labelText: 'Email',
                                border: InputBorder.none,
                                contentPadding: _isTablet
                                    ? EdgeInsets.all(
                                        Measurements.height * 0.007,
                                      )
                                    : null,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 1),
                        width: Measurements.width /
                            (_isTablet ? _widthFactorPhone : _widthFactorPhone),
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: authScreenBgColor(),
                            shape: BoxShape.rectangle,
                          ),
                          child: Container(
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: _paddingText, right: _paddingText),
                                  child: TextFormField(
                                    controller: passwordController,
                                    enabled: !state.isRegister,
                                    onChanged: (val) {

                                    },
                                    // validator: (value) {
                                    //   if (value.isEmpty) {
                                    //     return 'Password is required';
                                    //   }
                                    //   return null;
                                    // },
                                    validator: FieldValidator.password(
                                        minLength: 8,
                                        shouldContainNumber: true,
                                        shouldContainCapitalLetter: true,
                                        shouldContainSpecialChars: true,
                                        errorMessage: "Password must match the required format",
                                        isNumberNotPresent: () { return "Password must contain number"; },
                                        isSpecialCharsNotPresent: () { return "Password must contain special characters"; },
                                        isCapitalLetterNotPresent: () { return "Password must contain capital letters"; }
                                    ),
                                    decoration: new InputDecoration(
                                      labelText: 'Password',
                                      border: InputBorder.none,
                                      contentPadding: _isTablet
                                          ? EdgeInsets.all(
                                              Measurements.height * 0.007,
                                            )
                                          : null,
                                    ),
                                    obscureText: true,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 1),
                    width: Measurements.width /
                        (_isTablet ? _widthFactorPhone : _widthFactorPhone),
                    height: 55,
                    child: Container(
                      decoration: authBtnDecoration(),
                      child: InkWell(
                        child: Center(
                          child: state.isRegister
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(state.isRegistered ?
                                  'Next Step' : 'Sign up for free',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                        onTap: () {
                          if (!GlobalUtils.isConnected) {
                            Fluttertoast.showToast(msg: 'No internet connection!');
                            return;
                          }
                          if (state.isRegister)
                            return;
                          if (state.isRegistered) {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: RegisterBusinessScreen(),
                                )
                            );
                          } else {
                            if (formKey.currentState.validate()) {
                              screenBloc.add(RegisterEvent(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text));
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 19, bottom: 16),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  height: 104,
                  decoration: BoxDecoration(
                    color: authScreenBgColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SvgPicture.asset('assets/images/get-started-icon.svg', color: iconColor(),),
                          SizedBox(width: 12,),
                          Expanded(child: Text('Get started for free', overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset('assets/images/grow-your-business-icon.svg', color: iconColor(),),
                          SizedBox(width: 12,),
                          Expanded(child: Text('Start, run and grow your business', overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset('assets/images/grow-your-sales-icon.svg', color: iconColor(),),
                          SizedBox(width: 12,),
                          Expanded(child: Text('No credit Card required', overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                    ],
                  ),
                ),
                _alreadyHaveAccount,
                _isTablet
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.0),
                        child: termsOfServiceNote(),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  get _alreadyHaveAccount {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                GlobalUtils.theme == 'light' ? Color.fromRGBO(49, 161, 239, 1) : Color.fromRGBO(237, 237, 244, 1),
                GlobalUtils.theme == 'light' ? Color.fromRGBO(0, 120, 208, 1) : Color.fromRGBO(174, 176, 183, 1)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text('Already have an account?', style: TextStyle(color: GlobalUtils.theme == 'light' ? Colors.white : Colors.black, fontSize: 16),)),
        ),
      ),
    );
  }

  showPopUp(Version _version) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              backgroundColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 16),
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Your App version is no longer supported."),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: Colors.white.withOpacity(0.15),
                              child: Text("Close"),
                              onPressed: () {
                                exit(0);
                              },
                            ),
                            RaisedButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: Colors.white.withOpacity(0.2),
                              child: Text("Update"),
                              onPressed: () {
                                _launchURL(_version.storeLink(
                                    Platform.operatingSystem.contains("ios")));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
