import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/settings/checkout_host_screen.dart';
import 'package:payever/checkout/views/settings/checkout_languages_screen.dart';
import 'package:payever/checkout/views/settings/checkout_message_screen.dart';
import 'package:payever/checkout/views/settings/checkout_phone_number_screen.dart';
import 'package:payever/checkout/views/settings/checkout_policy_screen.dart';
import 'package:payever/checkout/views/settings/checkout_color_style_screen.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';

class CheckoutSettingsScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutSettingsScreen(this.checkoutScreenBloc);

  @override
  _CheckoutSettingsScreenState createState() => _CheckoutSettingsScreenState();
}

class _CheckoutSettingsScreenState extends State<CheckoutSettingsScreen> {
  CheckoutSettingScreenBloc screenBloc;
  String clipboardString;
  Checkout defaultCheckout;
  @override
  void initState() {
    defaultCheckout = widget.checkoutScreenBloc.state.defaultCheckout;
    screenBloc = CheckoutSettingScreenBloc(checkoutScreenBloc: widget.checkoutScreenBloc);
    screenBloc.add(CheckoutSettingScreenInitEvent(businessId: widget.checkoutScreenBloc.state.activeBusiness.id, checkout: defaultCheckout));
    Clipboard.getData('text/plain').then((value) {
      setState(() {
        if (value != null)
          clipboardString = value.text;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, state) {
        if (state is CheckoutSettingScreenStateFailure) {
        }
      },
      child: BlocBuilder<CheckoutSettingScreenBloc, CheckoutSettingScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: Appbar(Language.getConnectStrings('categories.communications.main.titles.settings')),
              body: SafeArea(
                bottom: false,
                  child: BackgroundBase(true, body: _body(state))));
        },
      ),
    );
  }

  Widget _body(CheckoutSettingScreenState state) {
    if (defaultCheckout == null || defaultCheckout.settings.styles == null ||state.isUpdating) {
      return Center(
        child: Container(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }
    String defaultLanguage = '';
    List<Lang> langs = defaultCheckout.settings.languages.where((element) => element.active).toList();
    if (langs.length > 0) {
      defaultLanguage = langs.first.name;
    }
    if (widget.checkoutScreenBloc.state.channelSet == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: GlobalUtils.mainWidth,
          child: BlurEffectView(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Testing mode',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: defaultCheckout.settings.testingMode,
                            onChanged: (value) {
                              defaultCheckout.settings.testingMode = value;
                              screenBloc.add(UpdateCheckoutSettingsEvent());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'CSP allowed hosts',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: CheckoutCSPAllowedHostScreen(
                                  settingBloc: screenBloc,
                                  checkout: defaultCheckout,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: overlayBackground(),
                          elevation: 0,
                          height: 24,
                          minWidth: 0,
                          child: Text(
                            Language.getPosStrings('actions.edit'),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'Color and style',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: defaultCheckout.settings.styles.active ?? false,
                                onChanged: (value) {
                                  defaultCheckout.settings.styles.active = value;
                                  screenBloc.add(UpdateCheckoutSettingsEvent());
                                },
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: CheckoutColorStyleScreen(
                                      settingBloc: screenBloc,
                                      checkout: defaultCheckout,
                                    ),
                                    type: PageTransitionType.fade,
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: overlayBackground(),
                              elevation: 0,
                              height: 24,
                              minWidth: 0,
                              child: Text(
                                Language.getPosStrings('actions.edit'),
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Language',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Flexible(
                          child: Text(
                            '$defaultLanguage (default)',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: CheckoutLanguagesScreen(
                                  settingBloc: screenBloc,
                                  checkout: defaultCheckout,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: overlayBackground(),
                          elevation: 0,
                          height: 24,
                          minWidth: 0,
                          child: Text(
                            Language.getPosStrings('actions.edit'),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Phone number',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Flexible(
                          child: Text(
                            defaultCheckout.settings.phoneNumber ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: CheckoutPhoneNumberScreen(
                                  settingBloc: this.screenBloc,
                                  checkout: defaultCheckout,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: overlayBackground(),
                          elevation: 0,
                          height: 24,
                          minWidth: 0,
                          child: Text(
                            Language.getPosStrings('actions.edit'),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Message',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Flexible(
                          child: Text(
                            defaultCheckout.settings.message ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: CheckoutMessageScreen(
                                  settingBloc: screenBloc,
                                  checkout: defaultCheckout,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: overlayBackground(),
                          elevation: 0,
                          height: 24,
                          minWidth: 0,
                          child: Text(
                            Language.getPosStrings('actions.edit'),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'Policies',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: CheckoutPoliciesScreen(
                                  checkoutScreenBloc: widget.checkoutScreenBloc,
                                  settingBloc: screenBloc,
                                  checkout: defaultCheckout,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: overlayBackground(),
                          elevation: 0,
                          height: 24,
                          minWidth: 0,
                          child: Text(
                            Language.getPosStrings('actions.edit'),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Channel Set ID',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Flexible(
                          child: Text(
                            widget.checkoutScreenBloc.state.channelSet.id,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: widget.checkoutScreenBloc.state
                                    .channelSet.id));
                            setState(() {
                              clipboardString = widget.checkoutScreenBloc.state
                                  .channelSet.id;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: overlayBackground(),
                          elevation: 0,
                          height: 24,
                          minWidth: 0,
                          child: Text(
                            clipboardString == widget.checkoutScreenBloc.state
                                .channelSet.id
                                ? 'copied'
                                : Language.getPosStrings('actions.copy'),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
