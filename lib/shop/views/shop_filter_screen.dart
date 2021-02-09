import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

class ShopFilterScreen extends StatefulWidget {
  final ShopScreenBloc screenBloc;

  ShopFilterScreen({
    this.screenBloc,
  });

  @override
  _ShopFilterScreenState createState() =>
      _ShopFilterScreenState();
}

class _ShopFilterScreenState extends State<ShopFilterScreen> {
  String selectedCategory = '';
  List<String> subCategories = [];


  @override
  void initState() {
   // selectedCategory = widget.screenBloc.state.selectedCategory;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, ShopScreenState state) async {
        if (state is ShopScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        }
      },
      child: BlocBuilder<ShopScreenBloc, ShopScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ShopScreenState state) {
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

  Widget _getBody(ShopScreenState state) {
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
              child: InkWell(
                onTap: () async {
                  widget.screenBloc.add(ShopCategorySelected(
                      category: selectedCategory,
                      subCategories: subCategories));
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: overlayFilterViewBackground(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(color: iconColor()),
                  ),
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
                        selectedCategory = 'My Themes';
                        subCategories = [];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.only(left: 8),
                      height: 44,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'My Themes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: isSelected('My Themes')
                            ? overlayColor()
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 8),
                      height: 44,
                      child: Text(
                        'All Themes',
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _divider(),
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      String category = state.templates[index].code;
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
                                  SizedBox(width: 8,),
                                  SvgPicture.asset('assets/images/filter_${state.templates[index].icon}.svg'),
                                  SizedBox(width: 8,),
                                  Text(
                                    getMainCategory(category),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Visibility(
                                    visible: getMainCategory(category).isNotEmpty,
                                    child: Icon(
                                      isSelected(category)
                                          ? Icons.clear
                                          : Icons.add,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _subCategories(state.templates[index]),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => _divider(),
                    itemCount:state.templates.length,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subCategories(TemplateModel templateModel) {
    return isSelected(templateModel.code)
        ? ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              String subCategory = templateModel.items[index].code;
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
            itemCount: templateModel.items.length,
          )
        : Container();
  }

  bool isSelected(String category) {
    if (selectedCategory == null || selectedCategory.isEmpty) return false;
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
    // print('Shop filter code: $code');
    if (code.isEmpty) return '';
    code = code.replaceAll('BUSINESS_PRODUCT_', '');
    code = code.replaceAll('_', ' ');
    return code[0].toUpperCase() + code.substring(1).toLowerCase();
  }

  String getSubCategory(String code) {
    if (code.isEmpty) return '';
    String title = code.split('_').first;
    code = code.replaceAll('${title}_', '');
    code = code.replaceAll('_', ' ');
    return code[0].toUpperCase() + code.substring(1).toLowerCase();
  }

}
