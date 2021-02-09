import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/theme.dart';

class ConnectAddPaymentConnectionScreen extends StatefulWidget {

  final ConnectSettingsDetailScreenBloc screenBloc;

  ConnectAddPaymentConnectionScreen(
      {this.screenBloc,});

  _ConnectAddPaymentConnectionScreenState createState() => _ConnectAddPaymentConnectionScreenState();

}

class _ConnectAddPaymentConnectionScreenState extends State<ConnectAddPaymentConnectionScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget.screenBloc,
        listener: (BuildContext context, ConnectSettingsDetailScreenState state) async {
          if (state is CheckoutSettingScreenStateFailure) {
          } else if (state is CheckoutPaymentSettingScreenSuccess) {
            Navigator.pop(context);
            widget.screenBloc.add(ConnectSettingsDetailScreenInitEvent(business: state.business, connectModel: state.connectModel));
          }
        },
      child: BlocBuilder<ConnectSettingsDetailScreenBloc, ConnectSettingsDetailScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ConnectSettingsDetailScreenState state) {
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
                  child: _getBody(state),
                ),
              ),
            ),
          );
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
        Language.getConnectStrings('Add connection'),
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

  Widget _getBody(ConnectSettingsDetailScreenState state) {
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
                      labelText: 'Name',
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
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      if (controller.text.isEmpty) {
                        Fluttertoast.showToast(msg: 'Name required');
                        return;
                      }
                      widget.screenBloc.add(ConnectAddPaymentOptionEvent(name: controller.text));
                    },
                    color: overlayBackground(),
                    child: state.isAdding
                        ? CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                        : Text(
                      Language.getConnectStrings('actions.add'),
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