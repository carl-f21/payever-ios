import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';

bool _isPortrait;
bool _isTablet;

class ConnectSettingScreen extends StatefulWidget {

  final ConnectScreenBloc screenBloc;
  final ConnectIntegration connectIntegration;

  ConnectSettingScreen({
    this.screenBloc,
    this.connectIntegration,
  });

  @override
  createState() => _ConnectSettingScreenState();
}

class _ConnectSettingScreenState extends State<ConnectSettingScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ConnectSettingsDetailScreenBloc screenBloc;
  String wallpaper;
  String selectedState = '';
  int isOpened = 0;
  int accountSection = -1;

  var imageData;

  Business business;
  Map<String, PaymentVariant> variants;
  List<CheckoutPaymentOption> paymentOptions;
  PaymentVariant variant;
  @override
  void initState() {
    screenBloc = ConnectSettingsDetailScreenBloc(connectScreenBloc: widget.screenBloc);
    business = widget.screenBloc.dashboardScreenBloc.state.activeBusiness;
    variants = widget.screenBloc.state.paymentVariants;
    paymentOptions = widget.screenBloc.state.paymentOptions;

    variant = variants[widget.connectIntegration.name];
    if (variant == null) {
      screenBloc.add(ConnectSettingsDetailScreenInitEvent(business: business.id));
    }
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
      listener: (BuildContext context, ConnectSettingsDetailScreenState state) async {
        if (state is ConnectSettingsDetailScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ConnectSettingsDetailScreenBloc, ConnectSettingsDetailScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ConnectSettingsDetailScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(ConnectSettingsDetailScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        Language.getPosConnectStrings(widget.connectIntegration.displayOptions.title),
        style: TextStyle(
          color: Colors.white,
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

  Widget _body(ConnectSettingsDetailScreenState state) {
    return Scaffold(
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
            child: SingleChildScrollView(
              child: Container(
                width: Measurements.width,
                child: Column(
                  children: <Widget>[
                    _getBody(state),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBody(ConnectSettingsDetailScreenState state) {
    if (variant == null) {
      return CircularProgressIndicator();
    }
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget legalFormField = isOpened == i && accountSection == 0 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.companyDetails.legalForm = val;
                });
              },
              initialValue: business.companyDetails.legalForm ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Legal Form'),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              readOnly: true,
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(legalFormField);
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget productField = isOpened == i && accountSection == 0 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.companyDetails.product = val;
                });
              },
              initialValue: business.companyDetails.product ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Product'),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              readOnly: true,
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(productField);
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget industryField = isOpened == i && accountSection == 0 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.companyDetails.industry = val;
                });
              },
              initialValue: business.companyDetails.product ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Industry'),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              readOnly: true,
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(industryField);
        widgets.add(Divider(height: 0, thickness: 0.5,),);

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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        // Company Adress Section;
        Widget addressSection = isOpened == i ? Container(
          height: 56,
          color: overlayRow(),
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
                              color: Colors.white,
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget googleAutoCompleteField = isOpened == i && accountSection == 1 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.companyAddress.googleAutocomplete = val;
                });
              },
              initialValue: business.companyAddress.googleAutocomplete ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Google Autocomplete'),
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

        widgets.add(googleAutoCompleteField);
        widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

        Widget countryField = isOpened == i && accountSection == 1 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.companyAddress.country = val;
                });
              },
              initialValue: business.companyAddress.country ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Country'),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              readOnly: true,
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(countryField);
        widgets.add(Divider(height: 0, thickness: 0.5,),);

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
                });
              },
              initialValue: business.companyAddress.city ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('City'),
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
                });
              },
              initialValue: business.companyAddress.street ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Street'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget zipField = isOpened == i && accountSection == 1 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  business.companyAddress.zipCode = val;
                });
              },
              initialValue: business.companyAddress.zipCode ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('ZIP code'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        // Back account Section;
        Widget bankAccountSection = isOpened == i ? Container(
          color: overlayRow(),
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
                  business.bankAccount.owner = val;
                });
              },
              initialValue: business.bankAccount.owner ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Account owner (optional)'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget bankNameField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.bankAccount.bankName = val;
                });
              },
              initialValue: business.bankAccount.bankName ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Bank name (optional)'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget bankCountryField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.bankAccount.country = val;
                });
              },
              initialValue: business.bankAccount.country ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Country'),
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ): Container();

        widgets.add(bankCountryField);
        widgets.add(Divider(height: 0, thickness: 0.5, ),);

        Widget bankCityField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  business.bankAccount.city = val;
                });
              },
              initialValue: business.bankAccount.city ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('City (optional)'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget bicField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  business.bankAccount.bic = val;
                });
              },
              initialValue: business.bankAccount.bic ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('BIC'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget ibanField = isOpened == i && accountSection == 2 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onChanged: (val) {
                setState(() {
                  business.bankAccount.iban = val;
                });
              },
              initialValue: business.bankAccount.iban ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('IBAN'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        // Taxes Section;
        Widget taxesSection = isOpened == i ? Container(
          height: 56,
          color: overlayRow(),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget registerNumberField = isOpened == i && accountSection == 3 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.taxes.companyRegisterNumber = val;
                });
              },
              initialValue: business.taxes.companyRegisterNumber ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Company Register Number (optinal)'),
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
        widgets.add(Divider(height: 0, thickness: 0.5),);

        Widget taxIdField = isOpened == i && accountSection == 3 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.taxes.taxId = val;
                });
              },
              initialValue: business.taxes.taxId ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Tax ID (optional)'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget taxNumberField = isOpened == i && accountSection == 3 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.taxes.taxNumber = val;
                });
              },
              initialValue: business.taxes.taxNumber ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Tax Number (optional)'),
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
        widgets.add(Divider(height: 0, thickness: 0.5, ),);

        Widget overTaxButton = isOpened == i && accountSection == 3 ? Container(
          height: 64,
          child: CheckboxListTile(
            onChanged: (val) {
              setState(() {
                business.taxes.turnoverTaxAct = val;
              });
            },
            value: business.taxes.turnoverTaxAct ?? false,
            title: Text(
              'Turnover tax at',
            ),
          ),
        ): Container();

        widgets.add(overTaxButton);
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        // Taxes Section;
        Widget contactSection = isOpened == i ? Container(
          height: 56,
          color: overlayRow(),
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
        widgets.add(Divider(height: 0, thickness: 0.5, ),);

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
                      business.contactDetails.salutation = val;
                    });
                  },
                  initialValue: business.contactDetails.salutation ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('Salutation'),
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
                      business.contactDetails.firstName = val;
                    });
                  },
                  initialValue: business.contactDetails.firstName ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('First Name'),
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
                      business.contactDetails.lastName = val;
                    });
                  },
                  initialValue: business.contactDetails.lastName ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('Last Name'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

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
                      business.contactDetails.phone = val;
                    });
                  },
                  initialValue: business.contactDetails.phone ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('Phone'),
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
                      business.contactDetails.fax = val;
                    });
                  },
                  initialValue: business.contactDetails.fax ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getPosTpmStrings('FAX (optional)'),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

        Widget additionalPhoneField = isOpened == i && accountSection == 4 ? Container(
          height: 64,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              onTap: () {

              },
              onChanged: (val) {
                setState(() {
                  business.contactDetails.additionalPhone= val;
                });
              },
              initialValue: business.contactDetails.additionalPhone ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16),
                labelText: Language.getPosTpmStrings('Additional Phone (optional)'),
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

              },
              color: overlayRow(),
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);

      } else if (missingStep.type == 'missing-credentials') {
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
                        Icon(Icons.vpn_key),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Expanded(
                          child: Text(
                            'Default',
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
                      variant.variants.first.credentialsValid ? MaterialButton(
                        onPressed: () {

                        },
                        minWidth: 0,
                        color: overlayBackground(),
                        elevation: 0,
                        padding: EdgeInsets.all(4),
                        height: 24,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Disconnect',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ): Container(),
                      Icon(
                        isOpened == i ? Icons.keyboard_arrow_up : Icons
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
        widgets.add(Divider(height: 0, thickness: 0.5,),);
        if (variant.variants.first.credentialsValid) {
          Widget redirectAllow = isOpened == i ? Container(
            height: 64,
            child: CheckboxListTile(
              onChanged: (val) {
                setState(() {
                  variant.variants.first.shopRedirectEnabled = val;
                });
              },
              value: variant.variants.first.shopRedirectEnabled ?? false,
              title: Text(
                'Do redirect to the shop after success or failure',
              ),
            ),
          ): Container();

          widgets.add(redirectAllow);
          widgets.add(Divider(height: 0, thickness: 0.5, color: Color.fromRGBO(120, 120, 120, 0.5),),);

          Widget connectButton = isOpened == i ? Container(
            height: 56,
            child: SizedBox.expand(
              child: MaterialButton(
                minWidth: 0,
                onPressed: () {

                },
                color: overlayBackground(),
                child: Text(
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
          Widget vendorNumberField = isOpened == i ? Container(
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
          widgets.add(Divider(height: 0, thickness: 0.5,),);

          Widget passwordField = isOpened == i ? Container(
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
          widgets.add(Divider(height: 0, thickness: 0.5,),);

          Widget connectButton = isOpened == i ? Container(
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

      } else if (missingStep.type == '') {

      }

    }
    Widget saveButton = Container(
      height: 56,
      child: SizedBox.expand(
        child: MaterialButton(
          minWidth: 0,
          onPressed: () {

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
    widgets.add(Divider(height: 0, thickness: 0.5, ),);
    widgets.add(saveButton);

    return Center(
      child: Wrap(
        runSpacing: 16,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: BlurEffectView(
              color: overlayBackground(),
              blur: 15,
              radius: 12,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widgets.map((e) => e).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//DropDownFormField(
//filled: false,
//titleText: Language.getProductStrings('Product must match'),
//hintText: Language.getProductStrings('Product must match'),
//value: conditionOption,
//onChanged: (value) {
//setState(() {
//conditionOption = value;
//if (conditionOption != 'No Conditions') {
//CollectionModel collection = state.collectionDetail;
//FillCondition fillCondition = collection
//    .automaticFillConditions;
//fillCondition.strict =
//conditionOption == 'All Conditions';
//collection.automaticFillConditions = fillCondition;
//widget.screenBloc.add(
//UpdateCollectionDetail(collectionModel: collection));
//}
//});
//},
//dataSource: productConditionOptions.map((e) {
//return {
//'display': e,
//'value': e,
//};
//}).toList(),
//textField: 'display',
//valueField: 'value',
//)