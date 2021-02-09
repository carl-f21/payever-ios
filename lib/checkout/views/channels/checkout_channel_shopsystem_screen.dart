import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutChannelShopSystemScreen extends StatefulWidget {

  final CheckoutScreenBloc checkoutScreenBloc;
  final String business;
  final ConnectModel connectModel;

  CheckoutChannelShopSystemScreen({
    this.business,
    this.checkoutScreenBloc,
    this.connectModel,
  });

  @override
  _CheckoutChannelShopSystemScreenState createState() => _CheckoutChannelShopSystemScreenState();
}

class _CheckoutChannelShopSystemScreenState extends State<CheckoutChannelShopSystemScreen> {

  CheckoutChannelSettingScreenBloc screenBloc;
  bool _isPortrait;
  bool _isTablet;
  double iconSize;
  double margin;

  bool isAdd = false;
  bool isExpandedSection1 = false;
  bool isExpandedSection2 = false;
  int selectedApiSection = -1;

  String clipboardString = '';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    screenBloc = CheckoutChannelSettingScreenBloc(checkoutScreenBloc: widget.checkoutScreenBloc);
    screenBloc.add(CheckoutChannelSettingScreenInitEvent(
      business: widget.business,
      connectModel: widget.connectModel,
    ));
    super.initState();
    Clipboard.getData('text/plain').then((value) {
      setState(() {
        if (value != null)
          clipboardString = value.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
      listener: (BuildContext context, CheckoutChannelSettingScreenState state) async {
        if (state is CheckoutScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if(!state.isUpdating) {
          setState(() {
            isAdd = false;
          });
        }
      },
      child: BlocBuilder<CheckoutChannelSettingScreenBloc, CheckoutChannelSettingScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, CheckoutChannelSettingScreenState state) {
          iconSize = _isTablet ? 120: 80;
          margin = _isTablet ? 24: 16;
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
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
                      Expanded(
                        child: _getBody(state),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(CheckoutChannelSettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Text(isAdd ? 'Create key' : Language.getPosConnectStrings(widget.connectModel.integration.displayOptions.title),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            isAdd
                ? setState(() {
                    isAdd = false;
                  })
                : Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(CheckoutChannelSettingScreenState state) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          child: SingleChildScrollView(
            child: isAdd ? _getAdd(state) : _getShopSystem(state),
          ),
        ),
      ),
    );
  }

  Widget _getShopSystem(CheckoutChannelSettingScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          state.shopSystem != null ? shopSystemItem('Download', isExpandedSection1, ()=>{
            setState(() {
              isExpandedSection1 = !isExpandedSection1;
              if (isExpandedSection1)
                isExpandedSection2 = false;
            })
          }) : Container(),
          state.shopSystem != null ? _divider() : Container(),
          state.shopSystem != null ? _downloads(state) : Container(),
          state.shopSystem != null ? _divider() : Container(),
          shopSystemItem('API keys', isExpandedSection2, ()=>{
            setState(() {
              isExpandedSection2 = !isExpandedSection2;
              if (isExpandedSection2)
                isExpandedSection1 = false;
            })
          }),
          isExpandedSection2 ? _divider(): Container(),
          _apikeys(state),
          isExpandedSection2 ? _divider(): Container(),
          _add(),
        ],
      ),
    );
  }

  Widget _getAdd(CheckoutChannelSettingScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: TextFormField(
              onChanged: (val) {

              },
              controller: controller,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name required';
                } else {
                  return null;
                }
              },
              decoration: new InputDecoration(
                labelText: 'Name',
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 16, right: 16),
              ),
              style: TextStyle(fontSize: 16),
              keyboardType: TextInputType.url,
            ),
          ),
          Container(
            height: 50,
            color: Colors.black54,
            child: SizedBox.expand(
              child: state.isUpdating ?? false
                  ? Center(child: CircularProgressIndicator())
                  : MaterialButton(
                      onPressed: () async {
                        screenBloc.add(
                            CreateCheckoutAPIkeyEvent(name: controller.text, redirectUri: ''));
                      },
                      child: Text(
                        'Create',
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget shopSystemItem(String title, bool open, Function onTop) {
    return  GestureDetector(
      onTap: onTop,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              title == 'Download'
                  ? Icons.file_download
                  : Icons.lock,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Spacer(),
            Icon(
              open
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _downloads(CheckoutChannelSettingScreenState state) {
    return isExpandedSection1 ?
        Container(
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Plugin plugin = index < state.shopSystem.pluginFiles.length ? state.shopSystem.pluginFiles[index] : null;
              return Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: margin / 2),
                          ),
                          Flexible(
                            child: Text(plugin != null ?
                            'Plugin(${plugin.version})' : 'Instructions',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Helvetica Neue',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (plugin != null) {

                        } else {
                          _launchURL('https://getpayever.com/shopsystem/shopware');
                        }
                      },
                      color: overlayBackground(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 0,
                      padding:
                      EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        'Download',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'HelveticaNeueMed',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return _divider();
            },
            itemCount: state.shopSystem.pluginFiles.length + 1,
          ),
        ) :
        Container();

  }

  Widget _apikeys(CheckoutChannelSettingScreenState state) {
    return isExpandedSection2 ?
    Container(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          APIkey apIkey = state.apiKeys[index];
          return Column(
            children: <Widget>[
              _apiKeyItem(apIkey, index),
              selectedApiSection == index ? _apiKeyDetailWidget(apIkey, index): Container(),
            ],
          );
        },
        separatorBuilder: (context, index) => _divider(),
        itemCount: state.apiKeys.length,
      ),
    )  :
    Container();
  }

  Widget _apiKeyItem(APIkey apIkey, int index) {
    return InkWell(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: margin / 2),
                  ),
                  Flexible(
                    child: Text( apIkey.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica Neue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () async {
                screenBloc.add(DeleteCheckoutAPIkeyEvent(client: apIkey.id));
              },
              color: overlayBackground(),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(12),
              ),
              height: 24,
              minWidth: 0,
              padding:
              EdgeInsets.only(left: 8, right: 8),
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'HelveticaNeueMed',
                ),
              ),
            ),
            SizedBox(width: 10,),
            Icon(Icons.add),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          selectedApiSection == index ? selectedApiSection = -1: selectedApiSection = index;
        });
      },
    );
  }

  Widget _apiKeyDetailWidget(APIkey apIkey, int index) {
    DateTime createDate = DateTime.parse(apIkey.createdAt) ?? DateTime.now();
    return Column(
      children: <Widget>[
        Container(
          height: 36,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: margin / 2),
                    ),
                    Flexible(
                      child: Text(
                        'Client Id',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'HelveticaNeueMed',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4,),
              Flexible(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        apIkey.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        Clipboard.setData(ClipboardData(text: apIkey.id));
                        setState(() {
                          clipboardString = apIkey.id;
                        });
                      },
                      color: overlayBackground(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 0,
                      padding:
                      EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        clipboardString == apIkey.id ? 'Copied': 'Copy',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'HelveticaNeueMed',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 36,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: margin / 2),
                    ),
                    Flexible(
                      child: Text(
                        'Client secret',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'HelveticaNeueMed',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4,),
              Flexible(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        apIkey.secret,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        Clipboard.setData(ClipboardData(text: apIkey.secret));
                        setState(() {
                          clipboardString = apIkey.secret;
                        });
                      },
                      color: overlayBackground(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 0,
                      padding:
                      EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        clipboardString == apIkey.secret ? 'Copied': 'Copy',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'HelveticaNeueMed',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 36,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: margin / 2),
                    ),
                    Flexible(
                      child: Text(
                        'Business UUID',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'HelveticaNeueMed',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4,),
              Flexible(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        apIkey.businessId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        Clipboard.setData(ClipboardData(text: apIkey.businessId));
                        setState(() {
                          clipboardString = apIkey.businessId;
                        });
                      },
                      color: overlayBackground(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 0,
                      padding:
                      EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        clipboardString == apIkey.businessId ? 'Copied': 'Copy',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'HelveticaNeueMed',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 36,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: margin / 2),
                    ),
                    Flexible(
                      child: Text(
                        'Created',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'HelveticaNeueMed',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4,),
              Flexible(
                flex: 2,
                child: Text(
                  formatDate(createDate, [dd, '.', mm, '.', yyyy, ' ', hh, ':', nn]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _add(){
    return isExpandedSection2 ?
    Container(
      height: 50,
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: (){
            setState(() {
              controller.text = '';
              isAdd = true;
            });
          },
          color: overlayBackground(),
          child: Row(
            children: <Widget>[
              Text(
                '+ Add',
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    ): Container();
  }

  Widget _divider() {
    return Divider(
      height: 0,
      thickness: 0.5,
      color: Colors.white70,
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}