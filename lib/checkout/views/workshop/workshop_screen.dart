import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/channels/channels_checkout_flow_screen.dart';
import 'package:payever/checkout/views/workshop/prefilled_qr_screen.dart';
import 'package:payever/checkout/views/workshop/subview/work_shop_view.dart';
import 'package:payever/checkout/widgets/workshop_top_bar.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'checkout_switch_screen.dart';

class WorkshopScreen extends StatefulWidget {
  final CheckoutScreenBloc checkoutScreenBloc;

  const WorkshopScreen(
      {this.checkoutScreenBloc});

  @override
  _WorkshopScreenState createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {

  final _formKeyOrder = GlobalKey<FormState>();
  WorkshopScreenBloc screenBloc;
  bool switchCheckout = false;
  @override
  void initState() {
    screenBloc =
        WorkshopScreenBloc()
          ..add(WorkshopScreenInitEvent(
            activeBusiness: widget.checkoutScreenBloc.state.activeBusiness,
            activeTerminal: widget.checkoutScreenBloc.state.activeTerminal,
            channelSetId: widget.checkoutScreenBloc.state.channelSet.id,
            defaultCheckout: widget.checkoutScreenBloc.state.defaultCheckout,
          ));
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
      listener: (BuildContext context, WorkshopScreenState state) async {
         if (state.qrImage != null) {
          Navigator.push(
            context,
            PageTransition(
              child: PrefilledQRCodeScreen(
                qrForm: state.qrForm,
                qrImage: state.qrImage,
                title: 'QR',
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<WorkshopScreenBloc, WorkshopScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: Appbar(state.defaultCheckout.name),
              body: SafeArea(
                  bottom: false,
                  child: BackgroundBase(true, body: _body(state))));
        },
      ),
    );
  }

  Widget _body(WorkshopScreenState state) {
    if (switchCheckout) {
      return CheckoutSwitchScreen(
        businessId: state.activeBusiness.id,
        checkoutScreenBloc: widget.checkoutScreenBloc,
        onOpen: (Checkout checkout) {
          setState(() {
            switchCheckout = false;
          });
        },
      );
    }
    if (state.channelSetId == null) {
      print('channelSet is null');
      print('${state.runtimeType} is null');
      return Container();
    }

    String openUrl =
        '${Env.wrapper}/pay/create-flow/channel-set-id/${state.channelSetId}';
    return Container(
      child: Column(
        children: <Widget>[
          WorkshopTopBar(
            title: 'Your checkout',
            businessName: state.activeBusiness.name,
            openUrl: openUrl,
            isLoadingQrcode: state.isLoadingQrcode,
            onTapSwitchCheckout: () {
              setState(() {
                setState(() {
                  switchCheckout = true;
                });
              });
            },
            onOpenTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: ChannelCheckoutFlowScreen(
                    checkoutScreenBloc: widget.checkoutScreenBloc,
                    openUrl: openUrl,
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
            onCopyPrefilledLink: () {
              getPrefilledLink(state, true);
            },
            onPrefilledQrcode: () {
              getPrefilledLink(state, false);
            },
          ),
          Flexible(
            child: WorkshopView(
//              workshopScreenBloc: screenBloc,
              formKeyOrder: _formKeyOrder,
            ),
          ),
        ],
      ),
    );
  }

  void getPrefilledLink(WorkshopScreenState state, bool isCopyLink) {
    if (_formKeyOrder.currentState.validate()) {
      num _amount = state.channelSetFlow.amount;
      String _reference = state.channelSetFlow.reference;
      if (_amount >= 0 && _reference != null) {
        screenBloc.add(GetPrefilledLinkEvent(isCopyLink: isCopyLink));
      } else {
        Fluttertoast.showToast(msg: 'Please set amount and reference.');
      }
    }
  }

}
