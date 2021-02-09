import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';
import 'package:payever/theme.dart';

class BankScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final List<Country> countryList;
  BankScreen({
    this.globalStateModel,
    this.setScreenBloc,
    this.countryList,
  });

  @override
  _BankScreenState createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  Business activeBusiness;
  BankAccount bankAccount;

  String owner;
  String bankName;

  String countryName;
  String countryCode;
  String city;

  String bic;
  String iban;

  final _formKey = GlobalKey<FormState>();

  @override
  Future<void> initState() {
    widget.setScreenBloc.add(GetBusinessProductsEvent());
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    bankAccount = activeBusiness.bankAccount;
    prepareDefaultCountries();
    if (bankAccount != null) {
      owner = bankAccount.owner;
      bankName = bankAccount.bankName;

      city = bankAccount.city;
      countryCode = bankAccount.country;
      if (countryCode != null) {
        getCountryForCodeWithIdentifier(countryCode, 'en-en').then((value) {
          setState(() {
            countryName = value.name;
          });
        });
      }

      bic = bankAccount.bic;
      iban = bankAccount.iban;
    }
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
      appBar: Appbar(Language.getSettingsStrings('info_boxes.panels.business_details.menu_list.bank.title'),),
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
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                width: Measurements.width,
                child: BlurEffectView(
                  color: overlayBackground(),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding:
                            EdgeInsets.only(left: 8, top: 8, right: 8),
                            height: 65,
                            child: BlurEffectView(
                              color: overlayRow(),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  initialValue: owner ?? '',
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  onChanged: (val) {
                                    owner = val;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Account holder is required.';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: Language.getSettingsStrings('form.create_form.bank.bankAccount.owner.label'),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 8,
                              top: 2,
                              right: 8,
                            ),
                            height: 65,
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  initialValue: bankName ?? '',
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  onChanged: (val) {
                                    bankName = val;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: Language.getSettingsStrings('form.create_form.bank.bankAccount.bankName.label'),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                            EdgeInsets.only(left: 8, top: 2, right: 8),
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: DropdownButtonFormField(
                                  items: List.generate(widget.countryList.length,
                                          (index) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            widget.countryList[index].name,
                                          ),
                                          value: widget.countryList[index].name,
                                        );
                                      }).toList(),
                                  value: countryName ?? null,
                                  onChanged: (val) {
                                    countryName = val;
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  hint: Text(
                                    Language.getSettingsStrings('form.create_form.bank.bankAccount.country.label'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 8,
                              top: 2,
                              right: 8,
                            ),
                            height: 65,
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  initialValue: city ?? '',
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  onChanged: (val) {
                                    city = val;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: Language.getSettingsStrings('form.create_form.address.city.label'),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 8,
                              top: 2,
                              right: 8,
                            ),
                            height: 65,
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  initialValue: bic ?? '',
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  onChanged: (val) {
                                    bic = val;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: Language.getSettingsStrings('form.create_form.bank.bankAccount.bic.label'),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 8, top: 2, right: 8, bottom: 8),
                            height: 65,
                            child: BlurEffectView(
                              color: overlayRow(),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  initialValue: iban ?? '',
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  onChanged: (val) {
                                    iban = val;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: Language.getSettingsStrings('form.create_form.bank.bankAccount.iban.label'),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SaveBtn(
                            isUpdating: state.isUpdating,
                            onUpdate: () {
                              if (_formKey.currentState.validate() &&
                                  !state.isUpdating) {
                                Map<String, dynamic> body = {};
                                if (countryName == null || countryName.isEmpty) {
                                  Fluttertoast.showToast(msg: 'Can not find country Code');
                                  return;
                                }
                                String code = getCountryCode(countryName, widget.countryList);
                                if (code == null) {
                                  Fluttertoast.showToast(msg: 'Can not find country Code');
                                  return;
                                }
                                body['country'] = code.toUpperCase();

                                body['owner'] = owner;
                                if (bankName != null && bankName.isNotEmpty) {
                                  body['bankName'] = bankName;
                                }
                                if (bic != null && bic.isNotEmpty) {
                                  body['bic'] = bic;
                                }
                                if (iban != null && iban.isNotEmpty) {
                                  body['iban'] = iban;
                                }
                                if (city != null && city.isNotEmpty) {
                                  body['city'] = city;
                                }
                                print(body);
                                widget.setScreenBloc.add(BusinessUpdateEvent({
                                  'bankAccount': body,
                                }));
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
