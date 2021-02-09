import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/widgets/connect_top_button.dart';
import 'package:payever/contacts/views/add_contact_screen.dart';
import 'package:payever/contacts/views/contacts_filter_screen.dart';
import 'package:payever/contacts/widgets/contact_grid_add_item.dart';
import 'package:payever/contacts/widgets/contact_grid_item.dart';
import 'package:payever/contacts/widgets/contact_list_item.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class ContactsInitScreen extends StatelessWidget {

  final DashboardScreenBloc dashboardScreenBloc;

  ContactsInitScreen({
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ContactScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class ContactScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  ContactScreen({
    this.dashboardScreenBloc,
    this.globalStateModel,
  });

  @override
  createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  bool _isPortrait;
  bool _isTablet;

  ContactScreenBloc screenBloc;
  static int selectedIndex = 0;
  static int selectedStyle = 1;

  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  double iconSize;
  double margin;
  RefreshController contactRefreshController = RefreshController(
    initialRefresh: false,
  );

  List<ConnectPopupButton> appBarPopUpActions(BuildContext context, ContactScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getProductListStrings('list_view'),
        icon: SvgPicture.asset('assets/images/list.svg', color: iconColor()),
        onTap: () async {
          setState(() {
            selectedStyle = 0;
          });
        },
      ),
      ConnectPopupButton(
        title: Language.getProductListStrings('grid_view'),
        icon: SvgPicture.asset('assets/images/grid.svg', color: iconColor(),),
        onTap: () async {
          setState(() {
            selectedStyle = 1;
          });
        },
      ),
    ];
  }

  List<ConnectPopupButton> sortPopup(BuildContext context, ContactScreenState state) {
    return [
      ConnectPopupButton(
        title: Language.getProductListStrings('Name asc'),
        onTap: () async {
          setState(() {
          });
        },
      ),
      ConnectPopupButton(
        title: Language.getProductListStrings('Name desc'),
        onTap: () async {
          setState(() {
          });
        },
      ),
      ConnectPopupButton(
        title: Language.getProductListStrings('Email'),
        onTap: () async {
          setState(() {
          });
        },
      ),
    ];
  }

  @override
  void initState() {
    screenBloc = ContactScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    );
    screenBloc.add(
        ContactScreenInitEvent(
          business: widget.globalStateModel.currentBusiness.id,
        )
    );
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
      listener: (BuildContext context, ContactScreenState state) async {
        if (state is ContactScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ContactScreenBloc, ContactScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ContactScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(ContactScreenState state) {
    iconSize = _isTablet ? 120: 80;
    margin = _isTablet ? 24: 16;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: MainAppbar(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        dashboardScreenState: widget.dashboardScreenBloc.state,
        title: Language.getCommerceOSStrings('dashboard.apps.contacts'),
        icon: SvgPicture.asset(
          'assets/images/contacts.svg',
          height: 20,
          width: 20,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Center(
            child: Column(
              children: <Widget>[
                _topBar(state),
                Expanded(
                  child: _getBody(state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(ContactScreenState state) {
    String itemsString = '';
    int selectedCount = 0;
    if (state.contactLists.length > 0) {
      selectedCount = state.contactLists.where((element) => element.isChecked).toList().length;
    }
    itemsString = '${state.contactLists.length} items';
    return selectedCount == 0 ? Container(
          height: 50,
          color: overlaySecondAppBar(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await showGeneralDialog(
                        barrierColor: null,
                        transitionBuilder: (context, a1, a2, wg) {
                          final curvedValue = 1.0 - Curves.ease.transform(a1.value);
                          return Transform(
                            transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
                            child: ContactsFilterScreen(
                              screenBloc: screenBloc,
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {
                          return null;
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(margin),
                      child: SvgPicture.asset(
                        'assets/images/filter.svg',
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Container(
                      width: 1,
                      color: Color(0xFF888888),
                      height: 24,
                    ),
                  ),
                  InkWell(
                    onTap: () {

                    },
                    child: Text(
                        'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: 100, maxWidth: Measurements.width / 2, maxHeight: 36, minHeight: 36),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFF111111),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: SvgPicture.asset(
                            'assets/images/search_place_holder.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: searchFocus,
                            controller: searchTextController,
                            autofocus: false,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search in Contact',
                              isDense: true,
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            onSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          !_isTablet && _isPortrait ? '' : itemsString,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<ConnectPopupButton>(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            'assets/images/sort-by-button.svg',
                            width: 12,
                            height: 12,
                          ),
                        ),
                        offset: Offset(0, 100),
                        onSelected: (ConnectPopupButton item) => item.onTap(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: overlayFilterViewBackground(),
                        itemBuilder: (BuildContext context) {
                          return sortPopup(context, state)
                              .map((ConnectPopupButton item) {
                            return PopupMenuItem<ConnectPopupButton>(
                              value: item,
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<ConnectPopupButton>(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: selectedStyle == 0 ? SvgPicture.asset('assets/images/list.svg'): SvgPicture.asset('assets/images/grid.svg'),
                        ),
                        offset: Offset(0, 100),
                        onSelected: (ConnectPopupButton item) => item.onTap(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: overlayFilterViewBackground(),
                        itemBuilder: (BuildContext context) {
                          return appBarPopUpActions(context, state)
                              .map((ConnectPopupButton item) {
                            return PopupMenuItem<ConnectPopupButton>(
                              value: item,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: item.icon,
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    ): Container(
      height: 50,
      color: overlaySecondAppBar(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              screenBloc.add(SelectAllContactsEvent());
            },
            child: Text(
              'Select all',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            height: 36,
            width: 0.5,
            color: Colors.white38,
          ),
          MaterialButton(
            onPressed: () {
              screenBloc.add(DeselectAllContactsEvent());
            },
            child: Text(
              'Deselect all',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            height: 36,
            width: 0.5,
            color: Colors.white38,
          ),
          MaterialButton(
            onPressed: () {
              screenBloc.add(DeleteSelectedContactsEvent());
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody(ContactScreenState state) {
    return selectedStyle == 0
        ? _getListBody(state)
        : _getGridBody(state);
  }

  Widget _getListBody(ContactScreenState state) {
    int selectedCount = 0;
    if (state.contactLists.length > 0) {
      selectedCount = state.contactLists.where((element) => element.isChecked).toList().length;
    }
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 44,
            padding: EdgeInsets.only(left: 24, right: 24),
            color: Color(0xff3f3f3f),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (selectedCount == state.contactLists.length) {
                      screenBloc.add(DeselectAllContactsEvent());
                    } else {
                      screenBloc.add(SelectAllContactsEvent());
                    }
                  },
                  child: Icon(
                    selectedCount == state.contactLists.length ? Icons.check_circle_outline : Icons.radio_button_unchecked, color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Text(
                  'Contacts',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Helvetica Neue',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ContactListItem(
                  isTablet: _isTablet,
                  isPortrait: _isPortrait,
                  onOpen: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: AddContactScreen(
                          screenBloc: screenBloc,
                          editContact: state.contactLists[index].contact,
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  onTap: (){
                    screenBloc.add(SelectContactEvent(contact: state.contactLists[index]));
                  },
                  contact: state.contactLists[index],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Color.fromRGBO(255, 255, 255, 0.2),
                );
              },
              itemCount: state.contactLists.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGridBody(ContactScreenState state) {
    int crossAxisCount = _isTablet ? (_isPortrait ? 3 : 3): (_isPortrait ? 2 : 3);
    List<Widget> widgets = [];
    widgets.add(
      Container(
        child: ContactGridAddItem(
          onAdd: () {
            Navigator.push(
              context,
              PageTransition(
                child: AddContactScreen(
                  isNew: true,
                  screenBloc: screenBloc,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        ),
      ),
    );
    if (state.contacts != null) {
      widgets.addAll(state.contactLists.map((contact) {
        return Container(
          child: ContactGridItem(
            contact: contact,
            onTap: (contactModel) {
              screenBloc.add(SelectContactEvent(contact: contactModel));
            },
            onOpen: (contactModel) {
              Navigator.push(
                context,
                PageTransition(
                  child: AddContactScreen(
                    screenBloc: screenBloc,
                    editContact: contactModel.contact,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
          ),
        );
      }).toList());
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal:12, vertical: 16,),
      clipBehavior: Clip.none,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(backgroundColor: Colors.black,semanticsLabel: '',),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          height: 1,
          builder: (context, status) {
            return Container();
          },
        ),
        controller: contactRefreshController,
        onRefresh: () {
          _refreshProducts();
        },
        onLoading: () {
//                        _loadMoreCollections(state);
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverGrid.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              children: widgets,
            ),
            new SliverToBoxAdapter(
              child: Container(),
            )
          ],
        ),
      ),
    );
  }

  void _refreshProducts() async {
    screenBloc.add(
        ContactsRefreshEvent()
    );
    await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
    contactRefreshController.refreshCompleted(resetFooterState: true);
  }

}