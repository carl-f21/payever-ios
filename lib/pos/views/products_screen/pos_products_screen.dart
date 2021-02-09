import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/views/workshop/subview/work_shop_view.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/views/products_screen/pos_product_detail_screen.dart';
import 'package:payever/pos/views/products_screen/pos_products_filter_screen.dart';
import 'package:payever/pos/views/products_screen/widget/pos_product_grid_item.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../pos_qr_app.dart';

class PosProductsScreen extends StatefulWidget {
  final PosScreenBloc posScreenBloc;
  final String businessId;
  final List<ProductsModel> products;
  final Info productsInfo;

  PosProductsScreen(
    this.businessId,
    this.posScreenBloc,
    this.products,
    this.productsInfo,
  );

  @override
  createState() => _PosProductsScreenState();
}

class _PosProductsScreenState extends State<PosProductsScreen> {
  bool _isPortrait;
  bool _isTablet;
  bool isGridMode = true;
  TextEditingController searchController = TextEditingController();

  PosProductScreenBloc screenBloc;
  RefreshController _productsRefreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    screenBloc = PosProductScreenBloc(widget.posScreenBloc)
      ..add(PosProductsScreenInitEvent(
          widget.businessId, widget.products, widget.productsInfo));
    print('product length: ${widget.products.length}');
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
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
      listener: (BuildContext context, PosProductScreenState state) async {
        if (state.cartProgressed && !state.isLoadingCartView) {
          screenBloc.add(ResetCardProgressEvent());
          navigateWorkshopScreen(state, true);
        }
      },
      child: BlocBuilder<PosProductScreenBloc, PosProductScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, PosProductScreenState state) {
          return Scaffold(
            appBar:
                Appbar(widget.posScreenBloc.state.activeTerminal.name ?? ''),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: state.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _body(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(PosProductScreenState state) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            _toolBar(state),
//            _secondToolBar(state),
            InkWell(
              onTap: () {
                if (state.channelSetFlow == null || state.isLoadingCartView) return;
                if (state.channelSetFlow.cart == null ||
                    state.channelSetFlow.cart.isEmpty) {
                  Fluttertoast.showToast(msg: 'Cart is empty');
                } else {
                  screenBloc.add(CartOrderEvent());
                }
              },
              child: Container(
                width: GlobalUtils.mainWidth,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0xFFededf4),
                        Color(0xFFaeb0b7),
                      ]),
                ),
                child: state.isLoadingCartView
                    ? Container(
                  width: 25,
                  height: 25,
                  margin: EdgeInsets.only(right: 20),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ):Text(
                  'Pay with payever',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            Expanded(child: isGridMode ? gridBody(state) : _listBody(state)),
            Container(
              width: double.infinity,
              color: overlayBackground(),
              height: 124,
              alignment: Alignment.topCenter,
              padding:
                  EdgeInsets.only(top: 12, bottom: 40, left: 16, right: 16),
              child: Container(
                width: GlobalUtils.mainWidth,
                height: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (state.channelSetFlow == null) return;
                          navigateWorkshopScreen(state, false);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: overlayDashboardButtonsBackground(),
                          ),
                          child: Text(
                            'Amount',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: PosQRAppScreen(
                                businessId: state.businessId,
                                screenBloc: widget.posScreenBloc,
                                fromProductsScreen: true,
                              ),
                              type: PageTransitionType.fade,
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: overlayDashboardButtonsBackground(),
                          ),
                          child: Text(
                            'QR',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            // _bottomBar(state),
          ],
        ),
        state.searching
            ? Center(child: CircularProgressIndicator())
            : Container(),
      ],
    );
  }

  Widget _toolBar(PosProductScreenState state) {
    // searchController.text = state.searchText;
    return Container(
      height: 50,
      color: overlaySecondAppBar().withOpacity(0.9),
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              _filterButton(),
            ],
          ),
          Expanded(
            child: Container(
              height: 35,
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: overlayBackground(),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 20,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: TextFormField(
                      style: textFieldStyle,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Search products',
                        border: InputBorder.none,
                      ),
                      controller: searchController,
                      onChanged: (String value) {
                        screenBloc.add(ProductsFilterEvent(searchText: value));
                      },
                    ),
                  ),
                  if (searchController.text != null &&
                      searchController.text.length > 0)
                    InkWell(
                      onTap: () {
                        searchController.text = '';
                        screenBloc.add(ProductsFilterEvent(searchText: ''));
                      },
                      child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey[600]),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          )),
                    ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                screenBloc.add(
                    ProductsFilterEvent(orderDirection: !state.orderDirection));
              },
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/sort-by-button.svg',
                  width: 20,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<MenuItem>(
              icon: SvgPicture.asset(
                isGridMode
                    ? 'assets/images/grid.svg'
                    : 'assets/images/list.svg',
              ),
              offset: Offset(0, 100),
              onSelected: (MenuItem item) => item.onTap(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: overlayFilterViewBackground(),
              itemBuilder: (BuildContext context) {
                return gridListPopUpActions(
                  (grid) => {
                    setState(() {
                      isGridMode = grid;
                    })
                  },
                ).map((MenuItem item) {
                  return PopupMenuItem<MenuItem>(
                    value: item,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        item.icon,
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _secondToolBar(PosProductScreenState state) {
    num cartCount = 0;
    if (widget.posScreenBloc.state.activeTerminal == null) return Container();

    if (state.channelSetFlow != null && state.channelSetFlow.cart != null) {
      state.channelSetFlow.cart
          .forEach((element) => cartCount += element.quantity);
    }

    return Container(
      height: 50,
      color: overlaySecondAppBar().withOpacity(0.8),
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 12),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.isUpdating
                      ? Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            if (state.channelSetFlow == null) {
                              // screenBloc.add(GetChannelSetFlowEvent());
                              // Future.delayed(Duration(milliseconds: 1500)).then((value) {
                              //   if (state.channelSetFlow != null) {
                              //     navigateWorkshopScreen(state);
                              //   } else {
                              //     Fluttertoast.showToast(msg: 'Can not fetch Pay flow.');
                              //   }
                              // });
                              return;
                            }
                            navigateWorkshopScreen(state, false);
                          },
                          child: Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      width: 1,
                      color: Color(0xFF888888),
                      height: 24,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: PosQRAppScreen(
                        businessId: state.businessId,
                        screenBloc: widget.posScreenBloc,
                        fromProductsScreen: true,
                      ),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                child: Text(
                  'QR',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          state.isLoadingCartView
              ? Container(
                  width: 25,
                  height: 25,
                  margin: EdgeInsets.only(right: 20),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : IconBadge(
                  icon: Icon(
                    Icons.shop,
                    color: Colors.white,
                    size: 20,
                  ),
                  itemCount: cartCount,
                  badgeColor: Colors.red,
                  itemColor: Colors.white,
                  hideZero: true,
                  onTap: () {
                    if (state.channelSetFlow == null) {
                      // Fluttertoast.showToast(msg: 'Loading...');
                      return;
                    }
                    if (state.channelSetFlow.cart == null ||
                        state.channelSetFlow.cart.isEmpty) {
                      Fluttertoast.showToast(msg: 'Cart is empty');
                    } else {
                      screenBloc.add(CartOrderEvent());
                    }
                  },
                ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _filterButton() {
    return InkWell(
      onTap: () async {
        await showGeneralDialog(
          barrierColor: null,
          transitionBuilder: (context, a1, a2, wg) {
            final curvedValue = 1.0 - Curves.ease.transform(a1.value);
            return Transform(
              transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
              child: PosProductsFilterScreen(
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
        padding: EdgeInsets.all(8),
        child: SvgPicture.asset(
          'assets/images/filter.svg',
          width: 20,
        ),
      ),
    );
  }

  Widget gridBody(PosProductScreenState state) {
    if (state.products == null || state.products.isEmpty) return Container();

    List<Widget> productsItems = [];
    state.products.forEach((product) {
      productsItems.add(PosProductGridItem(
        product,
        onTap: (ProductsModel model) {
          navigateProductDetail(model, state);
        },
      ));
    });
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
//        vertical: 16,
      ),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(
          semanticsLabel: '',
        ),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          height: 1,
          builder: (context, status) {
            return Container();
          },
        ),
        controller: _productsRefreshController,
        onRefresh: () {
          _refreshProducts();
        },
        onLoading: () {
          _loadMoreProducts(state);
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverGrid.count(
              crossAxisCount: _isTablet ? 3 : (_isPortrait ? 2 : 3),
              crossAxisSpacing: _isTablet ? 12 : (_isPortrait ? 0 : 6),
              mainAxisSpacing: _isTablet ? 12 : (_isPortrait ? 6 : 6),
              children: List.generate(
                productsItems.length,
                (index) {
                  return productsItems[index];
                },
              ),
            ),
            new SliverToBoxAdapter(
              child: state.products.length < state.productsInfo.itemCount
                  ? Container(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  Widget _listBody(PosProductScreenState state) {
    if (state.products == null || state.products.isEmpty) return Container();
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
//                    margin: EdgeInsets.only(top: 20),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))),
          );
        },
      ),
      controller: _productsRefreshController,
      onRefresh: () {
        _refreshProducts();
      },
      onLoading: () {
        _loadMoreProducts(state);
      },
      child: ListView.builder(
          itemCount: state.products.length,
          itemBuilder: (context, index) =>
              _productListBody(state, state.products[index])),
    );
  }

  void _loadMoreProducts(PosProductScreenState state) async {
    print('Load more products');
    if (state.productsInfo.page == state.productsInfo.pageCount) {
      _productsRefreshController.loadComplete();
      return;
    }
    screenBloc.add(PosProductsLoadMoreEvent());
    await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
    _productsRefreshController.loadComplete();
  }

  void _refreshProducts() async {
    screenBloc.add(PosProductsReloadEvent());
    await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
    _productsRefreshController.refreshCompleted(resetFooterState: true);
  }

  Widget _productListBody(PosProductScreenState state, ProductsModel model) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Measurements.width * 0.5,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 19, right: 17),
                      height: 40,
                      width: 40,
                      child: model.images != null &&
                              model.images.isNotEmpty &&
                              model.images.first != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  '${Env.storage}/products/${model.images.first}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  color: overlayBackground(),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : SvgPicture.asset('assets/images/no_image.svg'),
                    ),
                    Flexible(child: Text(model.title)),
                  ],
                ),
              ),
              Text('${Measurements.currency(model.currency)}${model.price}'),
              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  navigateProductDetail(model, state);
                },
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.white.withOpacity(0.5)),
      ],
    );
  }

  void navigateProductDetail(ProductsModel model, PosProductScreenState state) {
    Navigator.push(
      context,
      PageTransition(
        child: PosProductDetailScreen(
          model,
          screenBloc,
          state.channelSetFlow,
        ),
        type: PageTransitionType.fade,
      ),
    );
  }

  void navigateWorkshopScreen(PosProductScreenState state, bool cartStatus) {
    Navigator.push(
      context,
      PageTransition(
        child: WorkshopView(
          business: widget.posScreenBloc.state.activeBusiness,
          terminal: widget.posScreenBloc.state.activeTerminal,
          channelSetFlow: state.channelSetFlow,
          channelSetId: widget.posScreenBloc.state.activeTerminal.channelSet,
          defaultCheckout: widget.posScreenBloc.state.defaultCheckout,
          fromCart: cartStatus,
          cart: cartStatus ? state.channelSetFlow.cart : null,
          onTapClose: () {
            setState(() {
              cartStatus = false;
            });
          },
        ),
        type: PageTransitionType.fade,
      ),
    );
  }
}
