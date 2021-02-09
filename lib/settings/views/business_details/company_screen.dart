import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';
import 'package:payever/theme.dart';

class CompanyScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  CompanyScreen({this.globalStateModel, this.setScreenBloc});
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {

  TextEditingController urlController = TextEditingController();
  Business activeBusiness;
  CompanyDetails companyDetails;

  String legalForm;
  String product;
  SalesRange saleRange;
  String saleRangeString;
  EmployeesRange employeesRange;
  String employeesRangeString;
  String industry;
  String urlWebsite;

  @override
  void initState() {
    widget.setScreenBloc.add(GetBusinessProductsEvent());
    activeBusiness = widget.setScreenBloc.dashboardScreenBloc.state.activeBusiness;
    companyDetails = activeBusiness.companyDetails;
    if (companyDetails != null) {
      legalForm = companyDetails.legalForm;
      product = companyDetails.product;
      saleRange = companyDetails.salesRange;
      saleRangeString = getSalesString(saleRange);
      employeesRange = companyDetails.employeesRange;
      employeesRangeString = getEmployeeString(employeesRange);
      industry = companyDetails.industry;
      urlWebsite = companyDetails.urlWebsite;
      urlController.text = urlWebsite ?? '';
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
      backgroundColor: Colors.black,
      appBar: Appbar(Language.getSettingsStrings('info_boxes.panels.business_details.menu_list.company.title')),
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

          List<IndustryModel> industries = [];
          if (product != null && state.businessProducts.length > 0){
            BusinessProduct businessProduct = state.businessProducts.singleWhere((element) => element.code == product);
            if (businessProduct != null) {
              industries.addAll(businessProduct.industries);
            }
          }
          return Center(
            child: Container(
              padding: EdgeInsets.all(16),
              width: Measurements.width,
              child: BlurEffectView(
                color: overlayColor(),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 8, top: 8, right: 8),
                          child: BlurEffectView(
                            color: overlayRow(),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: DropdownButtonFormField(
                                items: List.generate(legalForms.length, (index) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      Language.getSettingsStrings('assets.legal_form.${legalForms[index]}'),
                                    ),
                                    value: legalForms[index],
                                  );
                                }).toList(),
                                value: legalForm != '' ? legalForm : null,
                                onChanged: (val) {
                                  legalForm = val;
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                hint: Text(
                                  Language.getSettingsStrings('form.create_form.company.legal_form.label'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8, top: 2, right: 8),
                          child: BlurEffectView(
                            color: overlayRow(),
                            radius: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: DropdownButtonFormField(
                                items: List.generate(employeeRange.length, (index) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      Language.getSettingsStrings('assets.employees.${employeeRange[index]}'),
                                    ),
                                    value: employeeRange[index],
                                  );
                                }).toList(),
                                value: employeesRangeString != '' ? employeesRangeString : null,
                                onChanged: (val) {
                                  setState(() {
                                    employeesRangeString = val;
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                hint: Text(
                                  Language.getSettingsStrings('form.create_form.company.employees.label'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8, top: 2, right: 8),
                          child: BlurEffectView(
                            color: overlayRow(),
                            radius: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: DropdownButtonFormField(
                                items: List.generate(salesRange.length, (index) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      Language.getSettingsStrings('assets.sales.${salesRange[index]}'),
                                    ),
                                    value: salesRange[index],
                                  );
                                }).toList(),
                                value: saleRangeString != '' ? saleRangeString : null,
                                onChanged: (val) {
                                  setState(() {
                                    saleRangeString = val;
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                hint: Text(
                                  Language.getSettingsStrings('form.create_form.company.sales.label'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8, top: 2, right: 8),
                          child: BlurEffectView(
                            color: overlayRow(),
                            radius: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: DropdownButtonFormField(
                                items: List.generate(state.businessProducts.length, (index) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      Language.getCommerceOSStrings('assets.product.${state.businessProducts[index].code}'),
                                    ),
                                    value: state.businessProducts[index].code,
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    product = val;
                                    industry = null;
                                  });
                                },
                                value: product != '' ? product : null,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                hint: Text(
                                  Language.getSettingsStrings('form.create_form.company.product.label'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8, top: 2, right: 8),
                          child: BlurEffectView(
                            color: overlayRow(),
                            radius: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: DropdownButtonFormField(
                                items: List.generate(industries.length, (index) {
                                  return DropdownMenuItem(
                                    child: AutoSizeText(
                                      Language.getCommerceOSStrings('assets.industry.${industries[index].code}'),
                                    ),
                                    value: industries[index].code,
                                  );
                                }).toList(),
                                value: industry != '' ? industry : null,
                                onChanged: (val) {
                                  setState(() {
                                    industry = val;
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                hint: Text(
                                  Language.getSettingsStrings('form.create_form.company.industry.label'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8, top: 2, right: 8, bottom: 8),
                          height: 65,
                          child: BlurEffectView(
                            color: overlayRow(),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                controller: urlController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                onChanged: (val) {
                                  urlWebsite = val;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: Language.getSettingsStrings('form.create_form.company.url_web.label'),
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                  )
                                ),
                              ),
                            ),
                          ),
                        ),
                        SaveBtn(
                          isUpdating: state.isUpdating,
                          onUpdate: () {
                            if (urlWebsite != null && urlWebsite != '') {
                              if (!Uri.parse(urlWebsite).isAbsolute) {
                                Fluttertoast.showToast(msg: 'Url not valid');
                                return;
                              }
                            }
                            Map<String, dynamic> body = {};
                            if (legalForm != null) {
                              body['legalForm'] = legalForm;
                            }
                            if (employeesRangeString != null) {
                              body['employeesRange'] = getEmployeeRange(employeesRangeString);
                            }
                            if (saleRangeString != null) {
                              body['salesRange'] = getSalesRange(employeesRangeString);
                            }
                            if (product != null) {
                              body['product'] = product;
                            }
                            if (industry != null) {
                              body['industry'] = industry;
                            }
                            if (urlWebsite != null && urlWebsite != '') {
                              body['urlWebsite'] = urlWebsite;
                            }

                            widget.setScreenBloc.add(BusinessUpdateEvent(
                              {
                                'companyDetails': body,
                              }
                            ));
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ),
          );
        },
      ),
    );
  }
}

Map<String, dynamic> getEmployeeRange(String employee) {
  switch(employee) {
    case 'RANGE_1':
      return {
        'min': 1,
        'max': 5
      };
    case 'RANGE_2':
      return {
        'min': 6,
        'max': 18
      };
    case 'RANGE_3':
      return {
        'min': 19,
        'max': 99
      };
    case 'RANGE_4':
      return {
        'min': 100,
        'max': 349
      };
    case 'RANGE_5':
      return {
        'min': 350,
        'max': 1499
      };
    case 'RANGE_6':
      return {
        'min': 1500,
      };
    default: return {};
  }
}

Map<String, dynamic> getSalesRange(String sales) {
  switch(sales) {
    case 'RANGE_1':
      return {
        'max': 0
      };
    case 'RANGE_2':
      return {
        'min': 0,
        'max': 5000
      };
    case 'RANGE_3':
      return {
        'min': 5000,
        'max': 50000
      };
    case 'RANGE_4':
      return {
        'min': 50000,
        'max': 250000
      };
    case 'RANGE_5':
      return {
        'min': 250000,
        'max': 1000000
      };
    case 'RANGE_6':
      return {
        'min': 1000000,
      };
    default: return {};
  }
}

String getEmployeeString(EmployeesRange range) {
  if (range == null) {
    return null;
  }
  if (range.min == 1) {
    return 'RANGE_1';
  } else if (range.min == 6) {
    return 'RANGE_2';
  } else if (range.min == 19) {
    return 'RANGE_3';
  } else if (range.min == 100) {
    return 'RANGE_4';
  } else if (range.min == 350) {
    return 'RANGE_5';
  } else if (range.min == 1500) {
    return 'RANGE_6';
  }
  return null;
}

String getSalesString(SalesRange range) {
  if (range == null) {
    return null;
  }
  if (range.max == 0) {
    return 'RANGE_1';
  } else if (range.min == 0) {
    return 'RANGE_2';
  } else if (range.min == 5000) {
    return 'RANGE_3';
  } else if (range.min == 50000) {
    return 'RANGE_4';
  } else if (range.min == 250000) {
    return 'RANGE_5';
  } else if (range.min == 1000000) {
    return 'RANGE_6';
  }
  return null;
}