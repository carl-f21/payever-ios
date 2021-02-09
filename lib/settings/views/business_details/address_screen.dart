import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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
import 'package:payever/widgets/address_field_group.dart';
import 'package:payever/widgets/googlemap_address_filed.dart';

class AddressScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final List<Country> countryList;
  AddressScreen({
    this.globalStateModel,
    this.setScreenBloc,
    this.countryList,
  });

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Business activeBusiness;
  CompanyAddress companyAddress;

  String city;
  String countryName;
  String countryCode;
  String street;
  String zipCode;
  String googleAutocomplete;

  final _formKey = GlobalKey<FormState>();

  @override
  Future<void> initState() {
    widget.setScreenBloc.add(GetBusinessProductsEvent());
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    companyAddress = activeBusiness.companyAddress;
    prepareDefaultCountries();
    if (companyAddress != null) {
      city = companyAddress.city;
      countryCode = companyAddress.country;
      if (countryCode != null) {
        getCountryForCodeWithIdentifier(countryCode, 'en-en').then((value) {
          setState(() {
            countryName = value.name;
          });
        });
      }
      street = companyAddress.street;
      zipCode = companyAddress.zipCode;
      setState(() {
        setGoogleAutoComplete();
      });
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
      appBar: Appbar(Language.getSettingsStrings('info_boxes.panels.business_details.menu_list.address.title')),
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
                          AddressFieldGroup(
                            googleAutocomplete: googleAutocomplete,
                            city: city,
                            countryCode: countryCode,
                            street: street,
                            zipCode: zipCode,
                            onChangedGoogleAutocomplete: (val) {
                              googleAutocomplete = val;
                            },
                            onChangedCode: (val) {
                              countryName = val;
                            },
                            onChangedCity: (val) {
                              setState(() {
                                city = val;
                                setGoogleAutoComplete();
                              });
                            },
                            onChangedStreet: (val) {
                              setState(() {
                                street = val;
                                setGoogleAutoComplete();
                              });
                            },
                            onChangedZipCode: (val) {
                              setState(() {
                                zipCode = val;
                                setGoogleAutoComplete();
                              });
                            },
                          ),
                          SaveBtn(
                            isUpdating: state.isUpdating,
                            onUpdate: () {
                              if (_formKey.currentState.validate() &&
                                  !state.isUpdating) {
                                Map<String, dynamic> body = {};
                                body['city'] = city;
                                String code = getCountryCode(countryName, widget.countryList);
                                if (code == null) {
                                  Fluttertoast.showToast(msg: 'Can not find country Code');
                                  return;
                                }
                                body['country'] = code.toUpperCase();
                                body['street'] = street;
                                body['zipCode'] = zipCode;
                                print(body);
                                widget.setScreenBloc.add(BusinessUpdateEvent({
                                  'companyAddress': body,
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

  void setGoogleAutoComplete() {
    setState(() {
      if (street != null && street.isNotEmpty) {
        googleAutocomplete = street;
      }
      if (zipCode != null && zipCode.isNotEmpty) {
        googleAutocomplete = googleAutocomplete + ', ' + zipCode;
      }
      if (city != null && city.isNotEmpty) {
        googleAutocomplete = googleAutocomplete + ', ' + city;
      }
      print('googleAutocomplete ' + googleAutocomplete);
    });
  }
}
