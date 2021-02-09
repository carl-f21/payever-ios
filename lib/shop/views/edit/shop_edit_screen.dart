import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/shop_edit_templetes_screen.dart';
import 'package:payever/shop/views/edit/template_detail_screen.dart';
import 'package:payever/shop/views/edit/template_view.dart';

class ShopEditScreen extends StatefulWidget {
  final ShopScreenBloc shopScreenBloc;

  const ShopEditScreen(this.shopScreenBloc);

  @override
  _ShopEditScreenState createState() => _ShopEditScreenState();
}

class _ShopEditScreenState extends State<ShopEditScreen> {
  bool slideOpened = true;
  bool isPortrait;
  bool isTablet;
  ShopEditScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = ShopEditScreenBloc(widget.shopScreenBloc)
      ..add(ShopEditScreenInitEvent());
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return BlocListener(
      listener: (BuildContext context, ShopEditScreenState state) async {},
      bloc: screenBloc,
      child: BlocBuilder(
        bloc: screenBloc,
        builder: (BuildContext context, state) {
          return Scaffold(
              appBar: CustomAppBar(onTapAdd: ()=> _navigateTemplatesScreen(),),
              backgroundColor: Colors.grey[800],
              body: SafeArea(bottom: false, child: _body(state)));
        },
      ),
    );
  }

  Widget _body(ShopEditScreenState state) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      padding: EdgeInsets.all(6),
      child: Row(
        children: [
          if (slideOpened) Expanded(flex: (isTablet || !isPortrait) ? 6 : 10, child: _slidBar(state)),
          if (slideOpened)
            VerticalDivider(),
          Expanded(flex: 23, child: _mainBody(state)),
        ],
      ),
    );
  }

  Widget _mainBody(ShopEditScreenState state) {
    List<ShopPage> pages = state.pages
        .where((page) => page.type == 'replica')
        .toList();
    ShopPage homePage;
    if (pages != null && pages.isNotEmpty) {
      homePage = pages.firstWhere((page) => page.variant == 'front');
    }
    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: 1.8/1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(6),
              color: Colors.white,
              child: homePage != null
                  ? _templateItem(homePage, showName: false)
                  : Container(),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Visibility(
            visible: !slideOpened,
            child: IconButton(
              icon: Icon(Icons.navigate_next, color: Colors.black45,),
              onPressed: () {
                setState(() {
                  slideOpened = !slideOpened;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _slidBar(ShopEditScreenState state) {
    List<ShopPage> pages = state.pages
        .where((page) => page.type == 'replica')
        .toList();
    bool activeMode = true;
    int length = activeMode ? pages.length : state.previews.length;
    double aspectRatio = activeMode ? 1 : 2/1;
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return AspectRatio(
                      aspectRatio: aspectRatio,
                      child: activeMode
                          ? _templateItem(pages[index])
                          :_previewItem(index));
                },
                separatorBuilder: (index, context) => Divider(color: Colors.transparent,),
                itemCount: length),
          ),
          Container(
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                    child:
                    IconButton(
                        icon: Icon(Icons.add_box),
                        onPressed: () {
                          _navigateTemplatesScreen();
                        })),
                Positioned(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          slideOpened = !slideOpened;
                        });
                      },
                      child: Icon(
                        (slideOpened
                            ? Icons.navigate_before
                            : Icons.navigate_next),
                        size: 20,
                      )),
                  top: 0,
                  bottom: 0,
                  right: 0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _previewItem(int index) {
    Preview preview = screenBloc.state.previews[index];
    return Container(
      padding: EdgeInsets.only(left: 10, right: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Text('${index + 1}')),
          SizedBox(
            width: 3,
          ),
          Expanded(
              child: CachedNetworkImage(
                imageUrl: '${preview.previewUrl}',
                imageBuilder: (context, imageProvider) =>
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                color: Colors.white,
                placeholder: (context, url) => Container(
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 0.8,
                      child: SvgPicture.asset(
                        'assets/images/no_image.svg',
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _templateItem(ShopPage page, {bool showName = true}) {
    Template template = page != null
        ? Template.fromJson(screenBloc.state.templates[page.templateId])
        : null;
    String pageName = page == null ? 'Empty' : page.name;

    return Container(
      color: (showName && page.variant == 'front') ? Colors.blue : Colors.transparent,
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Expanded(
              child: (template != null)
                  ? TemplateView(
                shopPage: page,
                template: template,
                scrollable: !showName,
                stylesheets: screenBloc.state.stylesheets,
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: TemplateDetailScreen(
                            shopPage: page,
                            template: template,
                            stylesheets: screenBloc.state.stylesheets,
                          ),
                          type: PageTransitionType.fade));
                },
              )
                  : Container(
                color: Colors.white,
              )),
          if (showName)
            SizedBox(
              height: 5,
            ),
          if (showName)
            Text(
              pageName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }

  void _navigateTemplatesScreen() {
    Navigator.push(
        context,
        PageTransition(
            child: ShopEditTemplatesScreen(screenBloc),
            type: PageTransitionType.fade));
//    ShopPage page = screenBloc.state.pages.firstWhere((element) => element.name == 'ABOUT 2');
//    Template template = Template.fromJson(screenBloc.state.templates[page.templateId]);
//    Navigator.push(
//        context,
//        PageTransition(
//            child: TemplateDetailScreen(
//              shopPage: page,
//              template: template,
//              stylesheets: screenBloc.state.stylesheets,
//            ),
//            type: PageTransitionType.fade));

  }
}



class CustomAppBar extends StatelessWidget with PreferredSizeWidget {

  final Function onClose;
  final Function onTapAdd;

  CustomAppBar({this.onClose, this.onTapAdd});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            InkWell(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.brush,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: () => onTapAdd(),
            ),
            InkWell(
                child: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                onTap: null),
            InkWell(
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
              onTap: null,
            ),
            InkWell(
              child: Icon(
                Icons.remove_red_eye,
                color: Colors.white,
              ),
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}
