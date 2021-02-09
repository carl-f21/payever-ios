import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/views/payments/checkout_add_connection_screen.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/theme.dart';

class CheckoutPaymentSettingsScreen extends StatefulWidget {

  final CheckoutScreenBloc checkoutScreenBloc;
  final String business;
  final ConnectModel connectModel;

  CheckoutPaymentSettingsScreen({
    this.checkoutScreenBloc,
    this.business,
    this.connectModel,
  });

  @override
  _CheckoutPaymentSettingsScreenState createState() => _CheckoutPaymentSettingsScreenState();
}

class _CheckoutPaymentSettingsScreenState extends State<CheckoutPaymentSettingsScreen> {
  bool _isPortrait;
  bool _isTablet;
  double iconSize;
  double margin;
  String wallpaper;
  String selectedState = '';
  int isOpened = 0;
  int accountSection = -1;

  var imageData;

  Business business;

  CompanyDetails companyDetails;
  CompanyAddress companyAddress;
  BankAccount bankAccount;
  Taxes taxes;
  ContactDetails contactDetails;

  String countryName;
  String bankCountryName;
  String googleAutocomplete;
  List<Country> countryList = [];

  Map<String, PaymentVariant> variants;
  List<CheckoutPaymentOption> paymentOptions;
  PaymentVariant variant;

  CheckoutPaymentSettingScreenBloc screenBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    screenBloc = CheckoutPaymentSettingScreenBloc(checkoutScreenBloc: widget.checkoutScreenBloc);
    screenBloc.add(CheckoutPaymentSettingScreenInitEvent(business: widget.business, connectModel: widget.connectModel,));
    business = widget.checkoutScreenBloc.dashboardScreenBloc.state.activeBusiness;

    companyDetails = business.companyDetails;
    companyAddress = business.companyAddress;
    bankAccount = business.bankAccount;
    taxes = business.taxes;
    contactDetails = business.contactDetails;

    prepareDefaultCountries();
    if (companyAddress != null) {
      if (companyAddress.country != null) {
        getCountryForCodeWithIdentifier(companyAddress.country, 'en-en').then((value) {
          setState(() {
            countryName = value.name;
          });
        });
      }
      if (bankAccount.country != null) {
        getCountryForCodeWithIdentifier(bankAccount.country, 'en-en').then((value) {
          setState(() {
            bankCountryName = value.name;
          });
        });
      }
      setState(() {
        setGoogleAutoComplete();
      });
    }
    prepareDefaultCountries().then((value) =>countryList = value);

    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
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
      bloc: screenBloc,
      listener: (BuildContext context, CheckoutPaymentSettingScreenState state) async {
        if (state is CheckoutPaymentSettingScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutPaymentSettingScreenBloc, CheckoutPaymentSettingScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutPaymentSettingScreenState state) {
          iconSize = _isTablet ? 120: 80;
          margin = _isTablet ? 24: 16;
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: state.isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ): Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Form(key: formKey, child: _getBody(state)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(CheckoutPaymentSettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getPosConnectStrings(widget.connectModel.integration.displayOptions.title ?? ''),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(CheckoutPaymentSettingScreenState state) {
    if (state.paymentVariants.length == 0) {
      return Container();
    }
    variants = state.paymentVariants;
    paymentOptions = state.paymentOptions;

    variant = variants[state.integration.name];
    MissingSteps missingSteps = variant.missingSteps;

    List<Widget> widgets = [];
    for(int i = 0; i < missingSteps.missingSteps.length; i++) {
      MissingStep missingStep = missingSteps.missingSteps[i];
      if (missingStep.type == 'additional-info') {
        Widget header = Container(
          height: 56,
          color: overlayBackground(),
          child: SizedBox.expand(
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  if (isOpened == i) {
                    isOpened = -1;
                  } else {
                    isOpened = i;
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/images/account.svg',
                          width: 16,
                          height: 16,
                          color: iconColor(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Expanded(
                          child: Text(
                            'Account',
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
                    isOpened == i ? Icons.keyboard_arrow_up : Icons
                        .keyboard_arrow_down,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );

        widgets.add(header);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);
        // CompanyDetail Section;
        Widget companySection = isOpened == i ? Container(
          height: 56,
          color: overlayBackground(),
          child: SizedBox.expand(
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  if (accountSection == 0) {
                    accountSection = -1;
                  } else {
                    accountSection = 0;
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
                            'Company',
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
                    accountSection == 0 ? Icons.remove : Icons.add,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ) : Container();

        widgets.add(companySection);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget legalFormField = isOpened == i && accountSection == 0 ? Container(
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
            value: companyDetails.legalForm != '' ? companyDetails.legalForm : null,
            onChanged: (val) {
              companyDetails.legalForm = val;
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
        ) : Container();

        widgets.add(legalFormField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget productField = isOpened == i && accountSection == 0 ? Container(
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
                companyDetails.product = val;
                companyDetails.industry = null;
              });
            },
            value: companyDetails.product != '' ? companyDetails.product : null,
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
        ): Container();

        widgets.add(productField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        List<IndustryModel> industries = [];
        if (companyDetails.product != null && state.businessProducts.length > 0){
          BusinessProduct businessProduct = state.businessProducts.singleWhere((element) => element.code == companyDetails.product);
          if (businessProduct != null) {
            industries.addAll(businessProduct.industries);
          }
        }
        Widget industryField = isOpened == i && accountSection == 0 ? Container(
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
            value: companyDetails.industry != '' ? companyDetails.industry : null,
            onChanged: (val) {
              setState(() {
                companyDetails.industry = val;
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
        ): Container();

        widgets.add(industryField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget websiteField = isOpened == i && accountSection == 0 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  business.companyDetails.urlWebsite = val;
                });
              },
              initialValue: business.companyDetails.urlWebsite ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('URL to your website (Optional)'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(websiteField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget foundationField = isOpened == i && accountSection == 0 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  business.companyDetails.foundationYear = val;
                });
              },
              initialValue: business.companyDetails.foundationYear ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Foundation year (Optional)'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(foundationField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        // Company Address Section;
        Widget addressSection = isOpened == i ? Container(
          height: 56,
          color: overlayBackground(),
          child: SizedBox.expand(
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  if (accountSection == 1) {
                    accountSection = -1;
                  } else {
                    accountSection = 1;
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
                            'Address',
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
                    accountSection == 1 ? Icons.remove : Icons.add,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ) : Container();

        widgets.add(addressSection);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget googleAutoCompleteField = isOpened == i && accountSection == 1 ? Container(
          child: Column(
            children: <Widget>[
              Container(
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
                        initialValue: googleAutocomplete ?? '',
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        onChanged: (val) {
                          googleAutocomplete = val;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Google Autocomplete',
                          labelStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: DropdownButtonFormField(
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
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  hint: Text(
                    'Country',
                  ),
                ),
              ),
              Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),
            ],
          ),
        ): Container();

        widgets.add(googleAutoCompleteField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget cityField = isOpened == i && accountSection == 1 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.companyAddress.city = val;
                  setGoogleAutoComplete();
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'City is required.';
                }
                return null;
              },
              initialValue: business.companyAddress.city ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('City'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(cityField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget streetField = isOpened == i && accountSection == 1 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  business.companyAddress.street = val;
                  setGoogleAutoComplete();
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Street is required.';
                }
                return null;
              },
              initialValue: business.companyAddress.street ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Street'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(streetField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget zipField = isOpened == i && accountSection == 1 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  business.companyAddress.zipCode = val;
                  setGoogleAutoComplete();
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'ZIP code is required.';
                }
                return null;
              },
              initialValue: business.companyAddress.zipCode ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('ZIP code'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(zipField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        // Back account Section;
        Widget bankAccountSection = isOpened == i ? Container(
          color: overlayBackground(),
          height: 56,
          child: SizedBox.expand(
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  if (accountSection == 2) {
                    accountSection = -1;
                  } else {
                    accountSection = 2;
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
                            'Bank account',
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
                    accountSection == 2 ? Icons.remove : Icons.add,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ) : Container();

        widgets.add(bankAccountSection);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget accountOwnerField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  bankAccount.owner = val;
                });
              },
              initialValue: bankAccount.owner ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Account owner (optional)'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(accountOwnerField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget bankNameField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  bankAccount.bankName = val;
                });
              },
              initialValue: bankAccount.bankName ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Bank name (optional)'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(bankNameField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget bankCountryField = isOpened == i && accountSection == 2 ? Container(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: DropdownButtonFormField(
            items: List.generate(countryList.length,
                    (index) {
                  return DropdownMenuItem(
                    child: Text(
                      countryList[index].name,
                    ),
                    value: countryList[index].name,
                  );
                }).toList(),
            value: bankCountryName ?? null,
            onChanged: (val) {
              bankCountryName = val;
            },
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            hint: Text(
              'Country',
            ),
          ),
        ): Container();

        widgets.add(bankCountryField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget bankCityField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  bankAccount.city = val;
                });
              },
              initialValue: bankAccount.city ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('City (optional)'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(bankCityField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget bicField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  bankAccount.bic = val;
                });
              },
              initialValue: bankAccount.bic ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('BIC'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(bicField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget ibanField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  bankAccount.iban = val;
                });
              },
              initialValue: bankAccount.iban ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('IBAN'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(ibanField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        // Taxes Section;
        Widget taxesSection = isOpened == i ? Container(
          height: 56,
          color: overlayBackground(),
          child: SizedBox.expand(
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  if (accountSection == 3) {
                    accountSection = -1;
                  } else {
                    accountSection = 3;
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
                            'Taxes',
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
                    accountSection == 3 ? Icons.remove : Icons.add,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ) : Container();

        widgets.add(taxesSection);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget registerNumberField = isOpened == i && accountSection == 3 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  taxes.companyRegisterNumber = val;
                });
              },
              initialValue: taxes.companyRegisterNumber ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Company Register Number (optinal)'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(registerNumberField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget taxIdField = isOpened == i && accountSection == 3 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  taxes.taxId = val;
                });
              },
              initialValue: taxes.taxId ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Tax ID (optional)'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(taxIdField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget taxNumberField = isOpened == i && accountSection == 3 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  taxes.taxNumber = val;
                });
              },
              initialValue: taxes.taxNumber ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Tax Number (optional)'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(taxNumberField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget overTaxButton = isOpened == i && accountSection == 3 ? Container(
          height: 64,
          child: CheckboxListTile(
            onChanged: (val) {
              setState(() {
                taxes.turnoverTaxAct = val;
              });
            },
            checkColor: Colors.black,
            activeColor: Colors.white,
            value: taxes.turnoverTaxAct ?? false,
            title: Text(
              'Turnover tax at',
            ),
          ),
        ): Container();

        widgets.add(overTaxButton);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        // Taxes Section;
        Widget contactSection = isOpened == i ? Container(
          height: 56,
          color: overlayBackground(),
          child: SizedBox.expand(
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  if (accountSection == 4) {
                    accountSection = -1;
                  } else {
                    accountSection = 4;
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
                            'Contact',
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
                    accountSection == 4 ? Icons.remove : Icons.add,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ) : Container();

        widgets.add(contactSection);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget nameSection = isOpened == i && accountSection == 4 ? Container(
          height: 64,
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  onTap: () {

                  },
                  onChanged: (val) {
                    setState(() {
                      contactDetails.salutation = val;
                    });
                  },
                  initialValue: contactDetails.salutation ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('Salutation'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2),
              ),
              Flexible(
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  onTap: () {

                  },
                  onChanged: (val) {
                    setState(() {
                      contactDetails.firstName = val;
                    });
                  },
                  initialValue: contactDetails.firstName ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('First Name'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2),
              ),
              Flexible(
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  onTap: () {

                  },
                  onChanged: (val) {
                    setState(() {
                      contactDetails.lastName = val;
                    });
                  },
                  initialValue: contactDetails.lastName ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('Last Name'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
        ): Container();

        widgets.add(nameSection);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget phoneSection = isOpened == i && accountSection == 4 ? Container(
          height: 64,
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  onTap: () {

                  },
                  onChanged: (val) {
                    setState(() {
                      contactDetails.phone = val;
                    });
                  },
                  initialValue: contactDetails.phone ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('Phone'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2),
              ),
              Flexible(
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  onTap: () {

                  },
                  onChanged: (val) {
                    setState(() {
                      contactDetails.fax = val;
                    });
                  },
                  initialValue: contactDetails.fax ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('FAX (optional)'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
        ): Container();

        widgets.add(phoneSection);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget additionalPhoneField = isOpened == i && accountSection == 4 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  contactDetails.additionalPhone= val;
                });
              },
              initialValue: contactDetails.additionalPhone ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Additional Phone (optional)'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(additionalPhoneField);

        Widget accountSendButton = isOpened == i ? Container(
          height: 56,
          child: SizedBox.expand(
            child: MaterialButton(
              minWidth: 0,
              onPressed: () {
                String code = getCountryCode(countryName, countryList);
                if (code == null) {
                  Fluttertoast.showToast(msg: 'Can not find country Code');
                  return;
                }
                companyAddress.country = code.toUpperCase();
                companyAddress.googleAutocomplete = googleAutocomplete;
                if (bankCountryName == null || bankCountryName.isEmpty) {
                  Fluttertoast.showToast(msg: 'Can not find country Code');
                  return;
                }
                String code1 = getCountryCode(bankCountryName, countryList);
                if (code1 == null) {
                  Fluttertoast.showToast(msg: 'Can not find country Code');
                  return;
                }
                bankAccount.country = code1.toUpperCase();
                Map<String, dynamic> body = {};
                body['bankAccount'] = bankAccount.toMap();
                body['companyAddress'] = companyAddress.toMap();
                body['companyDetails'] = companyDetails.toMap();
                body['contactDetails'] = contactDetails.toMap();
                body['taxes'] = taxes.toMap();
                widget.checkoutScreenBloc.add(BusinessUploadEvent(body));
              },

              color: overlayBackground(),
              child: Text(
                Language.getConnectStrings('Send'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ) : Container();
        widgets.add(accountSendButton);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

      }
      else if (missingStep.type == 'missing-credentials') {
        for (Variant v in variant.variants) {
          Widget header = Container(
            height: 56,
            child: SizedBox.expand(
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    if (isOpened == v.id) {
                      isOpened = -1;
                    } else {
                      isOpened = v.id;
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.vpn_key,),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                          ),
                          Expanded(
                            child: Text(
                              v.isDefault ? 'Default': v.name ?? '',
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
                    Row(
                      children: <Widget>[
                        v.credentialsValid ? MaterialButton(
                          onPressed: () {
                            if (v.isDefault) {
                            } else {
                              screenBloc.add(DeletePaymentOptionEvent(id: '${v.id}'));
                            }
                          },
                          minWidth: 0,
                          color: overlayBackground(),
                          elevation: 0,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          height: 24,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: state.deleting == v.id ? Container(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                          ): Text(
                            v.isDefault ? 'Disconnect': 'Delete',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ): Container(),
                        Icon(
                          isOpened == v.id ? Icons.keyboard_arrow_up : Icons
                              .keyboard_arrow_down,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

          widgets.add(header);
          widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);
          if (v.credentialsValid) {
            Widget redirectAllow = isOpened == v.id ? Container(
              height: 64,
              child: CheckboxListTile(
                onChanged: (val) {
                  setState(() {
                    v.shopRedirectEnabled = val;
                  });
                },
                value: v.shopRedirectEnabled ?? false,
                activeColor: Colors.white,
                checkColor: Colors.black,
                title: Text(
                  'Do redirect to the shop after success or failure',
                ),
              ),
            ): Container();

            widgets.add(redirectAllow);
            widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

            Widget connectButton = isOpened == v.id ? Container(
              height: 56,
              child: SizedBox.expand(
                child: MaterialButton(
                  minWidth: 0,
                  onPressed: () {
                    Map<String, dynamic> body = {
                      'business_payment_option': {
                        'shop_redirect_enabled': v.shopRedirectEnabled,
                      }
                    };
                    screenBloc.add(UpdatePaymentOptionEvent(id: '${v.id}', body: body));
                  },
                  color: overlayBackground(),
                  child: state.isSaving ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ): Text(
                    Language.getConnectStrings('Save'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ) : Container();
            widgets.add(connectButton);
          } else {
            Widget vendorNumberField = isOpened == v.id ? Container(
              height: 64,
              child: Center(
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  onTap: () {

                  },
                  onChanged: (val) {
                    setState(() {

                    });
                  },
                  initialValue: '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('Vendor Number'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ): Container();

            widgets.add(vendorNumberField);
            widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

            Widget passwordField = isOpened == v.id ? Container(
              height: 64,
              child: Center(
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  onTap: () {

                  },
                  onChanged: (val) {
                    setState(() {

                    });
                  },
                  initialValue: '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('Password'),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ): Container();

            widgets.add(passwordField);
            widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

            Widget connectButton = isOpened == v.id ? Container(
              height: 56,
              child: SizedBox.expand(
                child: MaterialButton(
                  minWidth: 0,
                  onPressed: () {

                  },
                  color: overlayBackground(),
                  child: Text(
                    Language.getConnectStrings('Connect'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ) : Container();
            widgets.add(connectButton);
          }
        }

      } else if (missingStep.type == '') {

      }

    }
    Widget saveButton = Container(
      height: 56,
      child: SizedBox.expand(
        child: MaterialButton(
          minWidth: 0,
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: CheckoutAddConnectionScreen(
                  screenBloc: screenBloc,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          color: overlayBackground(),
          child: Text(
            Language.getConnectStrings('+ Add'),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
    widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);
    widgets.add(saveButton);

    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: BlurEffectView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widgets.map((e) => e).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void setGoogleAutoComplete() {
    if (companyAddress.street != null && companyAddress.street.isNotEmpty) {
      googleAutocomplete = companyAddress.street;
    }
    if (companyAddress.zipCode != null && companyAddress.zipCode.isNotEmpty) {
      googleAutocomplete = googleAutocomplete + ', ' + companyAddress.zipCode;
    }
    if (companyAddress.city != null && companyAddress.city.isNotEmpty) {
      googleAutocomplete = googleAutocomplete + ', ' + companyAddress.city;
    }
  }
}