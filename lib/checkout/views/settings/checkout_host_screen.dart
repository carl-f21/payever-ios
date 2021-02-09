import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/theme.dart';

class CheckoutCSPAllowedHostScreen extends StatefulWidget {
  final CheckoutSettingScreenBloc settingBloc;
  final Checkout checkout;

  CheckoutCSPAllowedHostScreen(
      {this.settingBloc, this.checkout});

  _CheckoutCSPAllowedHostScreenState createState() =>
      _CheckoutCSPAllowedHostScreenState();
}

class _CheckoutCSPAllowedHostScreenState
    extends State<CheckoutCSPAllowedHostScreen> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.checkout.settings.cspAllowedHosts.isEmpty == false) {
      widget.checkout.settings.cspAllowedHosts.forEach((element) {
        controllers.add(TextEditingController(text: element));
      });
    } else {
      controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((element) {
      element.dispose();
    });
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
                body: state.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
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
        Language.getConnectStrings('CSP allowed hosts'),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32, maxWidth: 32, minHeight: 32, minWidth: 32),
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
          radius: 12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _currentHosts(),
              Container(
                height: 50,
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        controllers.add(TextEditingController());
                      });
                    },
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: <Widget>[
                        Text(
                          Language.getConnectStrings('actions.addPlus'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                color: Colors.black87,
                child: SizedBox.expand(
                  child: InkWell(
                    onTap: () {
                      List<String> hosts = [];
                      controllers.forEach((element) {
                        hosts.add(element.text);
                      });
                      widget.checkout.settings.cspAllowedHosts = hosts;
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

  Widget _currentHosts() {
    return Container(
      height: 56.0 * controllers.length,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              height: 56,
              color: overlayBackground(),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      onSaved: (val) {},
                      onChanged: (val) {
                        setState(() {});
                      },
                      controller: controllers[index],
                      validator: (value) {
                        return null;
                      },
                      decoration: new InputDecoration(
                        labelText: 'Host',
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
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        controllers.removeAt(index);
                      });
                    },
                    minWidth: 0,
                    child: SvgPicture.asset('assets/images/closeicon.svg', color: iconColor(),),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return Divider(
              height: 0,
              thickness: 1,
            );
          },
          itemCount: controllers.length),
    );
  }
}
