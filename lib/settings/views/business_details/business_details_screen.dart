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
import 'package:payever/settings/views/business_details/address_screen.dart';
import 'package:payever/settings/views/business_details/bank_screen.dart';
import 'package:payever/settings/views/business_details/company_screen.dart';
import 'package:payever/settings/views/business_details/contact_screen.dart';
import 'package:payever/settings/views/business_details/taxes_screen.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/theme.dart';
import 'currency_screen.dart';

class BusinessDetailsScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final List<Country> countryList;
  BusinessDetailsScreen(
      {this.globalStateModel, this.setScreenBloc, this.countryList,});

  @override
  _BusinessDetailsScreenState createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  bool isGridMode = true;
  bool _isPortrait;
  bool _isTablet;

  final TextEditingController myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myController.text = widget.globalStateModel.currentBusiness.name;
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
            appBar: Appbar('Business Info'),
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
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: detailTitles.length,
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(detailTitles[index])),
          GestureDetector(
            onTap: () {
              _onTileClicked(index);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(12, 3, 12, 3),
              decoration: BoxDecoration(
                color: overlayColor(),
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

  void _onTileClicked(int index) {
    Widget _target;
    switch (index) {
      case 0:
        _target = CurrencyScreen(
            globalStateModel: widget.globalStateModel,
            setScreenBloc: widget.setScreenBloc);
        break;
      case 1:
        _target = CompanyScreen(
            globalStateModel: widget.globalStateModel,
            setScreenBloc: widget.setScreenBloc);
        break;
      case 2:
        _target = ContactScreen(
          globalStateModel: widget.globalStateModel,
          setScreenBloc: widget.setScreenBloc,
          countryList: widget.countryList,
        );
        break;
      case 3:
        _target = AddressScreen(
            globalStateModel: widget.globalStateModel,
            setScreenBloc: widget.setScreenBloc,
            countryList: widget.countryList,
          );
        break;
      case 4:
        _target = BankScreen(
          globalStateModel: widget.globalStateModel,
          setScreenBloc: widget.setScreenBloc,
          countryList: widget.countryList,
        );
        break;
      case 5:
        _target = TaxesScreen(
            globalStateModel: widget.globalStateModel,
            setScreenBloc: widget.setScreenBloc);
        break;
      default:
        _target = CurrencyScreen(
            globalStateModel: widget.globalStateModel,
            setScreenBloc: widget.setScreenBloc);
        break;
    }

    if (_target == null) return;

    Navigator.push(
      context,
      PageTransition(
        child: _target,
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 50),
      ),
    );
    debugPrint("You tapped on item $index");
  }

}
