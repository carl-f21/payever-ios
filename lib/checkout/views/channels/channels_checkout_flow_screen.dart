import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/checkout/widgets/checkout_flow.dart';
import 'package:payever/checkout/widgets/workshop_top_bar.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';

class ChannelCheckoutFlowScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;
  final String openUrl;
  final bool fromDashboard;

  ChannelCheckoutFlowScreen({
    this.checkoutScreenBloc,
    this.openUrl,
    this.fromDashboard = false,
  });

  @override
  _ChannelCheckoutFlowScreenState createState() =>
      _ChannelCheckoutFlowScreenState();
}

class _ChannelCheckoutFlowScreenState extends State<ChannelCheckoutFlowScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (widget.fromDashboard) {
      widget.checkoutScreenBloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomPadding: false,
        appBar: CustomAppBar(
          widget.checkoutScreenBloc, widget.openUrl
        ),
        body: SafeArea(
          bottom: false,
          child: BackgroundBase(
            true,
            body: CheckoutFlowWebView(
              checkoutScreenBloc: widget.checkoutScreenBloc,
              checkoutUrl: widget.openUrl,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final CheckoutScreenBloc checkoutScreenBloc;
  final String openUrl;
  CustomAppBar(this.checkoutScreenBloc, this.openUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.bottomCenter,
      child:
          /*WorkshopTopBar(
        openUrl: openUrl,
        title: 'Pay by Link Editing',
        onCloseTap: () {
          Navigator.pop(context);
        },
      )*/
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Pay by Link Editing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
