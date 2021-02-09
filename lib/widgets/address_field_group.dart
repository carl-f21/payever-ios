import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iso_countries/country.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

import '../theme.dart';
import 'googlemap_address_filed.dart';

class AddressFieldGroup extends StatefulWidget {

  final String city;
  final String countryCode;
  final String street;
  final String zipCode;
  final String googleAutocomplete;

  final Function onChangedCity;
  final Function onChangedCode;
  final Function onChangedStreet;
  final Function onChangedZipCode;
  final Function onChangedGoogleAutocomplete;
  final double height;
  final hasBorder;

  AddressFieldGroup(
      {this.city,
      this.countryCode,
      this.street,
      this.zipCode,
      this.googleAutocomplete,
      this.onChangedCity,
      this.onChangedCode,
      this.onChangedStreet,
      this.onChangedZipCode,
      this.onChangedGoogleAutocomplete,
      this.hasBorder = true,
      this.height = 65});

  @override
  _AddressFieldGroupState createState() => _AddressFieldGroupState();
}

class _AddressFieldGroupState extends State<AddressFieldGroup> {
  List<Country> countryList = [];
  String countryName;

  @override
  void initState() {
    prepareDefaultCountries().then((value) {
      setState(() {
        countryList = value;
      });
    });

    if (widget.countryCode != null) {
      getCountryForCodeWithIdentifier(widget.countryCode, 'en-en').then((value) {
        setState(() {
          countryName = value.name;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: widget.height,
            child: BlurEffectView(
              color: overlayRow(),
              radius: 0,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.hasBorder ? 8 : 0),
                topRight: Radius.circular(widget.hasBorder ? 8 : 0),
              ),
              child: GoogleMapAddressField(
                googleAutocomplete: widget.googleAutocomplete,
                onChanged: (val) {
                  widget.onChangedGoogleAutocomplete(val);
                },
              ),
            ),
          ),
          Container(
            padding:
            EdgeInsets.only(top: 2),
            child: BlurEffectView(
              color: overlayRow(),
              radius: 0,
              child: Container(
                height:  widget.height,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                alignment: Alignment.center,
                child: DropdownButtonFormField(
                  dropdownColor: overlayFilterViewBackground(),
                  items: List.generate(countryList.length,
                          (index) {
                        return DropdownMenuItem(
                          child: Text(
                            countryList[index].name,
                          ),
                          value: countryList[index].name,
                        );
                      }).toList(),
                  value: countryName ?? null,
                  onChanged: (val) {
                    countryName = val;
                    widget.onChangedCode(getCountryCode(countryName, countryList).toUpperCase());
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  hint: Text(
                    Language.getSettingsStrings('form.create_form.address.country.label'),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 2,
            ),
            height:  widget.height,
            child: BlurEffectView(
              color: overlayRow(),
              padding: EdgeInsets.symmetric(vertical: 4),
              radius: 0,
              child: TextFormField(
                style: textFieldStyle,
                initialValue: widget.city ?? '',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  widget.onChangedCity(val);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'City is required.';
                  }
                  return null;
                },
                decoration: textFieldDecoration(Language.getSettingsStrings('form.create_form.address.city.label')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 2,
            ),
            height: widget.height,
            child: BlurEffectView(
              color: overlayRow(),
              padding: EdgeInsets.symmetric(vertical: 4),
              radius: 0,
              child: TextFormField(
                style: textFieldStyle,
                initialValue: widget.street ?? '',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  widget.onChangedStreet(val);
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Street is required.';
                  }
                  if (!value.contains(',') && !value.contains(' ')) {
                    return 'House number required.';
                  }

                  bool hasHouseNum = false;
                  List<String> temp = [];
                  if (value.contains(',')) {
                    temp = value.split(',');
                    temp.forEach((element) {
                      if (isNumeric(element)) {
                        hasHouseNum = true;
                      }
                    });
                  }

                  if (!hasHouseNum) {
                    List<String> temp = [];
                    if (value.contains(' ')) {
                      temp = value.split(' ');
                      temp.forEach((element) {
                        if (isNumeric(element)) {
                          hasHouseNum = true;
                        }
                      });
                    }
                  }

                  if (!hasHouseNum) {
                    return 'House number required.';
                  }
                  return null;
                },
                decoration: textFieldDecoration(Language.getSettingsStrings('form.create_form.address.street.label')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 2),
            height: widget.height,

            child: BlurEffectView(
              radius: 0,
              color: overlayRow(),
              padding: EdgeInsets.symmetric(vertical: 4),
              child: TextFormField(
                style: textFieldStyle,
                initialValue: widget.zipCode ?? '',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  widget.onChangedZipCode(val);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'ZIP Code is required.';
                  }
                  return null;
                },
                decoration:textFieldDecoration(Language.getSettingsStrings('form.create_form.address.zip_code.label')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
