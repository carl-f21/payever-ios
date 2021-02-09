import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/theme.dart';

bool _isPortrait;
bool _isTablet;

class WallpaperCategoriesScreen extends StatefulWidget {
  final SettingScreenBloc screenBloc;

  WallpaperCategoriesScreen({
    this.screenBloc,
  });

  @override
  _WallpaperCategoriesScreenState createState() =>
      _WallpaperCategoriesScreenState();
}

class _WallpaperCategoriesScreenState extends State<WallpaperCategoriesScreen> {
  String selectedCategory = '';
  List<String> subCategories = [];

  @override
  void initState() {
//    selectedCategory = widget.screenBloc.state.selectedCategory;
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
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return new OrientationBuilder(builder: (context, orientation) {
            return Scaffold(
              backgroundColor: overlayBackground(),
              resizeToAvoidBottomPadding: false,
              body: BlurEffectView(
                radius: 0,
                child: SafeArea(
                  bottom: false,
                  child: state.isUpdating
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _getBody(state),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _getBody(SettingScreenState state) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(Icons.close),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      'Reset',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(24),
            height: 44,
            constraints: BoxConstraints.expand(height: 44),
            child: SizedBox(
              child: MaterialButton(
                onPressed: () {
                  widget.screenBloc.add(WallpaperCategorySelected(
                      category: selectedCategory,
                      subCategories: subCategories));
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                color: overlayFilterViewBackground(),
                child: Text(
                  'Done',
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = 'My Wallpapers';
                        subCategories = [];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24),
                      height: 44,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'My Wallpapers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          MaterialButton(
                            onPressed: () {
                              getImage();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 24,
                            minWidth: 60,
                            elevation: 0,
                            color: overlayColor(),
                            child: Text(
                              'Add',
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: isSelected('My Wallpapers')
                            ? overlayColor()
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _divider(),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = 'All';
                        subCategories = [];
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 24),
                      height: 44,
                      child: Text(
                        'All Wallpapers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected('All')
                            ? overlayColor()
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _divider(),
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      String category = widget
                          .screenBloc.state.wallpaperCategories[index].code;
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory =
                                    isSelected(category) ? '' : category;
                                if (selectedCategory.isEmpty) {
                                  subCategories = [];
                                }
                              });
                            },
                            child: Container(
                              height: 44,
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                  ),
                                  Text(
                                    getMainCategory(category),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    isSelected(category)
                                        ? Icons.clear
                                        : Icons.add,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _subCategories(widget
                              .screenBloc.state.wallpaperCategories[index]),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => _divider(),
                    itemCount:
                        widget.screenBloc.state.wallpaperCategories.length,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subCategories(WallpaperCategory wallpaperCategory) {
    return isSelected(wallpaperCategory.code)
        ? ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              String subCategory = wallpaperCategory.industries[index].code;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isContainSubCategory(subCategory))
                      subCategories.remove(subCategory);
                    else
                      subCategories.add(subCategory);
                  });
                },
                child: Container(
                  height: 44,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isContainSubCategory(subCategory))
                        ? overlayColor()
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      Text(
                        getSubCategory(subCategory),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return _divider();
            },
            itemCount: wallpaperCategory.industries.length,
          )
        : Container();
  }

  bool isSelected(String category) {
    if (selectedCategory == null) return false;
    return selectedCategory == category;
  }

  bool isContainSubCategory(String subCategory) {
    return subCategories.contains(subCategory);
  }

  Widget _divider() {
    return Divider(
      height: 0,
      thickness: 0.5,
    );
  }

  String getMainCategory(String code) {
    code = code.replaceAll('BUSINESS_PRODUCT_', '');
    code = code.replaceAll('_', ' ');
    return code[0].toUpperCase() + code.substring(1).toLowerCase();
  }

  String getSubCategory(String code) {
    String title = code.split('_').first;
    code = code.replaceAll('${title}_', '');
    code = code.replaceAll('_', ' ');
    return code[0].toUpperCase() + code.substring(1).toLowerCase();
  }

  Future getImage() async {
    PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);
    if (img.path != null) {
      print("_image: $img");
      widget.screenBloc.add(UploadWallpaperImage(file: File(img.path)));
    }
  }
}
