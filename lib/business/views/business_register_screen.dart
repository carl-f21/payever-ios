import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/business/models/model.dart';
import 'package:payever/business/widgets/simple_autocomplete_textfield.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/widgets/save_button.dart';
import 'package:payever/theme.dart';
import 'package:payever/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';

class BusinessRegisterScreen extends StatefulWidget {

  final DashboardScreenBloc dashboardScreenBloc;

  BusinessRegisterScreen({this.dashboardScreenBloc});
  @override
  State<StatefulWidget> createState() {
    return _BusinessRegisterScreenState();
  }
}

class _BusinessRegisterScreenState extends State<BusinessRegisterScreen> {
  bool _isPortrait;
  bool _isTablet;
  double iconSize;
  double margin;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController industryController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  IndustryModel selected;
  Country selectedCountry = Country(
    isoCode: 'DE',
    phoneCode: '49',
    name: 'Germany',
    iso3Code: 'DEU',
  );
  String selectedStatus;

  BusinessBloc businessBloc;
  @override
  void initState() {
    businessBloc = BusinessBloc(dashboardScreenBloc: widget.dashboardScreenBloc);
    businessBloc.add(BusinessFormEvent());
    super.initState();
  }

  @override
  void dispose() {
    businessBloc.close();
    companyNameController.dispose();
    phoneController.dispose();
    industryController.dispose();
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
      bloc: businessBloc,
      listener: (BuildContext context, BusinessState state) async {
        if (state is BusinessFailure) {
          Fluttertoast.showToast(msg: '${state.error}');
          Navigator.pop(context);
        } else if (state is BusinessSuccess) {
          Provider.of<GlobalStateModel>(context,listen: false)
              .setCurrentBusiness(state.business);
          Provider.of<GlobalStateModel>(context,listen: false)
              .setCurrentWallpaper('$wallpaperBase${state.wallpaper.currentWallpaper.wallpaper}');
          BusinessApps commerceApp;
          List<BusinessApps> businessApps = state.businessApps.where((element) => element.code.contains('commerceos')).toList();
          if (businessApps.length > 0) {
            commerceApp = businessApps.first;
          }
          Navigator.push(
            context,
            PageTransition(
              child: WelcomeScreen(
                business: state.business,
                businessApps: commerceApp,
              ),
              type: PageTransitionType.fade,
            ),
          );
//          Navigator.pushReplacement(
//              context,
//              PageTransition(
//                child: DashboardScreenInit(refresh: true,),
//                type: PageTransitionType.fade,
//                duration: Duration(microseconds: 300),
//              )
//          );
        }
      },
      child: BlocBuilder<BusinessBloc, BusinessState>(
        bloc: businessBloc,
        builder: (BuildContext context, BusinessState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            body: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(BusinessState state) {
    return BackgroundBase(
      true,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          width: Measurements.width,
          child: Form(
            key: formKey,
            child: BlurEffectView(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 16, ),
                      height: 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/ic_plus.svg',
                                color: iconColor(),
                              ),
                              SizedBox(width: 8,),
                              Text(
                                Language.getCommerceOSStrings('registration.business.panels.add_new_business'),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: CircleBorder(),
                            height: 36,
                            minWidth: 0,
                            elevation: 0,
                            child: SvgPicture.asset(
                              'assets/images/closeicon.svg',
                              color: iconColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlurEffectView(
                      color: overlayRow(),
                      radius: 0,
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 16, right: 8),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          validator: (val) {
                            if (val == null) {
                              return 'Business status is required';
                            }
                            return null;
                          },
                          items: List.generate(businessStatusMap.keys.toList().length, (index) {
                            String key = businessStatusMap.keys.toList()[index];
                            return DropdownMenuItem(
                              child: Text(
                                businessStatusMap[key],
                              ),
                              value: key,
                            );
                          }).toList(),
                          selectedItemBuilder: (context) {
                            return businessStatusMap.values.map<Widget>((String item){
                              return Text(
                                item,
                                maxLines: 1,
                              );
                            }).toList();
                          },
                          onChanged: (val) {
                            setState(() {
                            });
                          },
                          value: null,
                          icon: Flexible(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                            ),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          hint: Text(
                            'Business status',
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 0, thickness: 0.5,),
                    BlurEffectView(
                      color: overlayRow(),
                      radius: 0,
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: TextFormField(
                          style: TextStyle(fontSize: 16),
                          controller: companyNameController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Company name is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 16, right: 16),
                            labelText: Language.getPosTpmStrings('Company name'),
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 0.5),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    Divider(height: 0, thickness: 0.5,),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 16, right: 8),
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  validator: (val) {
                                    if (val == null) {
                                      return 'Status is required';
                                    }
                                    return null;
                                  },
                                  items: List.generate(statusesMap.keys.toList().length, (index) {
                                    String key = statusesMap.keys.toList()[index];
                                    return DropdownMenuItem(
                                      child: Text(
                                        statusesMap[key],
                                      ),
                                      value: key,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedStatus = val;
                                    });
                                  },
                                  value: null,
                                  selectedItemBuilder: (context) {
                                    return statusesMap.values.map<Widget>((String item){
                                      return Text(
                                        item,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }).toList();
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  hint: Text(
                                    'Status',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 16, right: 8),
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  validator: (val) {
                                    if (val == null) {
                                      return 'Sales is required';
                                    }
                                    return null;
                                  },
                                  items: List.generate(salesRange.length, (index) {
                                    String key = salesRange[index];
                                    return DropdownMenuItem(
                                      child: Text(
                                        Language.getSettingsStrings('assets.sales.${salesRange[index]}'),
                                      ),
                                      value: key,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                  },
                                  value: null,
                                  selectedItemBuilder: (context) {
                                    return salesRange.map<Widget>((String item){
                                      return Text(
                                        Language.getSettingsStrings('assets.sales.$item'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }).toList();
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  hint: Text(
                                    'Sales',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0, thickness: 0.5,),
                    BlurEffectView(
                      color: overlayRow(),
                      radius: 0,
                      child: Container(
                        alignment: Alignment.center,
                        child: SimpleAutocompleteFormField<IndustryModel>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 16, right: 16),
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 0.5),
                            ),
                            labelText: Language.getSettingsStrings('form.create_form.company.industry.label'),
                          ),
                          suggestionsHeight: 100.0,
                          itemBuilder: (context, industry) => Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              Language.getCommerceOSStrings('assets.industry.${industry.code}'),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          onSearch: (search) async {
                            if (search.length == 0) {
                              return [];
                            }
                            return state.industryList
                                .where((industry) =>
                                Language.getCommerceOSStrings('assets.industry.${industry.code}')
                                    .toLowerCase()
                                    .contains(search.toLowerCase()))
                                .toList();
                          },
                          itemFromString: (string) {
                            print('item From String => $string');
                            return state.industryList.singleWhere(
                                    (industry) => Language.getCommerceOSStrings('assets.industry.${industry.code}').toLowerCase() == string.toLowerCase(),
                                orElse: () => null);
                          },
                          onChanged: (value) => setState(() => selected = value),
                          itemToString: (item) {
                            if (item == null) {
                              return '';
                            }
                            print('item To String => ${item.code}');
                            return Language.getCommerceOSStrings('assets.industry.${item.code}');
                          },
                          onSaved: (value) => setState(() => selected = value),
                          validator: (person) => person == null ? 'Invalid industry.' : null,
                          resetIcon: Icons.close ,
                        ),
                      ),
                    ),
                    Divider(height: 0, thickness: 0.5,),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 16, right: 8),
                                child: CountryPickerDropdown(
                                  initialValue: 'DE',
                                  itemBuilder: _buildDropdownItem,
                                  priorityList:[
                                    CountryPickerUtils.getCountryByIsoCode('DE'),
                                    CountryPickerUtils.getCountryByIsoCode('US'),
                                  ],
                                  sortComparator: (Country a, Country b) => a.isoCode.compareTo(b.isoCode),
                                  selectedItemBuilder: (Country country) {
                                    return Center(
                                      child: Text('+${country.phoneCode}(${country.name})'),
                                    );
                                  },
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  onValuePicked: (Country country) {
                                    setState(() {
                                      selectedCountry = country;
                                    });
                                    print('${country.name}');
                                  },
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                child: TextFormField(
                                  style: TextStyle(fontSize: 16),
                                  controller: phoneController,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'Phone number is required';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                                    labelText: Language.getPosTpmStrings('Phone Number'),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0, thickness: 0.5,),
                    BlurEffectView(
                      radius: 0,
                      child: SaveBtn(
                        title: 'Register',
                        isBottom: true,
                        isUpdating: state.isUpdating,
                        onUpdate: () {
                          if (formKey.currentState.validate()) {
                            BusinessFormData formData = state.formData;
                            BusinessProduct product;
                            formData.products.forEach((prod) {
                              prod.industries.forEach((ind) {
                                if (ind.id == selected.id) {
                                  product = prod;
                                }
                              });
                            });
                            Map<String, dynamic> body = {
                              'active': true,
                              'companyAddress': {
                                'country': selectedCountry.isoCode,
                              },
                              'companyDetails': {
                                'industry': selected.code,
                                'product': product.code,
                                'status': selectedStatus,
                              },
                              'contactDetails': {
                                'phone': '+${selectedCountry.phoneCode}${phoneController.text}'
                              },
                              'name': companyNameController.text,
                            };
                            businessBloc.add(RegisterBusinessEvent(body: body));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(Country country) => Container(
    child: Text('+${country.phoneCode}(${country.name})'),
  );

}