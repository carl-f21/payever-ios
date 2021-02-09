import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/models/user.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/views/appearance_screen.dart';
import 'package:payever/settings/views/business_info_screen.dart';
import 'package:payever/settings/views/employee/employee_screen.dart';
import 'package:payever/settings/views/general/general_screen.dart';
import 'package:payever/settings/views/policies/policies_screen.dart';
import 'package:payever/settings/views/wallpaper/wallpaper_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:payever/blocs/bloc.dart';
import 'business_details/business_details_screen.dart';

class SettingInitScreen extends StatelessWidget {
  final DashboardScreenBloc dashboardScreenBloc;

  const SettingInitScreen({this.dashboardScreenBloc});

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    return SettingScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class SettingScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  SettingScreen(
      {this.globalStateModel, this.dashboardScreenBloc});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}


List<SettingItem> settingItems = [
  SettingItem(name: 'Business Info', image: 'assets/images/setting-info.svg'),
  SettingItem(
      name: Language.getSettingsStrings('info_boxes.panels.business_details.title'), image: 'assets/images/setting-business.svg'),
  SettingItem(name: Language.getSettingsStrings('info_boxes.panels.wallpaper.title'), image: 'assets/images/setting-wallpaper.svg'),
  SettingItem(name: Language.getSettingsStrings('info_boxes.panels.employee.title'), image: 'assets/images/setting-employee.svg'),
  SettingItem(name: Language.getSettingsStrings('info_boxes.panels.policies.title'), image: 'assets/images/setting-policies.svg'),
  SettingItem(name: Language.getSettingsStrings('info_boxes.panels.general.title'), image: 'assets/images/setting-general.svg'),
  SettingItem(
      name: 'Appearance', image: 'assets/images/setting-appearance.svg'),
];

class _SettingScreenState extends State<SettingScreen> {
  bool _isPortrait;
  bool _isTablet;
  double iconSize;
  double margin;
  List<Country> countryList;

  SettingScreenBloc screenBloc;
  String salutation;
  String firstName;
  String lastName;
  String phone;
  String email;
  String birthDay;

  @override
  void initState() {
    screenBloc = SettingScreenBloc(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        globalStateModel: widget.globalStateModel);
    screenBloc.add(SettingScreenInitEvent(
      business: widget.globalStateModel.currentBusiness.id,
      user: widget.dashboardScreenBloc.state.user,
    ));

    User user = widget.dashboardScreenBloc.state.user;
    if (user != null) {
      salutation = user.salutation;
      firstName = user.firstName;
      lastName = user.lastName;
      phone = user.phone;
      email = user.email;
      birthDay = user.birthday;
    }

    prepareDefaultCountries().then((value) => countryList = value);
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
        if (state is SettingScreenStateFailure) {
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
              title:
              Language.getCommerceOSStrings('info_boxes.settings.heading'),
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
                  body: _body(state)
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(SettingScreenState state) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    String avatarName = '';
    if (widget.globalStateModel.currentBusiness != null) {
      String name = widget.globalStateModel.currentBusiness.name;
      if (name.contains(' ')) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(' ')[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    } else {
      return Container();
    }
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                widget.globalStateModel.currentBusiness.logo != null
                    ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffa0a7aa),
                          image: DecorationImage(
                            image: NetworkImage(
                                '$imageBase${widget.globalStateModel.currentBusiness.logo}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          backgroundColor: Color(0xffa0a7aa),
                          child: Text(
                            avatarName,
                            style: TextStyle(
                              fontSize: 36,
                              color: iconColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  widget.globalStateModel.currentBusiness.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: iconColor(),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
            GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _itemBuilder(state, index),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2.5 / 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                crossAxisCount: (_isTablet || !_isPortrait) ? 6 : 4,
              ),
              itemCount: 7,
            )
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(SettingScreenState state, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _onTileClicked(index),
          child: AspectRatio(
            aspectRatio: 1/1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: overlayBackground(),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SvgPicture.asset(
                settingItems[index].image,
                color: iconColor(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          settingItems[index].name,
          style: TextStyle(
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  void _onTileClicked(int index) {
    Widget _target;

    switch (index) {
      case 0:
        _target = BusinessInfoScreen(
          globalStateModel: widget.globalStateModel,
          setScreenBloc: screenBloc,
        );
        break;
      case 1:
        _target = BusinessDetailsScreen(
          globalStateModel: widget.globalStateModel,
          setScreenBloc: screenBloc,
          countryList: countryList,
        );
        break;
      case 2:
        _target = WallpaperScreen(
          globalStateModel: widget.globalStateModel,
          setScreenBloc: screenBloc,
          fromDashboard: false,
        );
        break;
      case 3:
        _target = EmployeeScreen(
          globalStateModel: widget.globalStateModel,
          setScreenBloc: screenBloc,
        );
        break;
      case 4:
        _target = PoliciesScreen(
          globalStateModel: widget.globalStateModel,
          setScreenBloc: screenBloc,
        );
        break;
      case 5:
        _target = GeneralScreen(
          globalStateModel: widget.globalStateModel,
          setScreenBloc: screenBloc,
        );
        break;
      case 6:
        _target = AppearanceScreen(
          globalStateModel: widget.globalStateModel,
          setScreenBloc: screenBloc,
        );
        break;
    }
    if (_target == null) return;
    Navigator.push(
      context,
      PageTransition(
        child: _target,
        type: PageTransitionType.fade,
      ),
    );
    debugPrint("You tapped on item $index");
  }
}
