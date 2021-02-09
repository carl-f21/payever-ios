import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';

List<String> dropdownItems = [
  'Verify by code',
  'Verify by ID',
];
class CheckoutTwilioAddPhoneNumber extends StatefulWidget {

  final CheckoutScreenBloc screenBloc;
  final String id;

  CheckoutTwilioAddPhoneNumber({
    this.screenBloc,
    this.id,
  });

  @override
  createState() => _CheckoutTwilioAddPhoneNumberState();
}

class _CheckoutTwilioAddPhoneNumberState extends State<CheckoutTwilioAddPhoneNumber> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  String wallpaper;
  String selectedState = '';

  @override
  void initState() {
    widget.screenBloc.add(
      AddCheckoutPhoneNumberSettings(
        action: 'add-number',
        id: widget.id,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, CheckoutScreenState state) async {
        if (state is CheckoutScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(CheckoutScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            Language.getPosTpmStrings('tpm.communications.twilio.adding_numbers'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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

  Widget _body(CheckoutScreenState state) {
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
          ): Column(
            children: <Widget>[
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(CheckoutScreenState state) {
    List<CountryDropdownItem> dropdownItems = state.dropdownItems;
    phoneNumberController.text = state.settingsModel != null ? state.settingsModel.phoneNumber ?? '': '';
    return Center(
      child: SingleChildScrollView(
        child: Wrap(
            runSpacing: 16,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: BlurEffectView(
                  color: Color.fromRGBO(50, 50, 50, 0.2),
                  blur: 15,
                  radius: 12,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: Colors.black26,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Flexible(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        Language.getPosTpmStrings('tpm.communications.twilio.country'),
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      dropdownItems.length > 0 ? Expanded(
                                        child: DropdownButton<dynamic>(
                                          icon: Container(),
                                          underline: Container(),
                                          isExpanded: true,
                                          value: state.settingsModel.country != null ? state.settingsModel.country.label: dropdownItems.first.label,
                                          onChanged: (value) {
                                            setState(() {
                                              AddPhoneNumberSettingsModel model = state.settingsModel;
                                              CountryDropdownItem item = dropdownItems.firstWhere((element) => element.label == value);
                                              model.country = item;
                                              widget.screenBloc.add(UpdateCheckoutAddPhoneNumberSettings(settingsModel: model));
                                            });
                                          },
                                          items: dropdownItems.map((item) => DropdownMenuItem(
                                            child: Text(
                                              item.label,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            value: item.label,
                                          ),
                                          ).toList(),
                                        ),
                                      ): Container(),
                                    ],
                                  ),
                                  height: 64,
                                ),
                              ),
                              flex: 1,
                            ),
                            Container(
                              color: Color(0xFF888888),
                              width: 1,
                              height: 64,
                            ),
                            Flexible(
                              child: Container(
                                  height: 64,
                                  child: Center(
                                    child: TextField(
                                      controller: phoneNumberController,
                                      style: TextStyle(fontSize: 16),
                                      onChanged: (val) {
                                        AddPhoneNumberSettingsModel model = state.settingsModel;
                                        model.phoneNumber = val;
                                        widget.screenBloc.add(UpdateCheckoutAddPhoneNumberSettings(settingsModel: model));
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                                        labelText: Language.getPosTpmStrings('tpm.communications.twilio.phone_number_optional'),
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
                                  )
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0, thickness: 0.5, color: Colors.white54,),
                      ListTile(
                        onTap: () {
                          AddPhoneNumberSettingsModel model = state.settingsModel;
                          model.excludeAny = !model.excludeAny;
                          widget.screenBloc.add(UpdateCheckoutAddPhoneNumberSettings(settingsModel: model));

                        },
                        leading: state.settingsModel.excludeAny
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),
                        title: Text(
                          Language.getPosTpmStrings('tpm.communications.twilio.exclude_any'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(height: 0, thickness: 0.5, color: Colors.white54,),
                      ListTile(
                        onTap: () {
                          AddPhoneNumberSettingsModel model = state.settingsModel;
                          model.excludeLocal = !model.excludeLocal;
                          widget.screenBloc.add(UpdateCheckoutAddPhoneNumberSettings(settingsModel: model));
                        },
                        leading: state.settingsModel.excludeLocal
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),
                        title: Text(
                          Language.getPosTpmStrings('tpm.communications.twilio.exclude_local'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(height: 0, thickness: 0.5, color: Colors.white54,),
                      ListTile(
                        onTap: () {
                          AddPhoneNumberSettingsModel model = state.settingsModel;
                          model.excludeForeign = !model.excludeForeign;
                          widget.screenBloc.add(UpdateCheckoutAddPhoneNumberSettings(settingsModel: model));

                        },
                        leading: state.settingsModel.excludeForeign
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),
                        title: Text(
                          Language.getPosTpmStrings('tpm.communications.twilio.exclude_foreign'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(height: 0, thickness: 0.5, color: Colors.white54,),
                      Column(
                        children: state.twilioAddPhoneForm.map((e) {
                          String phone = e[2]['actionData']['phone'] ?? '';
                          String price = e[2]['actionData']['price'] ?? '';
                          return Column(
                            children: <Widget>[
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          e[0]['value'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                        ),
                                        Text(
                                          e[1]['value'],
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    MaterialButton(
                                      minWidth: 0,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context)
                                            {
                                              return new CupertinoAlertDialog(
                                                title: Column(
                                                  children: <Widget>[
                                                    Icon(Icons.warning),
                                                    Text(
                                                      Language.getPosTpmStrings('tpm.communications.twilio.are_you_sure')
                                                    ),
                                                  ],
                                                ),
                                                content: Padding(
                                                  padding: EdgeInsets.only(top: 16),
                                                  child: Text(
                                                    '$phone for $price?',
                                                  ),
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      child: new Text(
                                                        Language.getPosTpmStrings('tpm.communications.twilio.no'),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context, 'Cancel');
                                                      }
                                                  ),
                                                  CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      child: new Text(
                                                        Language.getPosTpmStrings('tpm.communications.twilio.yes'),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        widget.screenBloc.add(
                                                            PurchaseCheckoutNumberEvent(
                                                              action: 'purchase-number',
                                                              id: state.settingsModel.id,
                                                              phone: phone,
                                                              price: price,
                                                            )
                                                        );
                                                        Navigator.pop(context);
                                                      }
                                                  )
                                                ],
                                              );
                                            }
                                        );
                                      },
                                      height: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Colors.black26,
                                      child: Text(
                                        Language.getPosTpmStrings(e[2]['text']),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 0, thickness: 0.5, color: Colors.white54,),
                            ],
                          );
                        }).toList(),
                      ),
                      Container(
                        height: 56,
                        child: SizedBox.expand(
                          child: MaterialButton(
                            minWidth: 0,
                            onPressed: () {
                              AddPhoneNumberSettingsModel model = state.settingsModel;
                              widget.screenBloc.add(
                                  SearchCheckoutPhoneNumberEvent(
                                    id: widget.id,
                                    action: 'search-numbers',
                                    country: model.country.value,
                                    excludeAny: model.excludeAny,
                                    excludeForeign: model.excludeForeign,
                                    excludeLocal: model.excludeLocal,
                                    phoneNumber: phoneNumberController.text,
                                  ));
                            },
                            color: Colors.black87,
                            child: state.isPhoneSearch ? CircularProgressIndicator() :  Text(
                              Language.getPosTpmStrings('tpm.communications.twilio.search'),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        ),
      )
    );
  }
}
