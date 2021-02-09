import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/theme.dart';

class CheckoutLanguagesScreen extends StatefulWidget {

  final CheckoutSettingScreenBloc settingBloc;
  final Checkout checkout;

  CheckoutLanguagesScreen(
      {this.settingBloc, this.checkout});

  _CheckoutLanguagesScreenState createState() => _CheckoutLanguagesScreenState();

}

class _CheckoutLanguagesScreenState extends State<CheckoutLanguagesScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget.settingBloc,
        listener: (BuildContext context, CheckoutSettingScreenState state) async {
          if (state is CheckoutSettingScreenStateFailure) {
          }
        },
      child: BlocBuilder<CheckoutSettingScreenBloc, CheckoutSettingScreenState>(
        bloc: widget.settingBloc,
        builder: (BuildContext context, CheckoutSettingScreenState state) {
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
                  child: _getBody(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(CheckoutSettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        Language.getConnectStrings('Add Language'),
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

  Widget _getBody(CheckoutSettingScreenState state) {
    if (widget.checkout.id == null) {
      return Container();
    }
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          child: Wrap(
            children: <Widget>[
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Lang lang = widget.checkout.settings.languages[index];
                  return Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            lang.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            lang.isDefault ? Text(
                              Language.getPosStrings('edit_locales.default'),
                            ): (lang.active ? MaterialButton(
                              onPressed: () {
                                widget.checkout.settings.languages.forEach((element) {
                                  element.isDefault = (element == lang);
                                });
                                widget.settingBloc.add(UpdateCheckoutSettingsEvent());
                              },
                              color: overlayBackground(),
                              elevation: 0,
                              height: 24,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minWidth: 0,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                Language.getPosStrings('actions.set_as_default'),
                              ),
                            ): Container()),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: lang.active,
                                onChanged: (val) {
                                  lang.active = val;
                                  widget.settingBloc.add(UpdateCheckoutSettingsEvent());
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Colors.grey,
                  );
                },
                itemCount: widget.checkout.settings.languages.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}