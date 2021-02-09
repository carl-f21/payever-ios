import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/theme.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc settingBloc;
  final bool fromDashboard;
  final bool isDashboard;
  LanguageScreen({this.settingBloc, this.globalStateModel, this.fromDashboard = false, this.isDashboard = true,});

  _LanguageScreenScreenState createState() => _LanguageScreenScreenState();

}

class _LanguageScreenScreenState extends State<LanguageScreen> {
  GlobalStateModel globalStateModel;

  User user;
  String defaultLanguage;

  Map<String, String> languages = {
    'en': 'English',
    'de': 'Deutsch',
    'es': 'Español',
    'no': 'Norsk',
    'da': 'Dansk',
    'sv': 'Svenska',
  };

  @override
  void initState() {
    user = widget.settingBloc.state.user;
    defaultLanguage = user.language;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.fromDashboard) widget.settingBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);
    return BlocListener(
      bloc: widget.settingBloc,
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenUpdateSuccess) {
          globalStateModel.setLanguage(defaultLanguage);
          Language.setLanguage(defaultLanguage);
          Language(context);
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {

        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.settingBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: widget.isDashboard ? _appBar(state) : null,
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: _getBody(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(SettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        Language.getSettingsStrings('form.create_form.language.label'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
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

  Widget _getBody(SettingScreenState state) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          radius: 20,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12),
                child: BlurEffectView(
                  radius: 8,
                  child: DropdownButtonFormField(
                    items: List.generate(languages.keys.toList().length, (index) {
                      return DropdownMenuItem(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            languages[languages.keys.toList()[index]],
                          ),
                        ),
                        value: languages.keys.toList()[index],
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        defaultLanguage = val;
                      });
                    },
                    value: defaultLanguage,
                    hint: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text('Language',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      if (!state.isUpdating) {
                        Map<String, dynamic> body = {
                          'language': defaultLanguage,
                        };
                        widget.settingBloc.add(UpdateCurrentUserEvent(body: body));
                      }
                    },
                    color: overlayBackground(),
                    elevation: 0,
                    child: state.isUpdating
                        ? CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                        : Text(
                      Language.getCommerceOSStrings('actions.save'),
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
}