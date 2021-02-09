import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/theme.dart';

import 'edit_legal_screen.dart';

class PoliciesScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final List<Country> countryList;
  PoliciesScreen(
      {this.globalStateModel, this.setScreenBloc, this.countryList,});

  @override
  _PoliciesScreenState createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends State<PoliciesScreen> {
  bool isGridMode = true;
  bool _isPortrait;
  bool _isTablet;

  @override
  void initState() {
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
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: Appbar('Policies'),
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
            color: overlayBackground(),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(8)
            ),
          ),
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: policiesScreenTitles.keys.toList().length,
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
    String key = policiesScreenTitles.keys.toList()[index];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(policiesScreenTitles[key])),
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
    Widget _target = LegalEditorScreen(
      globalStateModel: widget.globalStateModel,
      setScreenBloc: widget.setScreenBloc,
      type: key,
    );

    Navigator.push(
      context,
      PageTransition(
        child: _target,
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 50),
      ),
    );
  }
}
