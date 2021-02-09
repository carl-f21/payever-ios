import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/channels/channels_screeen.dart';
import 'package:payever/checkout/views/connect/connect_screen.dart';
import 'package:payever/checkout/views/payments/payment_options_screen.dart';
import 'package:payever/checkout/views/sections/sections_screen.dart';
import 'package:payever/checkout/views/settings/settings_screen.dart';
import 'package:payever/checkout/views/workshop/checkout_switch_screen.dart';
import 'package:payever/checkout/views/workshop/create_edit_checkout_screen.dart';
import 'package:payever/checkout/views/workshop/prefilled_qr_screen.dart';
import 'package:payever/checkout/views/workshop/subview/work_shop_view.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'connect/checkout_qr_integration.dart';

class CheckoutInitScreen extends StatelessWidget {
  final DashboardScreenBloc dashboardScreenBloc;

  CheckoutInitScreen({
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return CheckoutScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  CheckoutScreen({
    this.globalStateModel,
    this.dashboardScreenBloc,
  });

  @override
  State<StatefulWidget> createState() {
    return _CheckoutScreenState();
  }
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isPortrait;
  bool _isTablet;

  double iconSize;
  double margin;

  int selectedIndex = 0;
  CheckoutScreenBloc screenBloc;
  double mainWidth = 0;
  final _formKeyOrder = GlobalKey<FormState>();

  @override
  void initState() {
    screenBloc = CheckoutScreenBloc(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        globalStateModel: widget.globalStateModel)
      ..add(CheckoutScreenInitEvent(
        business: widget.dashboardScreenBloc.state.activeBusiness,
        terminal: widget.dashboardScreenBloc.state.activeTerminal,
        checkouts: widget.dashboardScreenBloc.state.checkouts,
        defaultCheckout: widget.dashboardScreenBloc.state.defaultCheckout,
        channelSets: widget.dashboardScreenBloc.state.channelSets,
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
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    if (mainWidth == 0) {
      mainWidth = GlobalUtils.isTablet(context)
          ? Measurements.width * 0.7
          : Measurements.width;
    }
    iconSize = _isTablet ? 120 : 80;
    margin = _isTablet ? 24 : 16;

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, CheckoutScreenState state) async {
        if (state is CheckoutScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else  if (state.qrImage != null) {
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
      child: BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutScreenState state) {
          return Scaffold(
            backgroundColor: overlayBackground(),
            appBar: MainAppbar(
              dashboardScreenBloc: widget.dashboardScreenBloc,
              dashboardScreenState: widget.dashboardScreenBloc.state,
              title: Language.getCommerceOSStrings('dashboard.apps.checkout'),
              icon: SvgPicture.asset(
                'assets/images/checkout.svg',
                height: 20,
                width: 20,
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: Column(
                  children: <Widget>[
                    // _toolBar(state),
                    // Expanded(child: _getBody(state)),
                    Expanded(
                      child: _body(state),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(CheckoutScreenState state) {
    if (state.isLoading || state.channelSet == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    String defaultCheckoutTitle = '-';
    if (state.defaultCheckout != null) {
      defaultCheckoutTitle = state.defaultCheckout.name;
    }
    String openUrl =
        '${Env.wrapper}/pay/create-flow/channel-set-id/${state.channelSet.id}';
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Container(
          width: mainWidth,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: overlayBackground(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    if (state.activeTerminal != null)
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            navigateWorkshopView(state);
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        Color(0xFFa3a9b8),
                                        Color(0xFF868a95),
                                      ]),
                                ),
                                child: Text(
                                  getDisplayName(defaultCheckoutTitle),
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text(
                                defaultCheckoutTitle,
                                style: TextStyle(fontSize: 18),
                              )),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    divider,
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: CheckoutSwitchScreen(
                                    businessId: state.activeBusiness.id,
                                    checkoutScreenBloc: screenBloc,
                                    onOpen: (Checkout checkout) {
                                      setState(() {});
                                    },
                                  ),
                                  type: PageTransitionType.fade));
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/checkout-switch.svg',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Text(
                              'Switch checkout',
                              style: TextStyle(fontSize: 18),
                            )),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: CreateEditCheckoutScreen(
                                    businessId: state.activeBusiness.id,
                                    fromDashBoard: false,
                                    screenBloc: CheckoutSwitchScreenBloc(),
                                  ),
                                  type: PageTransitionType.fade));
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/checkout-add.svg',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Text(
                              'Add new checkout',
                              style: TextStyle(fontSize: 18),
                            )),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: overlayBackground(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          Clipboard.setData(new ClipboardData(text: openUrl));
                          Fluttertoast.showToast(msg: 'Link successfully copied');
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/pay_link.svg',
                              width: 24,
                              height: 24,
                              color: iconColor(),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Text(
                              'Copy pay link',
                              style: TextStyle(fontSize: 18),
                            )),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          if (state.channelSetFlow == null ||
                              state.channelSetFlow.amount < 1 ||
                              state.channelSetFlow.reference == null) {
                            navigateWorkshopView(state, isCopyLink: true);
                          } else {
                            getPrefilledLink(state, true);
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/prefilled_link.svg',
                              width: 24,
                              height: 24,
                              color: iconColor(),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Text(
                              'Copy prefilled link',
                              style: TextStyle(fontSize: 18),
                            )),
                            state.isLoadingPrefilledLink
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  )
                                : Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          _sendMail(
                              '',
                              'Pay by payever Link',
                              'Dear customer, \\n'
                                  '${state.activeBusiness.name} would like to invite you to pay online via payever. Please click the link below in order to pay for your purchase at ${state.activeBusiness.name}.\\n'
                                  '$openUrl\\n'
                                  ' For any questions to ${state.activeBusiness.name} regarding the purchase itself, please reply to this email, for technical questions or questions regarding your payment, please email support@payever.de.');
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/email_link.svg',
                              width: 24,
                              height: 24,
                              color: iconColor(),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Text(
                              'E-mail prefilled link',
                              style: TextStyle(fontSize: 18),
                            )),
                            Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Container(
                      height: 61,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: InkWell(
                        onTap: () {
                          if (state.channelSetFlow == null ||
                              state.channelSetFlow.amount < 1 ||
                              state.channelSetFlow.reference == null) {
                            navigateWorkshopView(state, isCopyLink: false);
                          } else {
                            getPrefilledLink(state, false);
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/qr-generator.svg',
                              width: 24,
                              height: 24,
                              color: iconColor(),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Text(
                              'Prefilled QR code',
                              style: TextStyle(fontSize: 18),
                            )),
                            state.isLoadingQrcode
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  )
                                : Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              if (state.defaultCheckout != null)
                Container(
                  decoration: BoxDecoration(
                    color: overlayBackground(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: PaymentOptionsScreen(screenBloc),
                                    type: PageTransitionType.fade));
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/checkout-payment.svg',
                                width: 24,
                                height: 24,
                                color: iconColor(),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text(
                                'Payment options',
                                style: TextStyle(fontSize: 18),
                              )),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: ChannelsScreen(screenBloc),
                                    type: PageTransitionType.fade));
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/checkout-channels.svg',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text(
                                Language.getWidgetStrings(
                                    'widgets.checkout.channels'),
                                style: TextStyle(fontSize: 18),
                              )),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: ConnectScreen(screenBloc),
                                    type: PageTransitionType.fade));
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${Env.cdnIcon}icon-comerceos-connect-not-installed.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text(
                                Language.getCommerceOSStrings(
                                    'dashboard.apps.connect'),
                                style: TextStyle(fontSize: 18),
                              )),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: CheckoutSettingsScreen(screenBloc),
                                    type: PageTransitionType.fade));
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${Env.cdnIcon}icon-comerceos-settings-not-installed.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text(
                                Language.getConnectStrings(
                                    'categories.communications.main.titles.settings'),
                                style: TextStyle(fontSize: 18),
                              )),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                      divider,
                      Container(
                        height: 61,
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: SectionsScreen(screenBloc),
                                    type: PageTransitionType.fade));
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/checkout-section.svg',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text(
                                'Sections',
                                style: TextStyle(fontSize: 18),
                              )),
                              Icon(Icons.arrow_forward_ios, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateWorkshopView(CheckoutScreenState state, {bool isCopyLink}) {
    Navigator.push(
        context,
        PageTransition(
            child: WorkshopView(
              checkoutScreenBloc: isCopyLink == null ? null : screenBloc,
              business: state.activeBusiness,
              terminal: state.activeTerminal,
              channelSetId: state.channelSet.id,
              defaultCheckout: state.defaultCheckout,
              channelSetFlow: state.channelSetFlow,
              fromCart: false,
              isCopyLink: isCopyLink,
              onTapClose: () {},
            ),
            type: PageTransitionType.fade));
  }

  get divider {
    return Divider(
      height: 0,
      indent: 50,
      thickness: 0.5,
      color: Colors.grey[500],
    );
  }

  _sendMail(String toMailId, String subject, String body) async {
    var url = Uri.encodeFull('mailto:$toMailId?subject=$subject&body=$body');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getPrefilledLink(CheckoutScreenState state, bool isCopyLink) {
//    if (_formKeyOrder.currentState.validate()) {
      num _amount = state.channelSetFlow.amount;
      String _reference = state.channelSetFlow.reference;
      if (_amount >= 0 && _reference != null) {
        screenBloc.add(CheckoutGetPrefilledLinkEvent(isCopyLink: isCopyLink));
      } else {
        Fluttertoast.showToast(msg: 'Please set amount and reference.');
      }
    }
//  }
}
