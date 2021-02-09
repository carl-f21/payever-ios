import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/sub_view/dashboard_settings_view.dart';
import 'package:payever/dashboard/sub_view/dashboard_transactions_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/personal/views/personal_setting_screen.dart';
import 'package:payever/personal/views/sub_views/personal_dashboard_social_view.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/views/general/language_screen.dart';
import 'package:payever/settings/views/wallpaper/wallpaper_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/views/transactions_screen.dart';
import 'package:payever/welcome/welcome_screen.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:payever/blocs/bloc.dart';

class PersonalDashboardInitScreen extends StatelessWidget {
  final DashboardScreenBloc dashboardScreenBloc;
  final bool isRefresh;

  const PersonalDashboardInitScreen({this.dashboardScreenBloc, this.isRefresh = false});

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    return PersonalDashboardScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
      isRefresh: isRefresh,
    );
  }
}

class PersonalDashboardScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;
  final bool isRefresh;
  PersonalDashboardScreen({this.globalStateModel, this.dashboardScreenBloc, this.isRefresh = false});

  @override
  _PersonalDashboardScreenState createState() => _PersonalDashboardScreenState();
}

class _PersonalDashboardScreenState extends State<PersonalDashboardScreen> {

  double iconSize;
  double margin;

  PersonalDashboardScreenBloc screenBloc;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String searchString = '';
  Business activeBusiness;

  @override
  void initState() {
    GlobalUtils.isBusinessMode = false;
    MyWallpaper wallpapers = widget.dashboardScreenBloc.state.personalWallpaper;
    String wallpaper = wallpapers.currentWallpaper.wallpaper;
    activeBusiness = widget.globalStateModel.currentBusiness;
    String curWall ='${Env.storage}/wallpapers/$wallpaper';
    print('activeBusiness id ${activeBusiness.id}');
    screenBloc = PersonalDashboardScreenBloc()
      ..add(PersonalScreenInitEvent(
        user: widget.dashboardScreenBloc.state.user,
        personalWallpaper: wallpapers,
        curWall: curWall,
        business: activeBusiness.id,
        isRefresh: widget.isRefresh,
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
      listener: (BuildContext context, PersonalDashboardScreenState state) async {
        if (state is PersonalScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<PersonalDashboardScreenBloc, PersonalDashboardScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, PersonalDashboardScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: MainAppbar(
              dashboardScreenBloc: widget.dashboardScreenBloc,
              dashboardScreenState: widget.dashboardScreenBloc.state,
              title: Language.getCommerceOSStrings('dashboard.personal_title'),
              icon: SvgPicture.asset(
                'assets/images/payeverlogo.svg',
                height: 16,
                width: 24,
              ),
              isBusinessMode: false,
              toggleBusinessMode: true,
            ),
            body: SafeArea(
              bottom: false,
              right: false,
              left: false,
              child: BackgroundBase(
                false,
                backgroundColor: Colors.transparent,
                wallPaper: state.curWall,
                body: _body(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(PersonalDashboardScreenState state) {
    return state.isLoading || state.user == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Align(
          alignment: Alignment.center,
          child: Container(
              alignment: Alignment.center,
              width: GlobalUtils.mainWidth,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  Align(alignment: Alignment.center, child: _headerView(state)),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 175,
                        ),
                        _searchBar(state),
                        SizedBox(height: 16),
                        _socialView(state),
                        SizedBox(height: 16),
                        _transactionView(state),
                        SizedBox(height: 16),
                        _settingsView(state),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        );
  }

  Widget _headerView(PersonalDashboardScreenState state) {
    return Column(
      children: [
        SizedBox(height: 60),
        Text(
          '${Language.getCommerceOSStrings('dashboard.welcome')} ${state.user.firstName ?? '${Language.getCommerceOSStrings('dashboard.undefined')}'},',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3,
                color: Colors.black45,
              ),
            ],
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          Language.getCommerceOSStrings('dashboard.grow.your.business'),
          style: TextStyle(
            fontSize: 18,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3,
                color: Colors.black45,
              ),
            ],
            color: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 64),
        ),
      ],
    );
  }

  Widget _searchBar(PersonalDashboardScreenState state) {
    return BlurEffectView(
      radius: 12,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      isDashboard: true,
      child: Container(
        height: 54,
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/search_place_holder.svg',
              color: iconColor(),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocus,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        isDense: true,
                        border: InputBorder.none,
                        hintText: Language.getTransactionStrings('form.filter.labels.search').toUpperCase(),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (val) {
                        if (val.length > 0) {
                          if (searchString.length > 0) {
                            searchString = val;
                          } else {
                            setState(() {
                              searchString = val;
                            });
                          }
                        } else {
                          if (searchString.length == 0) {
                            searchString = val;
                          } else {
                            setState(() {
                              searchString = val;
                            });
                          }
                        }
                      },
                      onSubmitted: (val) async {
                        FocusScope.of(context).unfocus();
                        if (val.length == 0) {
                          return;
                        }
                        final result = await Navigator.push(
                          context,
                          PageTransition(
                            child: SearchScreen(
                              dashboardScreenBloc: widget.dashboardScreenBloc,
                              businessId: activeBusiness.id,
                              searchQuery: searchController.text,
                              appWidgets: widget.dashboardScreenBloc.state.currentWidgets,
                              activeBusiness: activeBusiness,
                              currentWall: state.curWall,
                            ),
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                        if ((result != null) && (result == 'changed')) {
                          setState(() {
                            searchString = '';
                            searchController.text = searchString;
                            FocusScope.of(context).unfocus();
                          });
                          // screenBloc.add(DashboardScreenInitEvent(
                          //     wallpaper: currentWallpaper));
                        } else {
                          setState(() {
                            searchString = '';
                            searchController.text = searchString;
                            FocusScope.of(context).unfocus();
                          });
                        }
                      },
                    ),
                  ),
                  searchController.text.isEmpty
                      ? Container()
                      : MaterialButton(
                          onPressed: () {
                            setState(() {
                              searchString = '';
                              searchController.text = searchString;
                              FocusScope.of(context).unfocus();
                            });
                          },
                          shape: CircleBorder(
                            side: BorderSide.none,
                          ),
                          color: overlayBackground(),
                          elevation: 0,
                          height: 20,
                          minWidth: 20,
                          child: SvgPicture.asset(
                            'assets/images/closeicon.svg',
                            width: 8,
                            color: iconColor(),
                          ),
                        ),
                  searchController.text.isEmpty
                      ? Container()
                      : MaterialButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            final result = await Navigator.push(
                              context,
                              PageTransition(
                                child: SearchScreen(
                                  dashboardScreenBloc:
                                      widget.dashboardScreenBloc,
                                  businessId: activeBusiness.id,
                                  searchQuery: searchController.text,
                                  appWidgets: widget.dashboardScreenBloc.state.currentWidgets,
                                  activeBusiness: activeBusiness,
                                  currentWall: state.curWall,
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                            if ((result != null) && (result == 'changed')) {
                              setState(() {
                                searchString = '';
                                searchController.text = searchString;
                                FocusScope.of(context).unfocus();
                              });
                              // screenBloc.add(DashboardScreenInitEvent(
                              //     wallpaper: currentWallpaper));
                            } else {
                              setState(() {
                                searchString = '';
                                searchController.text = searchString;
                                FocusScope.of(context).unfocus();
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: overlayBackground(),
                          elevation: 0,
                          minWidth: 0,
                          height: 20,
                          child: Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _socialView(PersonalDashboardScreenState state) {
    return PersonalDashboardSocialView(
      onTapEdit: () {},
      onTapWidget: () {},
    );
  }

  Widget _transactionView(PersonalDashboardScreenState state) {
    AppWidget appWidget = state.personalWidgets
        .where((element) => element.type.contains('transactions'))
        .first;
    BusinessApps businessApps = state.personalApps
        .where((element) => element.code.contains('transactions'))
        .first;
    return appWidget != null
        ? DashboardTransactionsView(
            appWidget: appWidget,
            businessApps: businessApps,
            onTapContinueSetup: (app) {
              _navigateAppsScreen(
                  state,
                  WelcomeScreen(
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                    business: activeBusiness,
                    businessApps: app,
                  ));
            },
            onTapGetStarted: (app) {
              _navigateAppsScreen(
                  state,
                  WelcomeScreen(
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                    business: activeBusiness,
                    businessApps: app,
                  ));
            },
            onOpen: () {
              _navigateAppsScreen(
                  state,
                  TransactionScreenInit(
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                  ));
            })
        : Container();
  }

  Widget _settingsView(PersonalDashboardScreenState state) {
    AppWidget appWidget = state.personalWidgets
        .where((element) => element.type.contains('settings'))
        .first;
    BusinessApps personalApps = state.personalApps
        .where((element) => element.code.contains('settings'))
        .first;
    return DashboardSettingsView(
        businessApps: personalApps,
        appWidget: appWidget,
        openNotification: (NotificationModel model) {},
        onTapOpen: () {
          Provider.of<GlobalStateModel>(context, listen: false)
              .setCurrentBusiness(activeBusiness);
          Provider.of<GlobalStateModel>(context, listen: false)
              .setCurrentWallpaper(state.curWall);
          Navigator.push(
            context,
            PageTransition(
              child: PersonalSettingInitScreen(
                dashboardScreenBloc: widget.dashboardScreenBloc,
                personalDashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
            ),
          );
        },
        onTapOpenWallpaper: () async {
          Navigator.push(
            context,
            PageTransition(
              child: WallpaperScreen(
                globalStateModel: widget.globalStateModel,
                isBusinessMode: false,
                fromDashboard:true,
                setScreenBloc: SettingScreenBloc(
                  dashboardScreenBloc: widget.dashboardScreenBloc,
                  personalDashboardScreenBloc: screenBloc,
                  globalStateModel: widget.globalStateModel,
                  isBusinessMode: false,
                )..add(SettingScreenInitEvent(
                    business: state.business,
                    user: state.user,
                  )),
              ),
              type: PageTransitionType.fade,
            ),
          );
        },
        onTapOpenLanguage: () {
          Navigator.push(
            context,
            PageTransition(
              child: LanguageScreen(
                globalStateModel: widget.globalStateModel,
                settingBloc: SettingScreenBloc(
                  dashboardScreenBloc: widget.dashboardScreenBloc,
                  personalDashboardScreenBloc: screenBloc,
                  globalStateModel: widget.globalStateModel,
                  isBusinessMode: false,
                )..add(SettingScreenInitEvent(
                    business: state.business,
                    user: state.user,
                  )),
                fromDashboard: true,
              ),
              type: PageTransitionType.fade,
            ),
          );
        });
  }

  _navigateAppsScreen(PersonalDashboardScreenState state, Widget target,
      {bool isDuration = false}) {
    Provider.of<GlobalStateModel>(context, listen: false)
        .setCurrentBusiness(activeBusiness);
    Provider.of<GlobalStateModel>(context, listen: false)
        .setCurrentWallpaper(state.curWall);
    Navigator.push(
      context,
      PageTransition(
        child: target,
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: isDuration ? 500 : 300),
      ),
    );
  }
}
