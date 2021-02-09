import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';
import 'package:payever/theme.dart';

Map<String, String> currencyNames = {
  'Swiss Franc': 'CHF',
  'Danish Krone': 'DKK',
  'Euro': 'EUR',
  'Pound sterling': 'GBP',
  'Norwegian': 'NOK',
  'Swedish Krona': 'SEK',
  'US Dollar': 'USD'
};

class CurrencyScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  CurrencyScreen({this.globalStateModel, this.setScreenBloc});
  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  bool _isOpenCurrencyTable = false;
  String _currency = '';

  String getCurrency(String currency) {
    return currencyNames.keys
        .firstWhere((key) => currencyNames[key] == currency);
  }

  @override
  void initState() {
    _currency = currencyNames.keys.firstWhere((key) => currencyNames[key] == widget.globalStateModel.currentBusiness.currency);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _body;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  get _body {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: Appbar(Language.getSettingsStrings('form.create_form.currency.label')),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: _updateForm,
        ),
      ),
    );
  }

  get _updateForm {
    return BlocListener(
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, state) {
        if (state is SettingScreenUpdateSuccess) {
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {}
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (context, state) {
          return Center(
            child: Container(
              width: Measurements.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: overlayBackground(),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isOpenCurrencyTable = true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: overlayColor(),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                14, 8, 14, 5),
                                            child: Text(Language.getSettingsStrings('form.create_form.currency.label'),
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                14, 0, 14, 10),
                                            child: Text(
                                              _currency,
                                              style:
                                              TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          SaveBtn(
                            isUpdating: state.isUpdating,
                            onUpdate: () {
                              if (!state.isUpdating) {
                                widget.setScreenBloc.add(
                                    BusinessUpdateEvent({
                                  'currency': currencyNames[_currency]
                                }));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Visibility(
                        visible: _isOpenCurrencyTable,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF303030),
                              shape: BoxShape.rectangle,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0))),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: currencyNames.length,
                            itemBuilder: (context, index) {
                              List<String> keys = currencyNames.keys.toList();
                              return ListTile(
                                title: Text(keys[index]),
                                onTap: () {
                                  setState(() {
                                    _currency = getCurrency(currencyNames[keys[index]]);
                                    _isOpenCurrencyTable = false;
                                  });
                                },
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
