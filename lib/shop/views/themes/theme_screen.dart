import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/shop_filter_screen.dart';
import 'package:payever/shop/widgets/theme_cell.dart';
import 'package:payever/theme.dart';

class ThemesScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final ShopModel activeShop;
  final DashboardScreenBloc dashboardScreenBloc;
  final ShopScreenBloc screenBloc;

  ThemesScreen({
    this.globalStateModel,
    this.screenBloc,
    this.activeShop,
    this.dashboardScreenBloc,
  });

  @override
  createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isPortrait;
  bool _isTablet;

  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  double iconSize;
  double margin;
  bool isGridMode = true;

  @override
  void initState() {
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

    iconSize = _isTablet ? 120 : 80;
    margin = _isTablet ? 24 : 16;

    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, ShopScreenState state) async {
        if (state is ShopScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        } else if (state is ShopScreenStateThemeFailure) {
          Fluttertoast.showToast(msg: state.error);
        }
      },
      child: BlocBuilder<ShopScreenBloc, ShopScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ShopScreenState state) {
          return Scaffold(
            appBar: Appbar(Language.getPosStrings('info_boxes.terminal.panels.themes.title'),),
              body: SafeArea(
                  bottom: false,child: BackgroundBase(true, body: _body(state))));
        },
      ),
    );
  }

  Widget _topBar(ShopScreenState state, List<ThemeListModel> themeListModels) {
    String itemsString = '';
    int selectedCount = 0;
    if (themeListModels.length > 0) {
      selectedCount =
          themeListModels.where((element) => element.isChecked).toList().length;
    }
    itemsString =
        '${themeListModels.length} themes in ${_getCollections(state)}';
    return selectedCount == 0
        ? Container(
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
                            final curvedValue =
                                1.0 - Curves.ease.transform(a1.value);
                            return Transform(
                              transform: Matrix4.translationValues(
                                  -curvedValue * 200, 0.0, 0),
                              child: ShopFilterScreen(
                                screenBloc: widget.screenBloc,
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
                      onTap: () {},
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minWidth: 100,
                          maxWidth: Measurements.width / 2,
                          maxHeight: 36,
                          minHeight: 36),
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
                                hintText: 'Search in Themes',
                                isDense: true,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
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
                            return gridListPopUpActions((grid) => {
                              setState(() {
                                isGridMode = grid;
                              })
                            },).map((MenuItem item) {
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
                ),
              ],
            ),
          )
        : Container(
            height: 50,
            color: overlaySecondAppBar(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    widget.screenBloc.add(SelectAllThemesEvent(isSelect: true));
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
                    widget.screenBloc
                        .add(SelectAllThemesEvent(isSelect: false));
                  },
                  child: Text(
                    'Deselect all',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (selectedCount < 2)
                  Row(
                    children: <Widget>[
                      Container(
                        height: 36,
                        width: 0.5,
                        color: Colors.white38,
                      ),
                      MaterialButton(
                        onPressed: () {
                          String themeId = themeListModels.firstWhere((element) => element.isChecked).themeModel.id;
                          duplicateTheme(state, themeId);
                          // screenBloc.add(DeleteSelectedContactsEvent());
                        },
                        child: state.isDuplicate ? Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(strokeWidth: 2,),
                        ) :Text(
                          'Duplicate',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
  }

  Widget _body(ShopScreenState state) {
    List<ThemeListModel> themes = _getSearchThemes(_getThemes(state));
    return Container(
      child: Column(
        children: <Widget>[
          _topBar(state, themes),
          Expanded(
            child: (themes.length > 0)
                ? isGridMode
                    ? GridView.count(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 16),
                        children: themes.map((theme) {
                          return ThemeCell(
                            themeListModel: theme,
                            isInstall: state.isUpdating,
                            installThemeId: state.installThemeId,
                            onTapInstall: (theme) =>
                                installTheme(state, theme.id),
                            // onTapDelete: (theme) {
                            //   if (state.activeShop != null) {
                            //     widget.screenBloc.add(DeleteThemeEvent(
                            //       businessId: widget
                            //           .globalStateModel.currentBusiness.id,
                            //       themeId: theme.id,
                            //       shopId: state.activeShop.id,
                            //     ));
                            //   }
                            // },
                            // onTapDuplicate: (theme) {
                            //   if (state.activeShop != null) {
                            //     widget.screenBloc.add(DuplicateThemeEvent(
                            //       businessId: widget
                            //           .globalStateModel.currentBusiness.id,
                            //       themeId: theme.id,
                            //       shopId: state.activeShop.id,
                            //     ));
                            //   }
                            // },
                            onCheck: (ThemeListModel model) {
                              widget.screenBloc.add(SelectThemeEvent(
                                model: model,
                              ));
                            },
                          );
                        }).toList(),
                        crossAxisCount: (_isTablet || !_isPortrait) ? 3 : 2,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      )
                    : ListView.builder(
                        itemCount: themes.length,
                        itemBuilder: (context, index) =>
                            _listItemBuilder(state, themes[index]))
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _listItemBuilder(
      ShopScreenState state, ThemeListModel themeListModel) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 70,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      child: InkWell(
                          onTap: () {
                            widget.screenBloc.add(SelectThemeEvent(
                              model: themeListModel,
                            ));
                          },
                          child: themeListModel.isChecked
                              ? Icon(
                                  Icons.check_circle,
                                  size: 20,
                                )
                              : Icon(
                                  Icons.radio_button_unchecked,
                                  size: 20,
                                )),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 19, right: 8),
                      height: 40,
                      width: 40,
                      child: CachedNetworkImage(
                        imageUrl:
                            '${Env.storage}${themeListModel.themeModel.picture}',
                        imageBuilder: (context, imageProvider) => Container(
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
                            child: Center(child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Flexible(child: Text(themeListModel.themeModel.name)),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      // updateWallpaper(wallpaper);
                    },
                    child: Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: overlayButtonBackground(),
                      ),
                      child: Center(
                        child: Text(
                          'Preview',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      installTheme(state, themeListModel.themeModel.id);
                    },
                    child: Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: overlayButtonBackground(),
                      ),
                      child: Center(
                        child: state.isUpdating &&
                                state.installThemeId ==
                                    themeListModel.themeModel.id
                            ? Container(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Set',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.white.withOpacity(0.5)),
      ],
    );
  }

  List<ThemeListModel> _getSearchThemes(List<ThemeListModel> themes) {
    String name = searchTextController.text;
    print('upate value: $name');
    if (name.isEmpty) return themes;
    if (themes == null || themes.isEmpty) return [];
    List<ThemeListModel> themeListModels = [];
    themeListModels = themes
        .where((element) =>
            element.themeModel.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
    return themeListModels ?? [];
  }

  List<ThemeListModel> _getThemes(ShopScreenState state) {
    String selectedCategory = state.selectedCategory;
    List<String> subCategories = state.subCategories;
    if (selectedCategory.isEmpty || selectedCategory == 'All')
      return state.themeListModels;
    else if (selectedCategory == 'My Themes') {
      return state.myThemeListModels;
    } else {
      if (subCategories.isEmpty)
        return state.themeListModels;
      else {
        List<ThemeListModel> themeListModels = [];
        TemplateModel templateModel = state.templates
            .firstWhere((element) => element.code == selectedCategory);
        subCategories.forEach((subCategory) {
          templateModel.items
              .firstWhere((item) => item.code == subCategory)
              .themes
              .forEach((theme) {
            themeListModels
                .add(ThemeListModel(themeModel: theme, isChecked: false));
          });
        });
        return themeListModels;
      }
    }
  }

  void installTheme(ShopScreenState state, String themeId) {
    if (state.activeShop != null) {
      widget.screenBloc.add(InstallThemeEvent(
        businessId: widget.globalStateModel.currentBusiness.id,
        themeId: themeId,
        shopId: state.activeShop.id,
      ));
    } else {
      Fluttertoast.showToast(msg: 'There is no active shop!');
    }
  }

  void duplicateTheme(ShopScreenState state, String themeId) {
      if (state.activeShop != null && themeId.isNotEmpty) {
        widget.screenBloc.add(DuplicateThemeEvent(
          businessId: widget
              .globalStateModel.currentBusiness.id,
          themeId: themeId,
          shopId: state.activeShop.id,
        ));
      } else {
        Fluttertoast.showToast(msg: 'There is no active shop!');
      }
  }

  String _getCollections(ShopScreenState state) {
    String selectedCategory = state.selectedCategory;
    List<String> subCategories = state.subCategories;
    int collection = 0;
    if (selectedCategory.isEmpty ||
        selectedCategory == 'All' ||
        selectedCategory == 'My Themes') {
      collection = 1;
    } else {
      if (subCategories.isEmpty)
        collection = 1;
      else {
        collection = subCategories.length;
      }
    }
    return '$collection collection' + (collection > 1 ? 's' : '');
  }
}
