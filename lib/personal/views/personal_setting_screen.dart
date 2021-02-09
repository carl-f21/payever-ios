import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/settings/views/general/language_screen.dart';
import 'package:payever/settings/views/general/password_screen.dart';
import 'package:payever/settings/views/general/personal_information_screen.dart';
import 'package:payever/settings/views/general/shipping_addresses_screen.dart';
import 'package:payever/settings/views/wallpaper/wallpaper_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';

class PersonalSettingInitScreen extends StatelessWidget {
  final DashboardScreenBloc dashboardScreenBloc;
  final PersonalDashboardScreenBloc personalDashboardScreenBloc;
  PersonalSettingInitScreen({
    this.dashboardScreenBloc,
    this.personalDashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return PersonalSettingScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
      personalDashboardScreenBloc: personalDashboardScreenBloc,
    );
  }
}

class PersonalSettingScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;
  final PersonalDashboardScreenBloc personalDashboardScreenBloc;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;

  PersonalSettingScreen({
    this.globalStateModel,
    this.dashboardScreenBloc,
    this.checkouts = const [],
    this.defaultCheckout,
    this.personalDashboardScreenBloc,
  });

  @override
  State<StatefulWidget> createState() {
    return _PersonalSettingScreenState();
  }
}

class _PersonalSettingScreenState extends State<PersonalSettingScreen> {
  bool _isPortrait;
  bool _isTablet;

  double iconSize;
  double margin;

  int selectedIndex = 0;
  SettingScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = SettingScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
      globalStateModel: widget.globalStateModel,
      personalDashboardScreenBloc: widget.personalDashboardScreenBloc,
      isBusinessMode: false,
    )..add(SettingScreenInitEvent(
        business: widget.globalStateModel.currentBusiness.id,
        user: widget.dashboardScreenBloc.state.user,
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

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, SettingScreenState state) async {
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
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
              appBar: MainAppbar(
                dashboardScreenBloc: widget.dashboardScreenBloc,
                dashboardScreenState: widget.dashboardScreenBloc.state,
                title: Language.getCommerceOSStrings(
                    'info_boxes.settings.heading'),
                icon: SvgPicture.asset(
                  'assets/images/setting.svg',
                  width: 20,
                  height: 20,
                ),
              ),
              body: SafeArea(
                  bottom: false,
                  child: BackgroundBase(
                    true,
                    body: Column(
                      children: [
                        _toolBar(state),
                        Expanded(child: _body(state)),
                      ],
                    ),
                  )));
        },
      ),
    );
  }

  Widget _toolBar(SettingScreenState state) {
    return Container(
      height: 50,
      width: double.infinity,
      color: overlaySecondAppBar(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            PosTopButton(
              title: Language.getSettingsStrings('info_boxes.panels.general.menu_list.personal_information.title'),
              selectedIndex: selectedIndex,
              index: 0,
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
            PosTopButton(
              title: Language.getSettingsStrings('info_boxes.panels.general.menu_list.language.title'),
              selectedIndex: selectedIndex,
              index: 1,
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
            PosTopButton(
              title: Language.getSettingsStrings('info_boxes.panels.general.menu_list.shipping_address.title'),
              index: 2,
              selectedIndex: selectedIndex,
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
            ),
            PosTopButton(
              title: Language.getSettingsStrings('info_boxes.panels.general.menu_list.password.title'),
              selectedIndex: selectedIndex,
              index: 3,
              onTap: () {
                setState(() {
                  selectedIndex = 3;
                });
              },
            ),
            PosTopButton(
              title: Language.getSettingsStrings('info_boxes.panels.general.menu_list.email_notifications.title'),
              selectedIndex: selectedIndex,
              index: 4,
              onTap: () {
                setState(() {
                  selectedIndex = 4;
                });
              },
            ),
            PosTopButton(
              title: Language.getSettingsStrings('info_boxes.panels.wallpaper.title'),
              selectedIndex: selectedIndex,
              index: 5,
              onTap: () {
                setState(() {
                  selectedIndex = 5;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(SettingScreenState state) {
    iconSize = _isTablet ? 120 : 80;
    margin = _isTablet ? 24 : 16;
    return _getBody(state, selectedIndex);
  }

  Widget _getBody(SettingScreenState state, int index) {
    switch (index) {
      case 0:
        return state.user != null
            ? PersonalInformationScreen(
                globalStateModel: widget.globalStateModel,
                setScreenBloc: screenBloc,
                isDashboard: false,
              )
            : Container();
      case 1:
        return state.user != null
            ? LanguageScreen(
                globalStateModel: widget.globalStateModel,
                settingBloc: screenBloc,
                isDashboard: false,
              )
            : Container();
      case 2:
        return state.user != null
            ? ShippingAddressesScreen(
                globalStateModel: widget.globalStateModel,
                setScreenBloc: screenBloc,
                isDashboard: false,
              )
            : Container();
      case 3:
        return state.user != null
            ? PasswordScreen(
                globalStateModel: widget.globalStateModel,
                setScreenBloc: screenBloc,
                isDashboard: false,
              )
            : Container();
      case 4:
        return Container();
      case 5:
        return state.user != null
            ? WallpaperScreen(
                globalStateModel: widget.globalStateModel,
                setScreenBloc: screenBloc,
                isBusinessMode: false,
              )
            : Container();
    }
    return Container();
  }
}
