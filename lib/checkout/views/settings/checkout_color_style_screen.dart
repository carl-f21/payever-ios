import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/widgets/color_style_item.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

import '../../../theme.dart';

class CheckoutColorStyleScreen extends StatefulWidget {
  final CheckoutSettingScreenBloc settingBloc;
  final Checkout checkout;

  CheckoutColorStyleScreen(
      {this.settingBloc, this.checkout});

  _CheckoutColorStyleScreenState createState() =>
      _CheckoutColorStyleScreenState();
}

class _CheckoutColorStyleScreenState
    extends State<CheckoutColorStyleScreen> {

  bool isExpandedSection1 = false;
  bool isExpandedSection2 = false;
  bool isExpandedSection3 = false;
  bool isExpandedSection4 = false;

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
    return BlocBuilder<CheckoutSettingScreenBloc, CheckoutSettingScreenState>(
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
                child: CircularProgressIndicator(strokeWidth: 2,),
              )
                  : Center(
                child: _getBody(state),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _appBar(CheckoutSettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(
        'Color and style',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ColorStyleItem(
                  settingBloc: widget.settingBloc,
                  title: 'Header',
                  icon: 'assets/images/style-header.svg',
                  isExpanded: isExpandedSection1,
                  onTap: () {
                    setState(() {
                      isExpandedSection1 = !isExpandedSection1;
                      if (isExpandedSection1)
                        isExpandedSection2 = isExpandedSection3 = isExpandedSection4 = false;
                    });
                  },
                ),
                _divider(),
                ColorStyleItem(
                  settingBloc: widget.settingBloc,
                  title: 'Page',
                  icon: 'assets/images/style-page.svg',
                  isExpanded: isExpandedSection2,
                  onTap: () {
                    setState(() {
                      isExpandedSection2 = !isExpandedSection2;
                      if (isExpandedSection2)
                        isExpandedSection1 = isExpandedSection3 = isExpandedSection4 = false;
                    });
                  },
                ),
                _divider(),
                ColorStyleItem(
                  settingBloc: widget.settingBloc,
                  title: 'Buttons',
                  icon: 'assets/images/style-button.svg',
                  isExpanded: isExpandedSection3,
                  onTap: () {
                    setState(() {
                      isExpandedSection3 = !isExpandedSection3;
                      if (isExpandedSection3)
                        isExpandedSection1 = isExpandedSection2 = isExpandedSection4 = false;
                    });
                  },
                ),
                _divider(),
                ColorStyleItem(
                  settingBloc: widget.settingBloc,
                  title: 'Inputs',
                  icon: 'assets/images/style-input.svg',
                  isExpanded: isExpandedSection4,
                  onTap: () {
                    setState(() {
                      isExpandedSection4 = !isExpandedSection4;
                      if (isExpandedSection4)
                        isExpandedSection1 = isExpandedSection2 = isExpandedSection3 = false;
                    });
                  },
                ),
                _divider(),
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: state.isUpdating ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ) : MaterialButton(
                    onPressed: () {
                      resetStyles();
                    },
                    color: overlayBackground(),
                    child: Text(
                      'Reset styles',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetStyles() {
    Style style = Style();
    style.id = widget.checkout.settings.styles.id;
    style.id1 = widget.checkout.settings.styles.id1;
    widget.checkout.settings.styles = style;
    widget.settingBloc.add(UpdateCheckoutSettingsEvent());
  }

  Widget _divider() {
    return Divider(
      height: 0,
      thickness: 0.5,
      color: Colors.grey,
    );
  }
}
