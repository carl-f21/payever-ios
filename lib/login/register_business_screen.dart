import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/business/models/model.dart';
import 'package:payever/business/widgets/simple_autocomplete_textfield.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/dashboard/dashboard_screen.dart';
import 'package:payever/login/wiget/dashboard_background.dart';
import 'package:payever/login/wiget/select_language.dart';
import 'package:payever/settings/models/models.dart';
import 'package:provider/provider.dart';

class RegisterBusinessScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RegisterBusinessScreenState();
  }
}

class _RegisterBusinessScreenState extends State<RegisterBusinessScreen> {
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
    businessBloc = BusinessBloc();
    businessBloc.add(BusinessFormEvent(isRegister: true));
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
          // BusinessApps commerceApp;
          // List<BusinessApps> businessApps = state.businessApps.where((element) => element.code.contains('commerceos')).toList();
          // if (businessApps.length > 0) {
          //   commerceApp = businessApps.first;
          // }
          // Navigator.push(
          //   context,
          //   PageTransition(
          //     child: WelcomeScreen(
          //       business: state.business,
          //       businessApps: commerceApp,
          //     ),
          //     type: PageTransitionType.fade,
          //   ),
          // );
         Navigator.pushReplacement(
             context,
             PageTransition(
               child: DashboardScreenInit(refresh: true,),
               type: PageTransitionType.fade,
             )
         );
        }
      },
      child: BlocBuilder<BusinessBloc, BusinessState>(
        bloc: businessBloc,
        builder: (BuildContext context, BusinessState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Stack(
              children: <Widget>[
                DashBoardBackGround(),
                _body(state),
                SelectLanguage(),
                tabletTermsOfService(_isTablet),
              ],
            )
          );
        },
      ),
    );
  }

  Widget _body(BusinessState state) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: Measurements.width,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    width: Measurements.width /
                        ((_isTablet ? 1.5 : 1.5) * 2),
                    child: Image.asset(
                        'assets/images/logo-payever-${GlobalUtils.theme == 'light' ? 'black' : 'white'}.png')),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 28),
                  child: Text(
                    'Setup your business',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 16, right: 8),
                  decoration: BoxDecoration(
                    color: authScreenBgColor(),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
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
                Divider(height: 0, thickness: 0.5,),
                Container(
                  height: 60,
                  color: authScreenBgColor(),
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
                Divider(height: 0, thickness: 0.5,),
                Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 60,
                          color: authScreenBgColor(),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 16, right: 8),
                          margin: EdgeInsets.only(right: 0.5),
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
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 60,
                          color: authScreenBgColor(),
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
                    ],
                  ),
                ),
                Divider(height: 0, thickness: 0.5,),
                Container(
                  alignment: Alignment.center,
                  color: authScreenBgColor(),
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
                Divider(height: 0, thickness: 0.5,),
                Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: authScreenBgColor(),
                          height: 60,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 16, right: 8),
                          margin: EdgeInsets.only(right: 0.5),
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
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 60,
                          color: authScreenBgColor(),
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
                    ],
                  ),
                ),
                Divider(height: 0, thickness: 0.5,),
                Container(
                  height: 55,
                  decoration: authBtnDecoration(),
                  child: InkWell(
                    onTap: () {
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
                    child: Center(
                      child: state.isUpdating
                          ? Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : Text('Register',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28,),
                _isTablet
                    ? Container()
                    : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: termsOfServiceNote(),
                )
              ],
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