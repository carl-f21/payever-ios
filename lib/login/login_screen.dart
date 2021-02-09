import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/models/version.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/login/register_screen.dart';
import 'package:payever/login/wiget/dashboard_background.dart';
import 'package:payever/login/wiget/select_language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';
import 'package:page_transition/page_transition.dart';

import '../switcher/switcher_page.dart';


class LoginInitScreen extends StatelessWidget {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

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
    // if (_isTablet)
    //   Measurements.width = Measurements.width * 0.5;

    return Scaffold(
      key: scaffoldKey,
      body: LoginScreen(),
      resizeToAvoidBottomPadding: !_isPortrait,
    );
  }
}


final double _heightFactorTablet = 0.05;
final double _heightFactorPhone = 0.07;
final double _widthFactorTablet = 1.1;
final double _widthFactorPhone = 1.1;

const double _paddingText = 16.0;

bool _isTablet = false;
bool _isPortrait = true;

class LoginScreen extends StatefulWidget {
  double mainWidth = 0;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final formKey = new GlobalKey<FormState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool _isInvalidInformation = false;

  String _password, _username;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LoginScreenBloc loginScreenBloc = LoginScreenBloc(); // ignore: close_sinks

  @override
  void initState() {
    super.initState();
    loginScreenBloc.add(FetchEnvEvent());
    loginScreenBloc.add(FetchLoginCredentialsEvent());
    String fingerPrint = '${Platform.operatingSystem}  ${Platform.operatingSystemVersion}';
    GlobalUtils.fingerprint = fingerPrint;
    SharedPreferences.getInstance().then((p) {
      p.setString(GlobalUtils.FINGERPRINT, fingerPrint);
    });
  }

  @override
  void dispose() {
    loginScreenBloc.close();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mainWidth == 0) {
      widget.mainWidth = _isTablet ? Measurements.width * 0.5 : Measurements.width;
    }
    if (!GlobalUtils.isConnected) {
      setState(() {
        _isInvalidInformation = true;
      });
    }
    return BlocListener(
        bloc: loginScreenBloc,
        listener: (BuildContext context, LoginScreenState state) async {
          if (state is LoginScreenFailure) {
            _isInvalidInformation = true;
          } else if (state is LoginScreenVersionFailed) {
            showPopUp(state.version);
          } else if (state is LoginScreenSuccess) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: SwitcherScreen(true),
                )
            );
          } else if (state is LoadedCredentialsState) {
            emailController.text = state.username;
            passwordController.text = state.password;
          }
        },
        child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
            bloc: loginScreenBloc,
            builder: (BuildContext context, LoginScreenState state) {
              return _getBody(state);
            }
        ),
    );
  }

  Widget _getBody(LoginScreenState state) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          DashBoardBackGround(isLoading: state.isLoading,),
          _loginBody(state),
          SelectLanguage(isRegister: false)
        ],
      ),
    );
  }

  Widget _loginBody(LoginScreenState state) {
    return Container(
      width: widget.mainWidth /
          (_isTablet
              ? _widthFactorTablet
              : _widthFactorPhone),
      padding: EdgeInsets.symmetric(vertical: 20),
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
                    width: widget.mainWidth /
                        ((_isTablet
                            ? 1.5
                            : 1.5) *
                            2),
                    child: Image.asset(
                        'assets/images/logo-payever-${GlobalUtils.theme == 'light' ? 'black' : 'white'}.png')),
                Padding(
                  padding: EdgeInsets.only(
                    top: (Measurements.height *
                        (_isTablet
                            ? _heightFactorTablet
                            : _heightFactorPhone)
                    ) / 1.5,
                  ),
                ),
                if (_isInvalidInformation)
                  _errorWidget,
                if (_isInvalidInformation)
                  SizedBox(
                    height: 6,
                  ),
                Form(
                  key: formKey,
                  child: Center(
                      child: Column(
                        children: <Widget>[
                          Container(
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
                                    left: _paddingText,
                                    right: _paddingText),
                                child: TextFormField(
                                  controller: emailController,
                                  enabled: !state.isLogIn,
                                  onSaved: (val) => _username = val,
                                  onChanged: (val) {
                                    setState(() {
                                      _isInvalidInformation = false;
                                    });
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Username or email is required!';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Enter valid email address';
                                    }
                                    return null;
                                  },
                                  decoration: new InputDecoration(
                                    labelText: 'E-Mail Address',
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
                                  keyboardType:
                                  TextInputType.emailAddress,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 1),
                            width: widget.mainWidth /
                                (_isTablet
                                    ? _widthFactorPhone
                                    : _widthFactorPhone),
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
                                      padding: const EdgeInsets.only(
                                          left: _paddingText,
                                          right: _paddingText),
                                      child: TextFormField(
                                        controller: passwordController,
                                        enabled: !state.isLogIn,
                                        onSaved: (val) => _password = val,
                                        onChanged: (val) {
                                          setState(() {
                                            _isInvalidInformation = false;
                                          });
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Password is required';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                          labelText: 'Password',
                                          border: InputBorder.none,
                                          contentPadding: _isTablet
                                              ? EdgeInsets.all(
                                            Measurements.height *
                                                0.007,
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
                    width: widget.mainWidth /
                        (_isTablet
                            ? _widthFactorTablet
                            : _widthFactorPhone),
                    height: 55,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(47, 47, 47, 1),
                            Color.fromRGBO(0, 0, 0, 1)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                      ),
                      child: !state.isLogIn
                          ? InkWell(
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onTap: () {
                          if (!GlobalUtils.isConnected) {
                            Fluttertoast.showToast(msg: 'No internet connection!');
                            return;
                          }
                          _submit();
                        },
                      )
                          : Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: (Measurements.height *
                          (_isTablet
                              ? _heightFactorTablet
                              : _heightFactorPhone)) /
                          2),
                ),
                Container(
                  padding:
                  EdgeInsets.only(right: widget.mainWidth * 0.02),
                  child: InkWell(
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        color: GlobalUtils.theme == 'light' ? Color.fromRGBO(20, 20, 20, 1) : Colors.white,
                      ),
                    ),
                    onTap: () {
                      _launchURL(GlobalUtils.FORGOT_PASS);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 36, bottom: 15),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 0.5,
                          color: GlobalUtils.theme == 'light' ? Color.fromRGBO(20, 20, 20, 1) : Colors.white,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          child: Text('or', style: TextStyle(color: GlobalUtils.theme == 'light' ? Color.fromRGBO(20, 20, 20, 1) : Colors.white, fontSize: 14),)),
                      Expanded(
                        child: Container(
                          height: 0.5,
                          color: GlobalUtils.theme == 'light' ? Color.fromRGBO(20, 20, 20, 1) : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (!GlobalUtils.isConnected) {
                      Fluttertoast.showToast(msg: 'No internet connection!');
                      return;
                    }
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: RegisterInitScreen(),
                        )
                    );
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
                    child: Center(child: Text('Sign Up', style: TextStyle(color: GlobalUtils.theme == 'light' ? Colors.white : Colors.black, fontSize: 16),)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showPopUp(Version _version ){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              backgroundColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                  borderRadius:BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8,sigmaY: 16),
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                color: Colors.white.withOpacity(0.15),
                                child: Text("Close"),
                                onPressed: (){
                                  exit(0);
                                },
                              ),
                              RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                color: Colors.white.withOpacity(0.2),
                                child: Text("Update"),
                                onPressed: (){
                                  _launchURL(_version.storeLink(Platform.operatingSystem.contains("ios")));
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
        }
        );
  }

  get _errorWidget {
    print('GlobalUtils.isConnected: ${GlobalUtils.isConnected }');
    String title = GlobalUtils.isConnected ? 'Your account information was entered incorrectly.' : 'You have no internet';
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 8, 10),
      decoration: BoxDecoration(
        color: Color(0xffff644e),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              title,
              softWrap: true,
              style: TextStyle(
                  color: Colors.white, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      loginScreenBloc.add(LoginEvent(email: _username, password: _password));
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}