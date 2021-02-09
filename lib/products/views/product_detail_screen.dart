import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/libraries/flutter_tagging.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/views/add_variant_screen.dart';
import 'package:payever/products/views/edit_variant_screen.dart';
import 'package:payever/products/widgets/product_detail_header.dart';
import 'package:payever/products/widgets/product_detail_subsection_header.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';

bool _isPortrait;
bool _isTablet;

List<String> productTypes = [
  'Service',
  'Digital',
  'Physical',
];
final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {

  final ProductsScreenBloc screenBloc;
  final String businessId;
  final ProductsModel productsModel;
  final bool fromDashBoard;

  ProductDetailScreen({
    this.screenBloc,
    this.businessId,
    this.productsModel,
    this.fromDashBoard = false,
  });

  @override
  createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String imageBase = Env.storage + '/images/';
  TextEditingController categoryController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  String wallpaper;
  final TextEditingController shopNameController = TextEditingController();
  bool isError = false;
  bool isButtonPressed = false;
  bool buttonEnabled = false;

  int _selectedSectionIndex = 0;
  bool posExpanded = true;
  bool shopExpanded = true;

  NumberFormat numberFormat = NumberFormat();

  @override
  void initState() {
    widget.screenBloc.add(
        GetProductDetails(
          productsModel: widget.productsModel,
          businessId: widget.businessId,
        )
    );
    if (widget.productsModel != null) {
    }
    categoryController = TextEditingController(text:'');
    super.initState();
  }

  @override
  void dispose() {
    if (widget.fromDashBoard) {
      widget.screenBloc.close();
    }
//      categoryController.dispose();
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
      listener: (BuildContext context, ProductsScreenState state) async {
        if (state is ProductsScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is ProductsScreenStateSuccess) {

        } else if (state is ProductsNotExist) {
          Fluttertoast.showToast(msg: state.error);
          Navigator.pop(context);
        } else if (state is CategoriesCreate) {

        }
      },
      child: BlocBuilder<ProductsScreenBloc, ProductsScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, ProductsScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(ProductsScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Text(
            widget.productsModel != null ? Language.getProductStrings('edit_product'): Language.getProductStrings('add_product'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            height: 32,
            elevation: 0,
            minWidth: 0,
            child: Text(
              Language.getProductStrings('cancel'),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              widget.screenBloc.add(CancelProductEdit());
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
        ),
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 0,
            minWidth: 0,
            color: Colors.white24,
            child: state.isLoading ? Center(
              child: Container(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ) : Text(
              Language.getProductStrings('save'),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (state.isLoading) {
                return;
              }
              if (state.productDetail != null) {
                if (state.productDetail.sku == '') {
                  setState(() {
                    formKey.currentState.validate();
                    _selectedSectionIndex = 2;
                  });
                  return;
                }
                if (state.productDetail.id == '') {
                  widget.screenBloc.add(CreateProductEvent(productsModel: state.productDetail));
                } else {
                  widget.screenBloc.add(SaveProductDetail(productsModel: state.productDetail));
                }
              }
              Future.delayed(Duration(milliseconds: 1000)).then((value) => Navigator.pop(context));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _body(ProductsScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: Form(
            key: formKey,
            autovalidate: false,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                width: Measurements.width,
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
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Sections Body
  ///---------------------------------------------------------------------------

  Widget _getBody(ProductsScreenState state) {
    if (state.productDetail == null) {
      return Container();
    }
    List<Tax> taxes = state.taxes;
    num vatRate = state.productDetail != null ? (state.productDetail.vatRate ?? 0): 0;
    Tax tax;
    if (state.taxes.length > 0) {
      List<Tax> vats = taxes.where((element) => vatRate == element.rate).toList();
      if (vats.length > 0) {
        tax = vats.first;
      }
    }
    String categoryHeaderDetail = '';
//    state.productDetail.categories != null ? (state.productDetail.categories.length > 0 ? '${state.productDetail.categories.map((e) => e.title).toList().join(', ')}': ''): ''
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.main').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 0,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 0 ? -1 : 0;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getMainDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('description.title').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 1,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 1 ? -1 : 1;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getDescriptionDetail(state),
            state.productDetail.variants.length == 0 ? ProductDetailHeaderView(
              title: Language.getProductStrings('sections.inventory').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 2,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 2 ? -1 : 2;
                });
              },
            ): Container(),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            state.productDetail.variants.length == 0 ? _getInventoryDetail(state): Container(),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.category').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 3,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 3 ? -1 : 3;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getCategoryDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.variants').toUpperCase(),
              detail: state.productDetail.variants != null ? '${state.productDetail.variants.length} ${Language.getProductStrings('sections.variants').toLowerCase()}': '',
              isExpanded: _selectedSectionIndex == 4,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 4 ? -1 : 4;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getVariantsDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.channels').toUpperCase(),
              detail: 'channel',
              isExpanded: _selectedSectionIndex == 5,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 5 ? -1 : 5;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getChannelDetail(state),
            state.productDetail.type == 'physical' ? ProductDetailHeaderView(
              title: Language.getProductStrings('sections.shipping').toUpperCase(),
              detail: state.productDetail.shipping != null
                  ? '${state.productDetail.shipping.weight} ${Language.getProductStrings('shippingSection.measure.kg')} (${state.productDetail.shipping.width} * ${state.productDetail.shipping.length} * ${state.productDetail.shipping.height})'
                  : '',
              isExpanded: _selectedSectionIndex == 6,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 6 ? -1 : 6;
                });
              },
            ): Container(),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            state.productDetail.type == 'physical' ? _getShippingDetail(state): Container(),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.taxes').toUpperCase(),
              detail: tax != null
                  ? '${tax.description} ${tax.rate}%'
                  : '',
              isExpanded: _selectedSectionIndex == 7,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 7 ? -1 : 7;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getTaxesDetail(state),
            ProductDetailHeaderView(
              title: Language.getProductStrings('sections.visibility').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 8,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 8 ? -1 : 8;
                });
              },
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            _getVisibilityDetail(state),
          ],
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Main
  ///---------------------------------------------------------------------------

  Widget _getMainDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 0) return Container();
    String imgUrl = '';
    if (state.productDetail == null) {
      return Container();
    }
    imgUrl = state.productDetail.images != null ? (state.productDetail.images.length > 0 ? state.productDetail.images.first: ''): '';
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        children: <Widget>[
          imgUrl != '' ? Container(
            height: Measurements.width * 0.7,
            child: CachedNetworkImage(
              imageUrl: '${Env.storage}/products/$imgUrl',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              placeholder: (context, url) => Center(
                child: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) =>  Container(
                height: Measurements.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset('assets/images/insertimageicon.svg'),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Text(
                      'Upload images',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ): GestureDetector(
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                  title: const Text('Choose Photo'),
                  message: const Text('Your options are '),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: const Text('Take a Picture'),
                      onPressed: () {
                        Navigator.pop(context, 'Take a Picture');
                        getImage(0);
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: const Text('Camera Roll'),
                      onPressed: () {
                        Navigator.pop(context, 'Camera Roll');
                        getImage(1);
                      },
                    )
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: const Text('Cancel'),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                  ),
                ),
              );
            },
            child: Container(
              height: Measurements.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              alignment: Alignment.center,
              child: state.isUploading ? Container(
                child: Center(child: CircularProgressIndicator()),
              ): Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset('assets/images/insertimageicon.svg', color: iconColor(),),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  Text(
                    'Upload images',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          state.productDetail.images.length > 0 ? Container(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
                bottom: 8,
              ),
              itemBuilder: (context, index) {
                String img = '';
                if (state.productDetail.images.length != index) {
                  img = state.productDetail.images[index];
                }
                return Container(
                  width: 64,
                  height: 64,
                  margin: EdgeInsets.only(left: 4, right: 4),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      img != '' ? CachedNetworkImage(
                        imageUrl: '${Env.storage}/products/$img',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Center(
                          child: Container(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>  Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black12,
                          ),
                          child: Icon(Icons.terrain),
                        ),
                      ): GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => CupertinoActionSheet(
                              title: const Text('Choose Photo'),
                              message: const Text('Your options are '),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('Take a Picture'),
                                  onPressed: () {
                                    Navigator.pop(context, 'Take a Picture');
                                    getImage(0);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('Camera Roll'),
                                  onPressed: () {
                                    Navigator.pop(context, 'Camera Roll');
                                    getImage(1);
                                  },
                                )
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Cancel'),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black12,
                          ),
                          child: state.isUploading ? Container(
                            child: Center(child: CircularProgressIndicator()),
                          ): Icon(Icons.add),
                        ),
                      ),
                      img != '' ? InkWell(
                        onTap: () {
                          ProductsModel productModel = state.productDetail;
                          productModel.images.remove(img);
                          widget.screenBloc.add(UpdateProductDetail(
                            inventoryModel: state.inventory,
                            productsModel: productModel,
                          ));
                        },
                        child: SvgPicture.asset('assets/images/xsinacircle.svg',),
                      ): Container(),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container();
              },
              itemCount: state.productDetail.images.length + 1,
            ),
          ): Container(),
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.title ?? '',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      product.title = text;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, inventoryModel: state.inventory));
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('name.title'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      Language.getProductStrings('info.placeholders.inventory'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        onChanged: (val) {
//                        ProductsModel productModel = state.productDetail;
//                        productModel.enabled = val;
//                        widget.screenBloc.add(
//                            UpdateProductDetail(
//                              productsModel: productModel,
//                              increaseStock: state.increaseStock,
//                            )
//                        );
                        },
                        value: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          initialValue: state.productDetail.price != null ? '${state.productDetail.price}': '0',
                          onChanged: (String text) {
                            ProductsModel product = state.productDetail;
                            product.price = num.parse(text);
                            widget.screenBloc.add(UpdateProductDetail(productsModel: product, inventoryModel: state.inventory));
                          },
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                          decoration: InputDecoration(
                            labelText: Language.getProductStrings('placeholders.price'),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w200,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        color: Color(0x80555555),
                        padding: EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                        child: Text(
                          state.productDetail.currency ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          initialValue: state.productDetail.salePrice != null ? '${state.productDetail.salePrice}': '0',
                          onChanged: (String text) {
                            ProductsModel product = state.productDetail;
                            product.salePrice = num.parse(text);
                            widget.screenBloc.add(UpdateProductDetail(productsModel: product, inventoryModel: state.inventory));
                          },
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                          decoration: InputDecoration(
                            labelText: Language.getProductStrings('placeholders.salePrice'),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w200,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        color: Color(0x80555555),
                        padding: EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                        child: Text(
                          state.productDetail.currency ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 4),
                ),
                Text(
                  'Product Type',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    icon: Container(),
                    underline: Container(),
                    isExpanded: true,
                    value: state.productDetail.type ?? 'physical',
                    onChanged: (value) {
                      ProductsModel productModel = state.productDetail;
                      productModel.type = value;
                      widget.screenBloc.add(
                          UpdateProductDetail(
                            productsModel: productModel,
                            inventoryModel: state.inventory,
                          )
                      );
                    },
                    items: productTypes.map((label) => DropdownMenuItem(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      value: label.toLowerCase(),
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Description
  ///---------------------------------------------------------------------------

  Widget _getDescriptionDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 1) return Container();
    return Container(
      height: 150,
      margin: EdgeInsets.only(top: 16, bottom: 16),
      color: overlayRow(),
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              Language.getProductStrings('description.title'),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: state.productDetail.description ?? '',
              onChanged: (String text) {
                ProductsModel product = state.productDetail;
                product.description = text;
                widget.screenBloc.add(UpdateProductDetail(productsModel: product, inventoryModel: state.inventory));
              },
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 10,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Inventory
  ///---------------------------------------------------------------------------

  Widget _getInventoryDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 2) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.sku ?? '',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      product.sku = text;
                      InventoryModel inventory = state.inventory;
                      inventory.sku = text;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, inventoryModel: inventory));
                    },
                    validator: (text) {
                      if (text.isEmpty){
                        return 'Code/SKU required';
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('price.placeholders.skucode'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Expanded(
                  child: TextFormField(
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      product.barcode = text;
                      InventoryModel inventory = state.inventory;
                      inventory.barcode = text;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, inventoryModel: inventory));
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('price.placeholders.barcode'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          onChanged: (val) {
                            InventoryModel inventory = state.inventory;
                            inventory.isTrackable = val;
                            widget.screenBloc.add(UpdateProductDetail(inventoryModel: inventory));
                          },
                          value: state.inventory.isTrackable,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          Language.getProductStrings('info.placeholders.inventoryTrackingEnabled'),
                          minFontSize: 10,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                    ),
                    Text(
                      Language.getProductStrings('info.placeholders.inventory'),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            ProductsModel product = state.productDetail;
                            InventoryModel inventory = state.inventory;
//                            if (inventory.stock > 0) {
                              inventory.stock -= 1;
                              widget.screenBloc.add(UpdateProductDetail(productsModel: product, inventoryModel: inventory, increaseStock: -1));
//                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                        ),
                        AutoSizeText(
                          '${(state.inventory.stock ?? 0)}',
                          minFontSize: 12,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            ProductsModel product = state.productDetail;
                            InventoryModel inventory = state.inventory;
                            inventory.stock += 1;
                            widget.screenBloc.add(UpdateProductDetail(productsModel: product, inventoryModel: inventory, increaseStock: 1));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Category
  ///---------------------------------------------------------------------------

  Widget _getCategoryDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 3) return Container();

    List<CategoryTag> tags = [];
    tags = state.productDetail.categories.map((element) {
      if (element != null) {
        return CategoryTag(
          name: element.title ?? '',
          position: suggestedCategories(state).length ,
          category: element,
        );
      } else {
        return null;
      }
    }).toList();

    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterTagging<CategoryTag>(
                  initialItems: tags,
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: categoryController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Category',
                    ),
                    onChanged: (value) {
                      setState(() {

                      });
                    }
                  ),
                  findSuggestions: CategorySuggestService(
                    categories: suggestedCategories(state),
                    addedCategories: state.productDetail.categories,
                  ).getCategories,
                  additionCallback: (value) {
                    return CategoryTag(
                      name: value,
                      position: suggestedCategories(state).length,
                    );
                  },
                  onAdded: (newCategory) {
                    widget.screenBloc.add(CreateCategoryEvent(
                      title: newCategory.name,
                    ));
                    categoryController.clear();
                    FocusScope.of(context).unfocus();
                    return newCategory;
                  },
                  configureChip: (lang) {
                    return ChipConfiguration(
                      label: Text(lang.name),
                    );
                  },
                  onChanged: () {
                    print('Tags: $tags');
                    List cates = tags.map((e) {
                      return e.category;
                    }).toList();
                    ProductsModel model = state.productDetail;
                    model.categories = cates;
                    widget.screenBloc.add(UpdateProductDetail(
                      productsModel: model,
                    ));
                  },
                  configureSuggestion: (CategoryTag tag ) {
                    return SuggestionConfiguration(
                      title: Text(tag.name),
                      additionWidget: Container(width: 0,),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Categories>suggestedCategories(ProductsScreenState state) {
    if (categoryController.text.isEmpty)
      return state.categories;
    return state.categories.where((e) => e.title.toLowerCase().contains(categoryController.text.toLowerCase())).toList();
  }
  ///---------------------------------------------------------------------------
  ///                   Product Details - Variants
  ///---------------------------------------------------------------------------

  Widget _getVariantsDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 4) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Variants variant = state.productDetail.variants[index];
              String imgUrl = '';
              if (variant.images.length > 0 ) {
                imgUrl = variant.images.first;
              }
              InventoryModel inventory;
              if (state.inventories.length > 0) {
                List its = state.inventories.where((element) => element.sku == variant.sku).toList();
                if (its.length > 0) {
                  inventory = its.first;
                }
              }
              return Container(
                height: 60,
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        imgUrl != '' ? CachedNetworkImage(
                          imageUrl: '${Env.storage}/products/$imgUrl',
                          imageBuilder: (context, imageProvider) => Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              image: DecorationImage(
                                image: imageProvider,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            child: Center(
                              child: Container(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white10,
                              ),
                              child: Center(
                                child: SvgPicture.asset('assets/images/no_image.svg', width: 20, height: 20,),
                              ),
                            );
                          },
                        ) : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4,),
                            color: Colors.white10,
                          ),
                          child: Center(
                            child: SvgPicture.asset('assets/images/no_image.svg', width: 20, height: 20, color: iconColor(),),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Text(
                          '${inventory != null ? inventory.stock: 0} item${(inventory != null ? inventory.stock: 0) > 1 ? 's': ''}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                            text: '${variant.price} ${numberFormat.simpleCurrencySymbol(state.productDetail.currency)} ',
                            style: TextStyle(color: iconColor(), fontSize: 12),
                          ),
                          variant.salePrice != null ? new TextSpan(
                            text: '${variant.salePrice} ${numberFormat.simpleCurrencySymbol(state.productDetail.currency)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: iconColor(),
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ): TextSpan(text: ''),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              PageTransition(
                                child: EditVariantScreen(
                                  variants: variant,
                                  productsScreenBloc: widget.screenBloc,
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                              ),
                            );

                            print(result);
                          },
                          color: overlayBackground(),
                          height: 30,
                          elevation: 0,
                          minWidth: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            Language.getProductStrings('edit'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          visualDensity: VisualDensity.comfortable,
                        ),
                        MaterialButton(
                          onPressed: () {
                            ProductsModel product = state.productDetail;
                            List<Variants> variants = product.variants;
                            variants.removeAt(index);
                            product.variants = variants;
                            widget.screenBloc.add(UpdateProductDetail(productsModel: product, inventoryModel: state.inventory,));
                          },
                          color: overlayBackground(),
                          height: 30,
                          elevation: 0,
                          minWidth: 0,
                          shape: CircleBorder(),
                          visualDensity: VisualDensity.comfortable,
                          child: Icon(Icons.close,),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0,
                thickness: 0,
                color: Color(0x80888888),
              );
            },
            itemCount: state.productDetail.variants.length,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              child: Text(
                Language.getProductStrings('variantEditor.add_variant'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: AddVariantScreen(
                      productsScreenBloc: widget.screenBloc,
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Channels
  ///---------------------------------------------------------------------------

  Widget _getChannelDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 5) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ProductDetailSubSectionHeaderView(
            onTap: () {
              setState(() {
                posExpanded = !posExpanded;
              });

            },
            isExpanded: posExpanded,
            type: 'pos',
          ),
          posExpanded ? ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Terminal terminal = state.terminals[index];
              List<ChannelSet> channelSets = state.productDetail.channels ?? [];
              List setList = channelSets.where((element) => element.id == terminal.channelSet).toList() ?? [];
              bool isSet = setList.length > 0;
              return Container(
                height: 60,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      terminal.name,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: isSet,
                        onChanged: (val) {
                          ProductsModel productDetail = state.productDetail;
                          List<ChannelSet> channelSets = productDetail.channels;
                          if (val) {
                            channelSets.add(ChannelSet(terminal.channelSet, terminal.name, 'pos'));
                          } else {
                            channelSets.removeWhere((element) => element.id == terminal.channelSet);
                          }
                          productDetail.channels = channelSets;
                          widget.screenBloc.add(
                              UpdateProductDetail(
                                productsModel: productDetail,
                                increaseStock: state.increaseStock,
                                inventoryModel: state.inventory,
                              )
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0,
                thickness: 0,
                color: Color(0x80888888),
              );
            },
            itemCount: state.terminals.length,
          ): Container(),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          ProductDetailSubSectionHeaderView(
            onTap: () {
              setState(() {
                shopExpanded = !shopExpanded;
              });
            },
            isExpanded: shopExpanded,
            type: 'shop',
          ),
          shopExpanded ? ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              ShopModel shop = state.shops[index];
              List<ChannelSet> channelSets = state.productDetail.channels ?? [];
              List setList = channelSets.where((element) => element.id == shop.channelSet).toList() ?? [];
              bool isSet = setList.length > 0;
              return Container(
                height: 60,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      shop.name,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: isSet,
                        onChanged: (val) {
                          ProductsModel productDetail = state.productDetail;
                          List<ChannelSet> channelSets = productDetail.channels;
                          if (val) {
                            channelSets.add(ChannelSet(shop.channelSet, shop.name, 'shop'));
                          } else {
                            channelSets.removeWhere((element) => element.id == shop.channelSet);
                          }
                          productDetail.channels = channelSets;
                          widget.screenBloc.add(
                              UpdateProductDetail(
                                productsModel: productDetail,
                                increaseStock: state.increaseStock,
                              )
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0,
                thickness: 0,
                color: Color(0x80888888),
              );
            },
            itemCount: state.shops.length,
          ): Container(),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Channels
  ///---------------------------------------------------------------------------

  Widget _getShippingDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 6) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.shipping != null ? '${state.productDetail.shipping.weight ?? 0}': '0',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      Shipping shipping = product.shipping ?? Shipping();
                      shipping.weight = num.parse(text);
                      product.shipping = shipping;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('shipping.placeholders.weight'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Container(
                  color: Color(0x80555555),
                  width: 40,
                  alignment: Alignment.centerRight,
                  height: 40,
                  padding: EdgeInsets.only(left: 4, right: 8, top: 8, bottom: 8),
                  child: Text(
                    Language.getProductStrings('shippingSection.measure.kg'),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.shipping != null ? '${state.productDetail.shipping.width ?? 0}': '0',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      Shipping shipping = product.shipping ?? Shipping();
                      shipping.width = num.parse(text);
                      product.shipping = shipping;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('shipping.placeholders.width'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Container(
                  color: Color(0x80555555),
                  width: 40,
                  alignment: Alignment.centerRight,
                  height: 40,
                  padding: EdgeInsets.only(left: 4, right: 8, top: 8, bottom: 8),
                  child: Text(
                    Language.getProductStrings('shippingSection.measure.cm'),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.shipping != null ? '${state.productDetail.shipping.length ?? 0}': '0',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      Shipping shipping = product.shipping ?? Shipping();
                      shipping.length = num.parse(text);
                      product.shipping = shipping;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('shipping.placeholders.length'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Container(
                  color: Color(0x80555555),
                  width: 40,
                  alignment: Alignment.centerRight,
                  height: 40,
                  padding: EdgeInsets.only(left: 4, right: 8, top: 8, bottom: 8),
                  child: Text(
                    Language.getProductStrings('shippingSection.measure.cm'),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: state.productDetail.shipping != null ? '${state.productDetail.shipping.height ?? 0}': '0',
                    onChanged: (String text) {
                      ProductsModel product = state.productDetail;
                      Shipping shipping = product.shipping ?? Shipping();
                      shipping.height = num.parse(text);
                      product.shipping = shipping;
                      widget.screenBloc.add(UpdateProductDetail(productsModel: product, increaseStock: state.increaseStock));
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: Language.getProductStrings('shipping.placeholders.height'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Container(
                  color: Color(0x80555555),
                  width: 40,
                  alignment: Alignment.centerRight,
                  height: 40,
                  padding: EdgeInsets.only(left: 4, right: 8, top: 8, bottom: 8),
                  child: Text(
                    Language.getProductStrings('shippingSection.measure.cm'),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Taxes
  ///---------------------------------------------------------------------------

  Widget _getTaxesDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 7) return Container();
    List<Tax> taxes = state.taxes;
    num vatRate = state.productDetail != null ? (state.productDetail.vatRate ?? 0): 0;
    Tax tax;
    if (state.taxes.length > 0) {
      List<Tax> vats = taxes.where((element) => vatRate == element.rate).toList();
      if (vats.length > 0) {
        tax = vats.first;
      }
    }
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        color: overlayRow(),
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: state.taxes.length == 0
            ? Container()
            : DropDownFormField(
          filled: false,
          titleText: '',
          hintText: Language.getProductStrings('price.headings.tax'),
          value: tax != null ? tax.rate: taxes.first.rate,
          onChanged: (value) {
            ProductsModel productModel = state.productDetail;
            productModel.vatRate = value;
            widget.screenBloc.add(
                UpdateProductDetail(
                  productsModel: productModel,
                  increaseStock: state.increaseStock,
                )
            );
          },
          dataSource: state.taxes.map((e) {
            return {
              'display': '${e.description} ${e.rate}%',
              'value': e.rate,
            };
          }).toList(),
          textField: 'display',
          valueField: 'value',
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Product Details - Visibility
  ///---------------------------------------------------------------------------

  Widget _getVisibilityDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 8) return Container();
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 64,
        color: overlayRow(),
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Language.getProductStrings('Show this product'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                onChanged: (val) {
                  ProductsModel productModel = state.productDetail;
                  productModel.active = val;
                  widget.screenBloc.add(
                      UpdateProductDetail(
                        productsModel: productModel,
                        increaseStock: state.increaseStock,
                      )
                  );
                },
                value: state.productDetail.active ?? false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getImage(int type) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
      source: type == 1 ? ImageSource.gallery : ImageSource.camera,
    );
    if (image != null) {
      await _cropImage(File(image.path));
    }
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      widget.screenBloc.add(UploadImageToProduct(file: croppedFile));
    }

  }
}

/// CategorySuggestService
class CategorySuggestService {
  final List<Categories> categories;
  final List<Categories> addedCategories;
  CategorySuggestService( {this.categories = const [], this.addedCategories = const [],});

  Future<List<CategoryTag>> getCategories(String query) async {
    List list = categories.where((element) {
      bool isadded = false;
      addedCategories.forEach((e) {
        if (e.slug == element.slug) {
          isadded = true;
        }
      });
      return !isadded;
    }).toList();

    List<CategoryTag> categoryTags = [];
    list.forEach((element) {
      categoryTags.add(CategoryTag(
        name: element.title,
        position: categoryTags.length,
        category: element,
      ));
    });
    print(categoryTags.length);
      return categoryTags;
//    return categoryTags
//        .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
//        .toList();
  }
}
/// CategoryTag Class
class CategoryTag extends Taggable {
  ///
  final String name;

  final Categories category;
  ///
  final int position;

  /// Creates Language
  CategoryTag({
    this.name,
    this.category,
    this.position,
  });

  @override
  List<Object> get props => [name];

  /// Converts the class to json string.
  String toJson() => '''  {
    "name": $name,\n
    "position": $position\n
  }''';
}
