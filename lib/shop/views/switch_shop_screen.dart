import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/create_shop_screen.dart';
import 'package:payever/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';


class SwitchShopScreen extends StatefulWidget {
  final ShopScreenBloc screenBloc;
  final String businessId;

  SwitchShopScreen({
    this.screenBloc,
    this.businessId,
  });

  @override
  createState() => _SwitchShopScreenState();
}

class _SwitchShopScreenState extends State<SwitchShopScreen> {
  bool _isPortrait;
  bool _isTablet;
  ShopDetailModel defaultShop;
  ShopDetailModel selectedShop;

  @override
  void initState() {

    defaultShop = widget.screenBloc.state.activeShop;
    selectedShop = widget.screenBloc.state.activeShop;
    if (defaultShop == null) {
      defaultShop = widget.screenBloc.state.shops.first;
      selectedShop = widget.screenBloc.state.shops.first;
    }
    super.initState();
  }

  @override
  void dispose() {
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
      bloc: widget.screenBloc,
      listener: (BuildContext context, ShopScreenState state) async {
        if (state is ShopScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is ShopScreenStateSuccess) {
          Navigator.pop(context, 'refresh');
        }
      },
      child: BlocBuilder<ShopScreenBloc, ShopScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ShopScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(ShopScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: Appbar('Shop list'),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Container(
            alignment: Alignment.center,
            child: Container(
              width: Measurements.width,
              child: _getBody(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBody(ShopScreenState state) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _activeShopWidget(state) ,
          Text(
            'Online Shops',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          _onlineShops(state),
        ],
      ),
    );
  }

  Widget _activeShopWidget(ShopScreenState state) {
    String avatarName = '';
    if (defaultShop != null) {
      String name = defaultShop.name;
      if (name.contains(' ')) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(' ')[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    }
    return Container(
      padding: EdgeInsets.only(top: 64, bottom: 64),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: defaultShop.picture != null ?
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey.withOpacity(0.5),
                  image: DecorationImage(
                    image: NetworkImage('${defaultShop.picture}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ):
              Container(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.withOpacity(0.5),
                  child: Text(
                    avatarName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            MaterialButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: CreateShopScreen(
                      businessId: widget.businessId,
                      screenBloc: widget.screenBloc,
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              height: 32,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: overlayBackground(),
              child: Text(
                '+ Add Shop',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _onlineShops(ShopScreenState state) {
    return GridView.count(
      crossAxisCount: _isTablet ? 5: 3,
      childAspectRatio: 0.7,
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 24),
      shrinkWrap: true,
      children: state.shops.map((shopModel) => ShopCell(
        onTap: (ShopDetailModel tn){
          setState(() {
            selectedShop = tn;
            defaultShop = tn;
          });
        },
        selected: selectedShop,
        shopModel: shopModel,
        onMore: (ShopDetailModel tn) {
          showCupertinoModalPopup(
            context: context,
            builder: (builder) {
              return Container(
                height: 64.0 * 2 + MediaQuery.of(context).padding.bottom,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: overlayFilterViewBackground(),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  children: popupButtons(context, tn),
                ),
              );
            },
          );
        },
        onOpen: (ShopDetailModel shopDetailModel) {
          Navigator.pop(context);
          if (shopDetailModel != null) {
            _launchURL('https://${shopDetailModel.accessConfig.internalDomain}.new.payever.shop/');
          }
        },
      )).toList(),
      physics: NeverScrollableScrollPhysics(),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> popupButtons(BuildContext context, ShopDetailModel shopDetailModel) {
    return [
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              widget.screenBloc.add(SetDefaultShop(businessId: widget.businessId, shopId: shopDetailModel.id));
            },
            child: Text('Set as Default'),
          ),
        ),
      ),
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Edit'),
          ),
        ),
      ),
    ];
  }
}

class ShopCell extends StatelessWidget {
  final Function onTap;
  final ShopDetailModel shopModel;
  final ShopDetailModel selected;
  final Function onOpen;
  final Function onMore;

  ShopCell({
    this.onTap,
    this.shopModel,
    this.selected,
    this.onOpen,
    this.onMore
  });

  @override
  Widget build(BuildContext context) {
    String avatarName = '';
    String name = shopModel.name;
    if (name.contains(' ')) {
      avatarName = name.substring(0, 1);
      avatarName = avatarName.toUpperCase() + name.split(' ')[1].substring(0, 1).toUpperCase();
    } else {
      avatarName = name.substring(0, 1) + name.substring(name.length - 1).toUpperCase();
      avatarName = avatarName.toUpperCase();
    }
    return InkWell(

      onTap: () {
        onTap(shopModel);
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: shopModel.picture != null ?
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('${shopModel.picture}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ):
              Container(
                width: 80,
                height: 80,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.withOpacity(0.5),
                  child: Text(
                    avatarName,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            Text(
              shopModel.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: 36,
              alignment: Alignment.center,
              child: selected.id == shopModel.id ? Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      onOpen(shopModel);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 20,
                      padding: EdgeInsets.symmetric(horizontal: 12,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: overlayBackground(),
                      ),

                      child: Text(
                        'Open',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        onMore(shopModel);
                      },
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ): Container(),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: selected.id == shopModel.id ? overlayBackground().withOpacity(0.8) : Colors.transparent.withOpacity(0),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
