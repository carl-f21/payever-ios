
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/theme.dart';
import 'package:provider/provider.dart';

class AppearanceScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  AppearanceScreen(
      {this.globalStateModel, this.setScreenBloc});

  @override
  _AppearanceScreenState createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  GlobalStateModel globalStateModel;
  bool _isPortrait;
  bool _isTablet;
  Business activeBusiness;
  ThemeSetting themeSetting;

  bool automatic = false;
  String theme = 'default';
  @override
  void initState() {
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    themeSetting = activeBusiness.themeSettings;
    if (themeSetting != null) {
      theme = themeSetting.theme;
    }
    if (activeBusiness.currentWallpaper == null) {
      automatic = false;
    } else {
      automatic = activeBusiness.currentWallpaper.auto ?? false;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);
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
        } else if (state is SettingScreenUpdateSuccess) {
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: Appbar('Appearance'),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: state.isLoading
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          decoration: BoxDecoration(
            color: overlayColor(),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: Measurements.width,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: Measurements.width / 4.5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff8b8d90),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xff252525),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Dark',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Helvetica Neue',
                              ),
                            ),
                            SizedBox(height: 8,),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  theme = 'dark';
                                  automatic = false;
                                });
                                _updateThemeSetting();
                              },
                              child: Icon(
                                theme == 'dark' ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: Measurements.width / 4.5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff8b8d90),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xff454545),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Helvetica Neue',
                              ),
                            ),
                            SizedBox(height: 8,),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  theme = 'default';
                                  automatic = false;
                                });
                                _updateThemeSetting();
                              },
                              child: Icon(
                                theme == 'default' ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: Measurements.width / 4.5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff8b8d90),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xffececec),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Light',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Helvetica Neue',
                              ),
                            ),
                            SizedBox(height: 8,),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  theme = 'light';
                                  automatic = false;
                                });
                                _updateThemeSetting();
                              },
                              child: Icon(
                                theme == 'light' ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        automatic = !automatic;
                        if (automatic) {
                          theme = 'default';
                        }
                      });
                      _updateThemeSetting();
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Automatic',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Roboto-Medium'
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: automatic,
                              onChanged: (val) {
                                setState(() {
                                  automatic = !automatic;
                                  if (automatic) {
                                    theme = 'default';
                                  }
                                });
                                _updateThemeSetting();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _updateThemeSetting() async {
    widget.setScreenBloc.add(BusinessUpdateEvent({
      'currentWallpaper': {
        'auto': automatic,
      },
      'themeSettings': {
        'theme': theme,
      }
    }));
    Provider.of<GlobalStateModel>(context, listen: false).setTheme(theme);
    GlobalUtils.theme = theme;
    if (theme == 'dark') {
      BlocProvider.of<ChangeThemeBloc>(context).add(DarkTheme());
    } else if (theme == 'light') {
      BlocProvider.of<ChangeThemeBloc>(context).add(LightTheme());
    } else {
      BlocProvider.of<ChangeThemeBloc>(context).add(DefaultTheme());
    }
  }
}
