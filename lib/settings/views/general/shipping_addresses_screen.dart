import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iso_countries/country.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/models/user.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';
import 'package:payever/theme.dart';

class ShippingAddressesScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final bool isDashboard;
  const ShippingAddressesScreen({Key key, this.globalStateModel, this.setScreenBloc, this.isDashboard = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShippingAddressesScreenState();
  }

}

class _ShippingAddressesScreenState extends State<ShippingAddressesScreen> {

  Business activeBusiness;
  User user;

  List<ShippingAddress> shippingAddresses = [];

  final _formKey = GlobalKey<FormState>(debugLabel: 'address');
  int selectedSection = 0;
  int updatedIndex = -1;
  List<Country> countryList = [];

  @override
  void initState() {
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    user = widget.setScreenBloc.state.user;
    shippingAddresses.addAll(user.shippingAddresses);
    if (shippingAddresses.length == 0) {
      shippingAddresses.add(ShippingAddress());
    }
    prepareDefaultCountries().then((value) {
      setState(() {
        countryList = value;
      });
    });
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
      appBar: widget.isDashboard ? Appbar('Shipping Address') : null,
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
      listener: (BuildContext context, SettingScreenState state) {
        if (state is SettingScreenUpdateSuccess) {
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {}
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (context, SettingScreenState state) {
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
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              ShippingAddress shippingAddress = shippingAddresses[index];
                              TextEditingController locationTextController = TextEditingController();
                              String addressLine = '';
                              locationTextController.text = addressLine;
                              String title = 'Save';
                              if (index < state.user.shippingAddresses.length) {
                                print(state.user.shippingAddresses.first.toDictionary());
                                title = shippingAddress != state.user.shippingAddresses[index] ? 'Save': 'Delete';
                                addressLine = shippingAddress.getAddressLine(countryList);
                              } else {

                              }
                              print(title);
                              return Column(
                                children: <Widget>[
                                  BlurEffectView(
                                    color: overlayBackground(),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    child: Container(
                                      height: 50,
                                      color: overlayBackground(),
                                      child: SizedBox.expand(
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (selectedSection == index) {
                                                selectedSection = -1;
                                              } else {
                                                selectedSection = index;
                                              }
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 8),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        addressLine != '' ? addressLine: 'New Address',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                selectedSection == index ? Icons.remove : Icons.add,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  selectedSection == index ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        BlurEffectView(
                                          color: overlayRow(),
                                          radius: 0,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 12, right: 12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  'assets/images/google-auto-complete.svg',
                                                  color: iconColor(),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    controller: locationTextController,
                                                    textInputAction: TextInputAction.done,
                                                    keyboardType: TextInputType.url,
                                                    onChanged: (val) {

                                                    },
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      labelText: Language.getSettingsStrings('form.create_form.address.google_autocomplete.label'),
                                                      labelStyle: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2,),
                                        BlurEffectView(
                                          color: overlayRow(),
                                          radius: 0,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 12, right: 12),
                                            child: countryList.length > 0 ? DropdownButtonFormField(
                                              items: List.generate(countryList.length,
                                                      (index) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                        countryList[index].name,
                                                      ),
                                                      value: countryList[index].countryCode.toUpperCase(),
                                                    );
                                                  }).toList(),
                                              value: shippingAddress.country ?? null,
                                              onChanged: (val) {
                                                setState(() {
                                                  ShippingAddress shippingAddress = shippingAddresses[index];
                                                  shippingAddress.country = val;
                                                  shippingAddresses[index] = shippingAddress;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              hint: Text(
                                                Language.getSettingsStrings('form.create_form.address.country.placeholder'),
                                              ),
                                              validator: (val) {
                                                if (val == null) {
                                                  return 'Country required';
                                                }
                                                if (val.isEmpty) {
                                                  return 'Country required';
                                                }
                                                return null;
                                              },
                                            ): CircularProgressIndicator(),
                                          ),
                                        ),
                                        SizedBox(height: 2,),
                                        BlurEffectView(
                                          color: overlayRow(),
                                          radius: 0,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 16),
                                                onChanged: (val) {
                                                  setState(() {
                                                    ShippingAddress shippingAddress = shippingAddresses[index];
                                                    shippingAddress.city= val;
                                                    shippingAddresses[index] = shippingAddress;
                                                  });
                                                },
                                                validator: (val) {
                                                  if (val.isEmpty) {
                                                    return 'City required';
                                                  }
                                                  return null;
                                                },
                                                initialValue: shippingAddress.city ?? '',
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                                                  labelText: Language.getSettingsStrings('form.create_form.address.city.placeholder'),
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                                  ),
                                                ),
                                                keyboardType: TextInputType.text,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2,),
                                        BlurEffectView(
                                          color: overlayRow(),
                                          radius: 0,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 16),
                                                onChanged: (val) {
                                                  setState(() {
                                                    ShippingAddress shippingAddress = shippingAddresses[index];
                                                    shippingAddress.street = val;
                                                    shippingAddresses[index] = shippingAddress;
                                                  });
                                                },
                                                initialValue: shippingAddress.street ?? '',
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                                                  labelText: Language.getSettingsStrings('form.create_form.address.street.label'),
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                                  ),
                                                ),
                                                validator: (val) {
                                                  if (val.isEmpty) {
                                                    return 'Street required';
                                                  }
                                                  return null;
                                                },
                                                keyboardType: TextInputType.text,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2,),
                                        BlurEffectView(
                                          color: overlayRow(),
                                          radius: 0,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 16),
                                                onChanged: (val) {
                                                  setState(() {
                                                    ShippingAddress shippingAddress = shippingAddresses[index];
                                                    shippingAddress.apartment = val;
                                                    shippingAddresses[index] = shippingAddress;
                                                  });
                                                },
                                                initialValue: shippingAddress.apartment ?? '',
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                                                  labelText: Language.getSettingsStrings('form.create_form.address.apartment.label'),
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                                  ),
                                                ),
                                                keyboardType: TextInputType.text,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2,),
                                        BlurEffectView(
                                          color: overlayRow(),
                                          radius: 0,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 16),
                                                onChanged: (val) {
                                                  setState(() {
                                                    ShippingAddress shippingAddress = shippingAddresses[index];
                                                    shippingAddress.zipCode = val;
                                                    shippingAddresses[index] = shippingAddress;
                                                  });
                                                },
                                                initialValue: shippingAddress.zipCode ?? '',
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                                                  labelText: Language.getSettingsStrings('form.create_form.address.zip_code.label'),
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                                  ),
                                                ),
                                                validator: (val) {
                                                  if (val.isEmpty) {
                                                    return 'Zip code required';
                                                  }
                                                  return null;
                                                },
                                                keyboardType: TextInputType.text,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2,),
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: SaveBtn(
                                                isUpdating: false,
                                                color: overlayBackground(),
                                                isBottom: false,
                                                title: Language.getSettingsStrings('actions.delete'),
                                                onUpdate: () {
                                                  setState(() {
                                                    shippingAddresses.removeAt(index);
                                                  });
                                                  if (_formKey.currentState.validate() &&
                                                      !state.isUpdating) {
                                                    List<Map<String, dynamic>> list = [];
                                                    for(ShippingAddress sa in shippingAddresses) {
                                                      list.add(sa.toDictionary());
                                                    }
                                                    print(list);
                                                    widget.setScreenBloc.add(UpdateCurrentUserEvent(body: {
                                                      'shippingAddresses': list,
                                                    }));
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 2,),
                                            Flexible(
                                              child: SaveBtn(
                                                isUpdating: state.isUpdating,
                                                color: overlayBackground(),
                                                isBottom: false,
                                                onUpdate: () {
                                                  if (_formKey.currentState.validate() &&
                                                      !state.isUpdating) {
                                                    List<Map<String, dynamic>> list = [];
                                                    for(ShippingAddress sa in shippingAddresses) {
                                                      list.add(sa.toDictionary());
                                                    }
                                                    print(list);
                                                    widget.setScreenBloc.add(UpdateCurrentUserEvent(body: {
                                                      'shippingAddresses': list,
                                                    }));
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ) : Container(),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 0,
                                thickness: 0.5,
                              );
                            },
                            itemCount: shippingAddresses.length,
                          ),
                          Divider(
                            height: 0,
                            thickness: 0.5,
                          ),
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: overlayBackground(),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                            ),
                            child: SizedBox.expand(
                              child: MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    shippingAddresses.add(ShippingAddress());
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('${Language.getSettingsStrings('actions.add')} +',),
                                ),
                              ),
                            ),
                          ),
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