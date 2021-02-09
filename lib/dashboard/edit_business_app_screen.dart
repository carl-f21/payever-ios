
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';
import 'package:provider/provider.dart';

class EditBusinessAppScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  EditBusinessAppScreen({
    this.globalStateModel,
    this.dashboardScreenBloc,
  });

  @override
  _EditBusinessAppScreenState createState() => _EditBusinessAppScreenState();
}

class _EditBusinessAppScreenState extends State<EditBusinessAppScreen> {
  Business activeBusiness;
  bool isApps = false;

  List<BusinessApps> businessApps = [];
  List<AppWidget> appWidgets = [];
  int notInstallIndex = -1;
  int notInstallWebIndex = -1;
  @override
  void initState() {
    activeBusiness = widget.globalStateModel.currentBusiness;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.dashboardScreenBloc,
      listener: (BuildContext context, DashboardScreenState state) async {
        if (state is WelcomeScreenStateFailure) {

        } else if (state is WelcomeScreenStateSuccess) {
          GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context, listen: false);
          globalStateModel.setRefresh(true);
        }
      },
      child: BlocBuilder<DashboardScreenBloc, DashboardScreenState>(
        bloc: widget.dashboardScreenBloc,
        builder: (BuildContext context, DashboardScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Widget _body(DashboardScreenState state) {
    notInstallIndex = -1;
    notInstallWebIndex = -1;
    if (widget.dashboardScreenBloc.state.businessWidgets != null) {
      appWidgets = widget.dashboardScreenBloc.state.currentWidgets;
      businessApps =
          widget.dashboardScreenBloc.state.businessWidgets.where((element) {
            return (element.dashboardInfo != null && element.dashboardInfo.title != null && element.dashboardInfo.title.isNotEmpty);
          }).toList();
      List<BusinessApps> businessAppsDefault = [];
      List<BusinessApps> businessAppsInstall = [];

      businessAppsDefault =
          businessApps.where((element) {
            if (element.code == "settings") {
              return element.setupStatus != "notStarted";
            }
            return (element.isDefault);
          }).toList();

      businessAppsInstall =
          businessApps.where((element) {
            return (!element.isDefault && element.installed);
          }).toList();
      List<BusinessApps> businessApps1 = [];
      businessApps1.addAll(businessAppsDefault);
      businessApps1.addAll(businessAppsInstall);
      businessApps.forEach((element) {
        if (!businessApps1.contains(element)) {
          if (notInstallIndex == -1) {
            notInstallIndex = businessApps1.length;
          }
          businessApps1.add(element);
        }
      });
      businessApps = [];
      businessApps.addAll(businessApps1);


      List<AppWidget> notInstalledAppWidgets = [];
      notInstalledAppWidgets =
          appWidgets.where((element) {
            return (!element.defaultWid && !element.install);
          }).toList();

      List<AppWidget> appWidgets1 = [];
      appWidgets.forEach((element) {
        if (!element.defaultWid && !element.install) {
          return;
        }
        appWidgets1.add(element);
      });
      if (appWidgets1.length < appWidgets.length) {
        notInstallWebIndex = appWidgets1.length;
      }
      appWidgets1.addAll(notInstalledAppWidgets);
      appWidgets = [];
      appWidgets.addAll(appWidgets1);
    }

    return Scaffold(
      appBar: Appbar(
        'Edit Apps',
        onClose: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: Container(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  color: overlaySecondAppBar(),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isApps = true;
                              });
                            },
                            color: overlaySwitcherBackground()
                                .withOpacity(isApps ? 1.0 : 0.6),
                            height: 24,
                            elevation: 0,
                            child: AutoSizeText(
                              'Apps',
                              minFontSize: 8,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                isApps = false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            color: overlaySwitcherBackground()
                                .withOpacity(isApps ? 0.6 : 1),
                            elevation: 0,
                            height: 24,
                            child: AutoSizeText(
                              'Widgets',
                              maxLines: 1,
                              minFontSize: 8,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: isApps
                      ? _appsBody(state)
                      : _widgetBody(state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appsBody(DashboardScreenState state) {
    return Container(
      alignment: Alignment.topCenter,
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          BusinessApps businessApp =
          businessApps[index];
          String icon =
          businessApp.dashboardInfo != null
              ? businessApp.dashboardInfo.icon
              : null;
          Color bgColor = businessApp.installed ? Colors.transparent : overlayBackground();
          if (businessApp.code == 'settings' && businessApp.setupStatus == 'notStarted') {
            bgColor = overlayBackground();
          }
          icon = icon.replaceAll('32', '64');

          return BlurEffectView(
            color: bgColor,
            radius: 0,
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: notInstallIndex == index,
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Not installed', style: TextStyle(color: Colors.grey),),
                  ),
                ),
                Container(
                  height: 65,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              decoration:
                              BoxDecoration(
                                image:
                                DecorationImage(
                                  image:
                                  NetworkImage(
                                    '${Env.cdnIcon}$icon',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Flexible(
                              child: Text(
                                businessApp.code[0]
                                    .toUpperCase() +
                                    businessApp.code
                                        .substring(
                                        1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !businessApp.isDefault,
                        child: InkWell(
                          onTap: () {
                            widget.dashboardScreenBloc.add(BusinessAppInstallEvent(businessApp: businessApp));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: overlayButtonBackground(),
                            ),
                            child: state.installBusinessAppId == businessApp.microUuid ? Container(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: CircularProgressIndicator(strokeWidth: 2,),
                              ),
                            ): Text(businessApp.installed ? 'Uninstall' : 'Install',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
            thickness: 0.5,
          );
        },
        itemCount: businessApps.length,
      ),
    );
  }

  Widget _widgetBody(DashboardScreenState state) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        AppWidget appWidget =
        appWidgets[index];
        String icon =
        appWidget.icon != null
            ? appWidget.icon
            : null;
        if (icon == null) {
          return Container();
        }
        icon = icon.replaceAll('32', '64');
        return BlurEffectView(
          color: Colors.transparent,
          radius: 0,
          child: Column(
            children: <Widget>[
              Visibility(
                visible: notInstallWebIndex == index,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Not Added', style: TextStyle(color: Colors.grey),),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 65,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            decoration:
                            BoxDecoration(
                              image:
                              DecorationImage(
                                image:
                                NetworkImage(
                                  '${Env.cdnIcon}$icon',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Flexible(
                            child: Text(
                              appWidget.title,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !appWidget.defaultWid,
                      child: InkWell(
                        onTap: () {
                          widget.dashboardScreenBloc.add(WidgetInstallEvent(appWidget: appWidget));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: overlayButtonBackground(),
                          ),
                          child: state.installBusinessAppId == appWidget.id
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  appWidget.install ? 'Delete' : 'Add',
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          thickness: 0.5,
        );
      },
      itemCount: appWidgets.length,
    );
  }

}
