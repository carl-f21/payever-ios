import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/setting/setting_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/views/general/color_style_screen.dart';
import 'package:payever/settings/views/general/language_screen.dart';
import 'package:payever/settings/views/general/password_screen.dart';
import 'package:payever/settings/views/general/personal_information_screen.dart';
import 'package:payever/settings/views/general/shipping_addresses_screen.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';
import 'package:provider/provider.dart';

class GeneralScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  GeneralScreen(
      {this.globalStateModel, this.setScreenBloc, });
  @override
  State<StatefulWidget> createState() {
    return _GeneralScreenState();
  }
}

class _GeneralScreenState extends State<GeneralScreen> {
  bool _isPortrait;
  bool _isTablet;
  GlobalStateModel globalStateModel;
  @override
  void initState() {
    widget.setScreenBloc.add(GetCurrentUserEvent());
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
          widget.setScreenBloc.add(GetCurrentUserEvent());}
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: Appbar('General'),
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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Container(
          width: Measurements.width,
          decoration: BoxDecoration(
              color: overlayColor(),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: generalScreenTitles.keys.toList().length,
            itemBuilder: _itemBuilder,
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    String key = generalScreenTitles.keys.toList()[index];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(generalScreenTitles[key])),
          GestureDetector(
            onTap: () {
              _onTileClicked(key);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(12, 3, 12, 3),
              decoration: BoxDecoration(
                color: overlayBackground(),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                'Edit',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTileClicked(String key) {

    switch (key) {
      case 'language':
        Navigator.push(
          context,
          PageTransition(
            child: LanguageScreen(
              globalStateModel: globalStateModel,
              settingBloc: widget.setScreenBloc,
            ),
            type: PageTransitionType.fade,
          ),
        );
        break;
      case 'color_and_style':
        Navigator.push(
          context,
          PageTransition(
            child: ColorStyleScreen(
              globalStateModel: globalStateModel,
              settingBloc: widget.setScreenBloc,
            ),
            type: PageTransitionType.fade,
          ),
        );
        break;
      case 'personal_information':
        Navigator.push(
          context,
          PageTransition(
            child: PersonalInformationScreen(
              globalStateModel: globalStateModel,
              setScreenBloc: widget.setScreenBloc,
            ),
            type: PageTransitionType.fade,
          ),
        );
        break;
      case 'shipping_address':
        Navigator.push(
          context,
          PageTransition(
            child: ShippingAddressesScreen(
              globalStateModel: globalStateModel,
              setScreenBloc: widget.setScreenBloc,
            ),
            type: PageTransitionType.fade,
          ),
        );
        break;
      case 'password':
        Navigator.push(
          context,
          PageTransition(
            child: PasswordScreen(
              globalStateModel: globalStateModel,
              setScreenBloc: widget.setScreenBloc,
            ),
            type: PageTransitionType.fade,
          ),
        );
        break;
    }
  }
}