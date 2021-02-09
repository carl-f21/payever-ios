import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/search/search_bloc.dart';
import 'package:payever/blocs/search/search_event.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/utils.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/search/widgets/app_widget_cell.dart';
import 'package:payever/search/widgets/search_result_business_view.dart';
import 'package:payever/search/widgets/search_result_transaction_view.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String businessId;
  final String searchQuery;
  final List<AppWidget> appWidgets;
  final Business activeBusiness;
  final String currentWall;
  final DashboardScreenBloc dashboardScreenBloc;

  SearchScreen({
    this.businessId,
    this.searchQuery,
    this.appWidgets,
    this.activeBusiness,
    this.currentWall,
    this.dashboardScreenBloc,
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isPortrait;
  bool _isTablet;
  double mainWidth = 0;
  SearchScreenBloc screenBloc;
  TextEditingController searchController = TextEditingController();
  String searchString = '';

  @override
  void initState() {
    screenBloc = SearchScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    );
    if (widget.searchQuery != '') {
      searchString = widget.searchQuery;
      searchController.text = widget.searchQuery;
      screenBloc.add(SearchEvent(businessId: widget.businessId, key: widget.searchQuery));
    }
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
      mainWidth = _isTablet ? Measurements.width * 0.7 : Measurements.width;
    }

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, SearchScreenState state) async {
        if (state is SearchScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is SetBusinessSuccess) {
          Provider.of<GlobalStateModel>(context,listen: false)
              .setCurrentBusiness(state.business);
          Provider.of<GlobalStateModel>(context,listen: false)
              .setCurrentWallpaper('$wallpaperBase${state.wallpaper.currentWallpaper.wallpaper}');
          Navigator.pop(context, 'changed');
        }
      },
      child: BlocBuilder<SearchScreenBloc, SearchScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, SearchScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(SearchScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: BackgroundBase(
        true,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: Container(
              width: mainWidth,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 16, right: 16),
                    child: IconButton(
                      constraints: BoxConstraints(
                          maxHeight: 32,
                          maxWidth: 32,
                          minHeight: 32,
                          minWidth: 32
                      ),
                      icon: Icon(
                        Icons.close,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  _searchBar(state),
                  Expanded(
                    child: _searchResultList(state),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar(SearchScreenState state) {
    return Padding(
      padding: EdgeInsets.only(
        top: 44,
        left: 16,
        right: 16,
      ),
      child: BlurEffectView(
        radius: 12,
        color: overlayBackground(),
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Container(
          height: 40,
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Search',
                        ),
                        style: TextStyle(
                            fontSize: 14,
                        ),
                        onChanged: (val) {
                          searchString = val;
                          Future.delayed(Duration(milliseconds: 300))
                              .then((value) async {
                            if (!state.isLoading) {
                              screenBloc.add(SearchEvent(
                                  businessId: widget.businessId, key: val));
                            }
                          });
                        },
                        onSubmitted: (val) {
                          screenBloc.add(SearchEvent(businessId: widget.businessId, key: val));
                        },
                      ),
                    ),
                    state.isLoading ?
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ),
                    ) : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchResultList(SearchScreenState state) {
    List<AppWidget> appWidgets = [];
    appWidgets = widget.appWidgets.where((element) => element.type != 'apps' && element.icon.isNotEmpty).toList();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            state.searchBusinesses.length > 0 ?
            BlurEffectView(
              blur: 1,
              color: Colors.transparent,
              radius: 12,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 36,
                    padding: EdgeInsets.only(left: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Business',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  BlurEffectView(
                    blur: 15,
                    color: overlayBackground(),
                    radius: 0,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SearchResultBusinessView(
                          business: state.searchBusinesses[index],
                          onTap: (business) {
                            screenBloc.add(SetBusinessEvent(business: business));
                          },
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return Divider(height: 0, thickness: 1,);
                      },
                      itemCount: state.searchBusinesses.length,
                    ),
                  ),
                ],
              ),
            ): Container(),
            state.searchTransactions.length > 0 ?
            BlurEffectView(
              blur: 1,
              color: Colors.transparent,
              radius: 12,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 36,
                    padding: EdgeInsets.only(left: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  BlurEffectView(
                    blur: 15,
                    color: overlayBackground(),
                    radius: 0,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SearchResultTransactionView(
                          collection: state.searchTransactions[index],
                          onTap: (collection) {
                            Provider.of<GlobalStateModel>(context,listen: false)
                                .setCurrentBusiness(widget.activeBusiness);
                            Provider.of<GlobalStateModel>(context,listen: false)
                                .setCurrentWallpaper(widget.currentWall);
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: TransactionScreenInit(
                                  dashboardScreenBloc: widget.dashboardScreenBloc,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                            Navigator.push(
                              context,
                              PageTransition(
                                child: TransactionDetailsScreen(
                                  businessId: widget.activeBusiness.id,
                                  transactionId: collection.uuid,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );

                          },
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return Divider(height: 0, thickness: 1,);
                      },
                      itemCount: state.searchTransactions.length,
                    ),
                  ),
                ],
              ),
            ): Container(),
            state.searchBusinesses.length == 0 && state.searchTransactions.length == 0 && appWidgets.length > 0
                ? BlurEffectView(
              blur: 15,
              color: overlayBackground(),
              radius: 12,
              child: Column(
                children: <Widget>[
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 64, right: 64, top: 24, bottom: 16),
                    crossAxisSpacing: 36,
                    mainAxisSpacing: 36,
                    childAspectRatio: 1,
                    children: appWidgets.map((e) => AppWidgetCell(
                      onTap: (appwidget) {

                      },
                      appWidget: e,
                    ),
                    ).toList(),
                    physics: NeverScrollableScrollPhysics(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 24, right: 24, left: 24),
                    child: Text(
                      Language.getCommerceOSStrings('search_box.content.details'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ): Container(),
          ],
        ),
      ),
    );
  }
}