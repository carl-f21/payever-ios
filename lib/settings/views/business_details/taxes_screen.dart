import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class TaxesScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final List<Country> countryList;
  TaxesScreen({
    this.globalStateModel,
    this.setScreenBloc,
    this.countryList,
  });

  @override
  _TaxesScreenState createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  Business activeBusiness;
  Taxes taxes;

  String companyRegisterNumber;
  String taxId;
  String taxNumber;
  bool turnoverTaxAct = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    taxes = activeBusiness.taxes;
    if (taxes != null) {
      companyRegisterNumber = taxes.companyRegisterNumber;
      taxId = taxes.taxId;
      taxNumber = taxes.taxNumber;
      turnoverTaxAct = taxes.turnoverTaxAct ?? false;
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
      appBar: Appbar(Language.getSettingsStrings('info_boxes.panels.business_details.menu_list.taxes.title')),
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
                  color: overlayColor(),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                            child: BlurEffectView(
                              color: overlayRow(),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Container(
                                height: 64,
                                alignment: Alignment.center,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 16),
                                    onChanged: (val) {
                                      setState(() {
                                        companyRegisterNumber = val;
                                      });
                                    },
                                    initialValue: companyRegisterNumber ?? '',
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 16, right: 16),
                                      labelText: Language.getSettingsStrings('form.create_form.taxes.taxes.companyRegisterNumber.label'),
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2, left: 8, right: 8),
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                height: 64,
                                alignment: Alignment.center,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 16),
                                    onChanged: (val) {
                                      setState(() {
                                        taxId = val;
                                      });
                                    },
                                    initialValue: taxId ?? '',
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 16, right: 16),
                                      labelText: Language.getSettingsStrings('form.create_form.taxes.taxes.taxId.label'),
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2, left: 8, right: 8),
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                height: 64,
                                alignment: Alignment.center,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 16),
                                    onChanged: (val) {
                                      setState(() {
                                        taxNumber = val;
                                      });
                                    },
                                    initialValue: taxNumber ?? '',
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 16, right: 16),
                                      labelText: Language.getSettingsStrings('form.create_form.taxes.taxes.taxNumber.label'),
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2, left: 8, right: 8, bottom: 8),
                            child: BlurEffectView(
                              color: overlayRow(),
                              radius: 0,
                              child: Container(
                                height: 64,
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      turnoverTaxAct = !turnoverTaxAct;
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(turnoverTaxAct ? Icons.check_box: Icons.check_box_outline_blank),
                                      SizedBox(width: 8,),
                                      Text(
                                        Language.getSettingsStrings('form.create_form.taxes.taxes.turnoverTaxAct.label'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SaveBtn(
                            isUpdating: state.isUpdating,
                            color: overlayBackground(),
                            isBottom: false,
                            onUpdate: () {
                              if (_formKey.currentState.validate() &&
                                  !state.isUpdating) {
                                Map<String, dynamic> body = {};
                                body['companyRegisterNumber'] = companyRegisterNumber;
                                body['taxNumber'] = taxNumber;
                                body['taxId'] = taxId;
                                body['turnoverTaxAct'] = turnoverTaxAct;
                                print(body);
                                widget.setScreenBloc.add(BusinessUpdateEvent({
                                  'taxes': body,
                                }));
                              }
                            },
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
