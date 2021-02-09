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

class CheckoutMessageScreen extends StatefulWidget {

  final CheckoutSettingScreenBloc settingBloc;
  final Checkout checkout;

  CheckoutMessageScreen(
      {this.settingBloc, this.checkout});

  _CheckoutMessageScreenState createState() => _CheckoutMessageScreenState();

}

class _CheckoutMessageScreenState extends State<CheckoutMessageScreen> {
  TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.checkout.settings.message);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget.settingBloc,
        listener: (BuildContext context, CheckoutSettingScreenState state) async {
          if (state is CheckoutSettingScreenStateSuccess) {
            Navigator.pop(context);
          } else if (state is CheckoutSettingScreenStateFailure) {
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
        Language.getConnectStrings('actions.edit'),
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

  Widget _getBody(CheckoutSettingScreenState state) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          radius: 20,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12),
                child: BlurEffectView(
                  radius: 8,
                  child: TextFormField(
                    onSaved: (val) {

                    },
                    onChanged: (val) {
                      setState(() {
                      });
                    },
                    controller: controller,
                    validator: (value) {
                      return null;
                    },
                    decoration: new InputDecoration(
                      labelText: 'Message',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(left: 16, right: 16),
                    ),
                    style: TextStyle(fontSize: 16),
                    keyboardType: TextInputType.url,
                  ),
                ),
              ),
              Container(
                height: 50,
                color: Colors.black87,
                child: SizedBox.expand(
                  child: InkWell(
                    onTap: () {
                      widget.checkout.settings.message = controller.text;
                      widget.settingBloc.add(UpdateCheckoutSettingsEvent());
                    },

                    child: state.isUpdating
                        ? CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                        : Container(
                      color: overlayBackground(),
                      alignment: Alignment.center,
                          child: Text(
                      Language.getCommerceOSStrings('actions.save'),
                    ),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}