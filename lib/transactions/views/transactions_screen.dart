import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/models/enums.dart';
import 'package:payever/transactions/views/filter_content_view.dart';
import 'package:payever/transactions/views/sort_content_view.dart';
import 'package:payever/transactions/views/export_content_view.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/utils.dart';
import '../../commons/view_models/view_models.dart';
import '../../commons/models/models.dart';
import 'sub_view/search_text_content_view.dart';
import 'transactions_details_screen.dart';

bool _isPortrait;
bool _isTablet;

class TagItemModel {
  String title;
  String type;
  TagItemModel({this.title = '', this.type});
}

class TransactionScreenInit extends StatelessWidget {
  final DashboardScreenBloc dashboardScreenBloc;

  TransactionScreenInit({this.dashboardScreenBloc});
  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return TransactionScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class TransactionScreen extends StatefulWidget {

  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  TransactionScreen({
    this.globalStateModel,
    this.dashboardScreenBloc,
  });

  @override
  createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  TransactionsScreenBloc screenBloc;
  String wallpaper;
  num _quantity;
  String _currency;
  num _totalAmount;
  var f = NumberFormat('###,###,##0.00', 'en_US');
  bool noTransactions = false;
  List<TagItemModel> _filterItems;
  int _searchTagIndex = -1;

  RefreshController _transactionsRefreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    screenBloc = TransactionsScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    )..add(TransactionsScreenInitEvent(widget.globalStateModel.currentBusiness));
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
      listener: (BuildContext context, TransactionsScreenState state) async {
        if (state is TransactionsScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<TransactionsScreenBloc, TransactionsScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          NumberFormat format = NumberFormat();
          if (state.transaction != null) {
            _quantity = state.transaction.paginationData.total ?? 0;
            _currency = format.simpleCurrencySymbol(widget.globalStateModel.currentBusiness.currency);
            _totalAmount = state.transaction.paginationData.amount ?? 0;
          } else {
            _quantity = 0;
            _currency = '';
            _totalAmount = 0;
          }

          _filterItems = [];
          if (state.filterTypes.length > 0) {
            for (int i = 0; i < state.filterTypes.length; i++) {
              String filterString = '${filterLabels[state.filterTypes[i].type]} ${filterConditions[state.filterTypes[i].condition]}: ${state.filterTypes[i].disPlayName}';
              TagItemModel item = TagItemModel(title: filterString, type: state.filterTypes[i].type);
              _filterItems.add(item);
            }
          }
          if (state.searchText.length > 0) {
            _filterItems.add(TagItemModel(title: 'Search is: ${state.searchText}', type: null));
            _searchTagIndex = _filterItems.length - 1;
          }
          return _body(state);
        },
      ),
    );
  }

  Widget _body(TransactionsScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: MainAppbar(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        dashboardScreenState: widget.dashboardScreenBloc.state,
        title: 'Transactions',
        icon: SvgPicture.asset(
          'assets/images/transactions.svg',
          height: 20,
          width: 20,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading || state.transaction == null ?
          Center(
            child: CircularProgressIndicator(),
          ): Column(
            children: [
              _toolbar(state),
              _filterbar(state),
              _secondToolbar,
              _transactionsBody(state),
              _bottomView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolbar(TransactionsScreenState state) {
    return Container(
      height: 50,
      color: overlaySecondAppBar(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  if (state.isSearchLoading) return;
                  showSearchTextDialog(state);
                },
                child: SvgPicture.asset(
                  'assets/images/searchicon.svg',
                  width: 20,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              InkWell(
                onTap: () {
                  if (state.isSearchLoading) return;
                  showCupertinoModalPopup(
                      context: context,
                      builder: (builder) {
                        return FilterContentView(
                          onSelected: (FilterItem val) {
                            Navigator.pop(context);
                            List<FilterItem> filterTypes = [];
                            filterTypes.addAll(state.filterTypes);
                            if (val != null) {
                              if (filterTypes.length > 0) {
                                int isExist = filterTypes.indexWhere((element) => element.type == val.type);
                                if (isExist > -1) {
                                  filterTypes[isExist] = val;
                                } else {
                                  filterTypes.add(val);
                                }
                              } else {
                                filterTypes.add(val);
                              }
                            } else {
                              if (filterTypes.length > 0) {
                                int isExist = filterTypes.indexWhere((element) => element.type == val.type);
                                if (isExist != null) {
                                  filterTypes.removeAt(isExist);
                                }
                              }
                            }
                            screenBloc.add(
                                UpdateFilterTypes(filterTypes: filterTypes)
                            );
                          },
                        );
                      });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/images/filter.svg', width: 20,),
                ),
              ),
              FlatButton(
                onPressed: () {
                  if (state.isSearchLoading) return;
                  showGeneralDialog(
                      barrierLabel: 'Export',
                      barrierDismissible: true,
                      transitionDuration: Duration(milliseconds: 350),
                      context: context,
                      pageBuilder: (context, anim1, anim2) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: ExportContentView(
                            onSelectType: (index) {},
                          ),
                        );
                      }
                  );
                },
                child: Text(
                  'Export',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (state.isSearchLoading) return;
                  showCupertinoModalPopup(
                      context: context,
                      builder: (builder) {
                        return SortContentView(
                          selectedIndex: state.curSortType ,
                          onSelected: (val) {
                            Navigator.pop(context);
                            screenBloc.add(
                                UpdateSortType(sortType: val)
                            );
                          },
                        );
                      });
                },
                child: SvgPicture.asset(
                  'assets/images/sort-by-button.svg',
                  width: 20,
                ),
              ),
              SizedBox(
                width: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterbar(TransactionsScreenState state) {
    return _filterItems.length > 0
        ? Container(
            width: Device.width,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 8,
            ),
            child: Tags(
              itemCount: _filterItems.length,
              alignment: WrapAlignment.start,
              spacing: 4,
              runSpacing: 8,
              itemBuilder: (int index) {
                return ItemTags(
                  key: Key('filterItem$index'),
                  index: index,
                  title: _filterItems[index].title,
                  color: overlayBackground(),
                  activeColor: overlayBackground(),
                  textActiveColor: iconColor(),
                  textColor: iconColor(),
                  elevation: 0,
                  padding: EdgeInsets.only(
                    left: 16,
                    top: 8,
                    bottom: 8,
                    right: 16,
                  ),
                  removeButton: ItemTagsRemoveButton(
                    backgroundColor: Colors.transparent,
                    onRemoved: () {
                      if (index == _searchTagIndex) {
                        _searchTagIndex = -1;
                        screenBloc.add(UpdateSearchText(searchText: ''));
                      } else {
                        List<FilterItem> filterTypes = [];
                        filterTypes.addAll(state.filterTypes);
                        filterTypes.removeAt(index);
                        screenBloc
                            .add(UpdateFilterTypes(filterTypes: filterTypes));
                      }
                      return true;
                    },
                    color: iconColor(),
                  ),
                );
              },
            ),
          )
        : Container();
  }

  get _secondToolbar {
    return Container(
      height: 35,
      color: overlayBackground(),
      child: Row(
        children: [
          SizedBox(
            width: 16,
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Channel',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Type',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Customer name',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Total',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomView() {
    return GlobalUtils.isBusinessMode ? Container(
      height: 50,
      color: overlayBackground(),
      alignment: Alignment.center,
      child: !noTransactions ? AutoSizeText(
        Language.getTransactionStrings('total_orders.heading')
            .toString()
            .replaceFirst('{{total_count}}', '${_quantity ?? 0}')
            .replaceFirst('{{total_sum}}',
            '${_currency ?? '€'}${f.format(_totalAmount ?? 0)}'),
        overflow: TextOverflow.fade,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16,
        ),
      )
          : Container(),
    ) : Container();
  }

  Widget _transactionsBody(TransactionsScreenState state) {
    return Expanded(
      child: state.isSearchLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (state.collections.length > 0
              ? _listBody(state)
              : Center(
                  child: Text(
                    'The list is empty',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                )),
    );
  }

  Widget _listBody(TransactionsScreenState state) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: MaterialClassicHeader(
        semanticsLabel: '',
      ),
      footer: CustomFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        height: 60,
        builder: (context, status) {
          return Container(
            child: Center(
                child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))),
          );
        },
      ),
      controller: _transactionsRefreshController,
      onRefresh: () {
        _refreshTransactions();
      },
      onLoading: () {
        _loadMoreTransactions(state);
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: state.collections.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: _isTablet
                ? TabletTableRow(
              globalStateModel: widget.globalStateModel,
              currentTransaction: state.collections[index],
              state: state,
              isHeader: false,
            )
                : PhoneTableRow(
              globalStateModel: widget.globalStateModel,
              currentTransaction: state.collections[index],
              state: state,
              isHeader: false,
            ),
          );
        },
      ),
    );
  }

  void _loadMoreTransactions(TransactionsScreenState state) async {
    print('Load more products: ${state.collections.length}');
    if (state.collections.length == state.paginationData.total) {
      _transactionsRefreshController.loadComplete();
      return;
    }
    screenBloc.add(LoadMoreTransactionsEvent());
    await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
    _transactionsRefreshController.loadComplete();
  }

  void _refreshTransactions() async {
    screenBloc.add(RefreshTransactionsEvent());
    await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
    _transactionsRefreshController.refreshCompleted(resetFooterState: true);
  }

  void showSearchTextDialog(TransactionsScreenState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          content: SearchTextContentView(
              searchText: state.searchText,
              onSelected: (value) {
                Navigator.pop(context);
                screenBloc.add(
                    UpdateSearchText(searchText: value)
                );
              }
          ),
        );
      },
    );
  }
}

class PhoneTableRow extends StatelessWidget {
  final Collection currentTransaction;
  final TransactionsScreenState state;
  final GlobalStateModel globalStateModel;
  final bool isHeader;

  PhoneTableRow({
    this.globalStateModel,
    this.currentTransaction,
    this.isHeader,
    this.state,
  });

  final f = NumberFormat('###,###.00', 'en_US');

  @override
  Widget build(BuildContext context) {
    DateTime time;
    if (currentTransaction != null)
      time = DateTime.parse(currentTransaction.createdAt);

    return InkWell(
      highlightColor: Colors.transparent,
      child: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: AppStyle.listRowPadding(false),
              height: AppStyle.listRowSize(false),
              child: Row(
                children: <Widget>[
                  Expanded(
//                    flex: _isPortrait ? 2 : 1.2,
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: !isHeader
                          ? TransactionScreenParts.channelIcon(
                          currentTransaction.channel)
                          : Container(
                          child: Text(
                            Language.getTransactionStrings(
                                'form.filter.labels.channel'),
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeListRow(),
                            ),
                          )),
                    ),
                  ),
                  Expanded(
//                    flex: _isPortrait ? 2 : 1,
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: !isHeader
                          ? TransactionScreenParts.paymentType(currentTransaction.type)
                          : Container(
                        child: Text(
                            Language.getTransactionStrings(
                                'form.filter.labels.type'),
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeListRow(),
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _isPortrait ? 6 : 5,
                    child: Container(
                      child: !isHeader
                          ? Text(
                        currentTransaction.customerName,
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeListRow()),
                      )
                          : Text(
                          Language.getTransactionStrings(
                              'form.filter.labels.customer_name'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: _isPortrait ? 3 : 3,
                    child: Container(
                      child: !isHeader
                          ? Text(
                        '${Measurements.currency(currentTransaction.currency)}${f.format(currentTransaction.total)}',
                        style: TextStyle(
                            fontSize: AppStyle.fontSizeListRow()),
                      )
                          : Text(
                          Language.getTransactionStrings(
                              'form.filter.labels.total'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: _isPortrait ? 0 : 4,
                    child: !_isPortrait
                        ? Container(
                      child: !isHeader
                          ? Text(
                          '${DateFormat.d('en_US').add_MMMM().add_y().format(time)} ${DateFormat.Hm('en_US').format(time.add(Duration(hours: 2)))}',
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow()))
                          : Text(
                          Language.getTransactionStrings(
                              'form.filter.labels.created_at'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    )
                        : Container(),
                  ),
                  Expanded(
                    flex: _isPortrait ? 0 : 3,
                    child: !_isPortrait
                        ? Container(
                      width: Measurements.width *
                          (_isPortrait ? 0.20 : 0.24),
                      child: !isHeader
                          ? Measurements.statusWidget(
                          currentTransaction.status)
                          : AutoSizeText(
                          Language.getTransactionStrings(
                              'form.filter.labels.status'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    )
                        : Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: !_isPortrait
                        ? Container()
                        : Container(
                      width: Measurements.width * 0.02,
                      child: !isHeader
                          ? Icon(
                        IconData(58849,
                            fontFamily: 'MaterialIcons',
                        ),
                        size: Measurements.width * 0.04,
                      )
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0, thickness: 0.5,)
          ],
        ),
      ),
      onTap: () {
        if (!isHeader) {
          Navigator.push(
            context,
            PageTransition(
              child: TransactionDetailsScreen(
                businessId: globalStateModel.currentBusiness.id,
                transactionId: currentTransaction.uuid,
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
    );
  }
}

class TabletTableRow extends StatelessWidget {
  final Collection currentTransaction;
  final TransactionsScreenState state;
  final GlobalStateModel globalStateModel;
  final bool isHeader;

  TabletTableRow({
    this.globalStateModel,
    this.currentTransaction,
    this.isHeader,
    this.state,
  });

  final f = NumberFormat('###,##0.00', 'en_US');

  @override
  Widget build(BuildContext context) {

    DateTime time;
    if (currentTransaction != null)
      time = DateTime.parse(currentTransaction.createdAt);
    return InkWell(
      highlightColor: Colors.transparent,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: AppStyle.listRowSize(true),
              padding: AppStyle.listRowPadding(true),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: !isHeader
                          ? Container(
//                          alignment: _isPortrait ? Alignment.centerLeft : Alignment.center,
                          alignment: Alignment.center,
                          child: TransactionScreenParts.channelIcon(currentTransaction.channel),
                      )
                          : Container(
                          child: AutoSizeText(
                            Language.getTransactionStrings(
                                'form.filter.labels.channel'),
                            style: TextStyle(
                                fontSize: AppStyle.fontSizeListRow(),
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: !isHeader
                          ? Container(
                        alignment: Alignment.center,
                        child: TransactionScreenParts.paymentType(currentTransaction.type),
                      )
                          : Container(
                        child: AutoSizeText(
                          Language.getTransactionStrings(
                              'form.filter.labels.type'),
                          style: TextStyle(
                            fontSize: AppStyle.fontSizeListRow(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: Container(
                      child: !isHeader
                          ? AutoSizeText('#${currentTransaction.originalId}',
                        style: TextStyle(
                          fontSize: AppStyle.fontSizeListRow(),
                        ),
                      )
                          : AutoSizeText(
                        Language.getTransactionStrings(
                            'form.filter.labels.original_id'),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: AppStyle.fontSizeListRow(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: !isHeader
                          ? AutoSizeText(currentTransaction.customerName,
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow()))
                          : AutoSizeText(
                          Language.getTransactionStrings(
                              'form.filter.labels.customer_name'),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: !isHeader
                          ? AutoSizeText(
                          '${Measurements.currency(currentTransaction.currency)}${f.format(currentTransaction.total)}',
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow()))
                          : AutoSizeText(
                          Language.getTransactionStrings(
                              'form.filter.labels.total'),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: !isHeader
                          ? AutoSizeText(
                          '${DateFormat.d('en_US').add_MMMM().add_y().format(time)} ${DateFormat.Hm('en_US').format(time.add(Duration(hours: 2)))}',
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow()))
                          : Text(
                          Language.getTransactionStrings(
                              'form.filter.labels.created_at'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow())),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: Measurements.width * (_isPortrait ? 0.13 : 0.15),
                      child: !isHeader
                          ? Measurements.statusWidget(currentTransaction.status)
                          : Text(
                          Language.getTransactionStrings('form.filter.labels.status'),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeListRow(),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
          ],
        ),
      ),
      onTap: () {
        if (!isHeader) {
          Navigator.push(
            context,
            PageTransition(
              child: TransactionDetailsScreen(
                businessId: globalStateModel.currentBusiness.id,
                transactionId: currentTransaction.uuid,
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
    );
  }
}

class TransactionScreenParts {
  static channelIcon(String channel) {
    double size = AppStyle.iconRowSize(_isTablet);
    return SvgPicture.asset(Measurements.channelIcon(channel), height: size, color: iconColor(),);
  }

  static paymentType(String type) {
    double size = AppStyle.iconRowSize(_isTablet);
    return SvgPicture.asset(
      Measurements.paymentType(type),
      height: size,
      color: iconColor(),
    );
  }
}
