import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/views/product_detail_screen.dart';
import 'package:payever/products/widgets/product_filter_range_content_view.dart';
import 'package:payever/transactions/models/enums.dart';

import '../../theme.dart';
import 'collection_detail_screen.dart';

class ProductsFilterScreen extends StatefulWidget {
  final ProductsScreenBloc screenBloc;
  final GlobalStateModel globalStateModel;
  ProductsFilterScreen({
    this.screenBloc,
    this.globalStateModel,
  });

  @override
  _ProductsFilterScreenState createState() => _ProductsFilterScreenState();
}

class _ProductsFilterScreenState extends State<ProductsFilterScreen> {
  String selectedCategory = '';
  int selectedIndex = -1;

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
    return Scaffold(
      backgroundColor: overlayBackground(),
      resizeToAvoidBottomPadding: true,
      body: BlurEffectView(
        radius: 0,
        child: SafeArea(
          bottom: false,
          child: Container(
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: overlayFilterViewBackground(),
                        ),
                        child: Text(
                          'Done',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'My products',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  InkWell(
                                    onTap: ()=> goDetailProduct(),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: overlayButtonBackground(),
                                      ),
                                      child: Text('Add'),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = (selectedIndex == 0) ? -1 : 0;
                                      });
                                    },
                                    child: Icon(selectedIndex != 0 ? Icons.add : Icons.clear),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: selectedIndex == 0 ,
                          child: InkWell(
                            onTap: () {
                              widget.screenBloc.add(SwitchProductCollectionMode(isProductMode: true));
                            },
                            child: Container(
                              height: 44,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset('assets/images/collections-icon-filter.svg'),
                                  SizedBox(width: 14,),
                                  Text('All'),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: overlayButtonBackground()
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Collections',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  InkWell(
                                    onTap: ()=> goDetailCollection(),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: overlayButtonBackground(),
                                      ),
                                      child: Text('Add'),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = (selectedIndex == 1) ? -1 : 1;
                                      });
                                    },
                                    child: Icon(selectedIndex != 1 ? Icons.add : Icons.clear),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: selectedIndex == 1,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 8, bottom: 8,),
                            itemBuilder: (context, index) {
                              CollectionListModel item = index == 0 ? null : widget.screenBloc.state.collectionLists[index];
                              return InkWell(
                                onTap: () {
                                  widget.screenBloc.add(SwitchProductCollectionMode(isProductMode: false));
                                },
                                child: Container(
                                  height: 44,
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset('assets/images/collections-icon-filter.svg'),
                                      SizedBox(width: 14,),
                                      Text(item == null ? 'All' : item.collectionModel.name),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: overlayButtonBackground()
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Container();
                            },
                            itemCount: widget.screenBloc.state.collectionLists.length + 1,
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 0,
                              thickness: 0,
                              color: Colors.transparent,
                            );
                          },
                          itemCount: filterProducts.keys.toList().length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                filterProducts[
                                    filterProducts.keys.toList()[index]],
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                showMeDialog(context,
                                    filterProducts.keys.toList()[index],
                                    (FilterItem val) {
                                  List<FilterItem> filterTypes = [];
                                  filterTypes.addAll(
                                      widget.screenBloc.state.filterTypes);
                                  if (val != null) {
                                    if (filterTypes.length > 0) {
                                      int isExist = filterTypes.indexWhere(
                                          (element) =>
                                              element.type == val.type);
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
                                      int isExist = filterTypes.indexWhere(
                                          (element) =>
                                              element.type == val.type);
                                      if (isExist != null) {
                                        filterTypes.removeAt(isExist);
                                      }
                                    }
                                  }
                                  widget.screenBloc.add(
                                      UpdateProductFilterTypes(
                                          filterTypes: filterTypes));
                                  Navigator.pop(context);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goDetailProduct() {
    Navigator.push(
      context,
      PageTransition(
        child: ProductDetailScreen(
          businessId: widget.globalStateModel.currentBusiness.id,
          screenBloc: widget.screenBloc,
        ),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  void goDetailCollection() {
    Navigator.push(
      context,
      PageTransition(
        child: CollectionDetailScreen(
          businessId: widget.globalStateModel.currentBusiness.id,
          screenBloc: widget.screenBloc,
        ),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  void showMeDialog(
      BuildContext context, String filterType, Function callback) {
    String filtername = filterProducts[filterType];
    debugPrint('FilterTypeName => $filterType');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Filter by: $filtername',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: ProductFilterRangeContentView(
                type: filterType,
                onSelected: (value) {
                  Navigator.pop(context);
                  callback(value);
                  // widget.onSelected(value);
                }),
          );
        });
  }
}
