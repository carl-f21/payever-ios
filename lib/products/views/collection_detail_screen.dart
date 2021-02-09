import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/collection_detail_image_view.dart';
import 'package:payever/products/widgets/product_detail_header.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/models/enums.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';

bool _isPortrait;
bool _isTablet;

// ignore: must_be_immutable
class CollectionDetailScreen extends StatefulWidget {

  final ProductsScreenBloc screenBloc;
  final String businessId;
  final CollectionModel collection;
  final bool fromDashBoard;
  final bool addProducts;

  CollectionDetailScreen({
    this.screenBloc,
    this.businessId,
    this.collection,
    this.fromDashBoard = false,
    this.addProducts = false,
  });

  @override
  createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  String imageBase = Env.storage + '/images/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  String wallpaper;
  bool isError = false;
  bool isButtonPressed = false;
  bool buttonEnabled = false;

  int _selectedSectionIndex = 0;

  TextEditingController _collectionTitleController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();

  NumberFormat numberFormat = NumberFormat();

  String conditionOption = productConditionOptions.first;

  @override
  void initState() {
    widget.screenBloc.add(GetCollectionDetail(collection: widget.collection));
    if (widget.collection != null) {
      _collectionTitleController.text = widget.collection.name;
      _descriptionTextController.text = widget.collection.description;

      if (widget.collection.automaticFillConditions.filters.length > 0) {
        conditionOption = 'Any Condition';
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.fromDashBoard) {
      widget.screenBloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery
        .of(context)
        .orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery
        .of(context)
        .size
        .height
        : MediaQuery
        .of(context)
        .size
        .width);
    Measurements.width = (_isPortrait
        ? MediaQuery
        .of(context)
        .size
        .width
        : MediaQuery
        .of(context)
        .size
        .height);
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
          if (widget.fromDashBoard) {
            Navigator.pop(context, 'refresh');
          } else {
            Navigator.pop(context);
          }
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
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            widget.collection != null ? Language.getProductStrings(
                'Edit Collection') : Language.getProductStrings(
                'Add Collection'),
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
            color: Colors.black,
            child: Text(
              Language.getProductStrings('cancel'),
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
            child: Text(
              Language.getProductStrings('save'),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (state.collectionDetail.id == '') {
                widget.screenBloc.add(CreateCollectionEvent(
                  collectionModel: state.collectionDetail,));
              } else {
                widget.screenBloc.add(SaveCollectionDetail(
                    collectionModel: state.collectionDetail,
                    deleteList: state.deleteList));
              }
              Future.delayed(Duration(milliseconds: 1000)).then((value) =>
                  Navigator.pop(context));
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
              color: overlayColor(),
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
            _getMainDetail(state,),
            ProductDetailHeaderView(
              title: Language.getProductStrings('description.title')
                  .toUpperCase(),
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
            _getDescriptionDetail(state,),
            state.collectionDetail.id != '' ? ProductDetailHeaderView(
              title: Language.getProductListStrings('products').toUpperCase(),
              detail: '',
              isExpanded: _selectedSectionIndex == 2,
              onTap: () {
                setState(() {
                  _selectedSectionIndex = _selectedSectionIndex == 2 ? -1 : 2;
                });
              },
            ) : Container(),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Color(0x80888888),
            ),
            state.collectionDetail.id != ''
                ? _getProductsList(state,)
                : Container(),
          ],
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Collection Detail - Main
  ///---------------------------------------------------------------------------

  Widget _getMainDetail(ProductsScreenState state) {
    if (_selectedSectionIndex != 0) return Container();
    if (state.collectionDetail == null) {
      return Container();
    }
    String imgUrl = state.collectionDetail.image ?? '';
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        children: <Widget>[
          Container(
            height: Measurements.width,
            child: GestureDetector(
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
            child: CollectionDetailImageView(
              imgUrl,
              products: state.collectionProducts,
              isUploading: state.isUploading,
            ),
          ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          Container(
            height: 64,
            color: overlayRow(),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TextFormField(
              initialValue: widget.collection != null ? widget
                  .collection.name : '',
              onChanged: (String text) {
                CollectionModel model = state.collectionDetail;
                model.name = text;
                model.slug = text;
                widget.screenBloc.add(
                    UpdateCollectionDetail(collectionModel: model));
              },
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: Language.getProductStrings(
                    'mainSection.form.title.label'),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w200,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Color(0x80888888),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Container(
              color: Color(0x20111111),
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: DropDownFormField(
                filled: false,
                titleText: Language.getProductStrings('Product must match'),
                hintText: Language.getProductStrings('Product must match'),
                value: conditionOption,
                onChanged: (value) {
                  setState(() {
                    conditionOption = value;
                    if (conditionOption != 'No Conditions') {
                      CollectionModel collection = state.collectionDetail;
                      FillCondition fillCondition = collection
                          .automaticFillConditions;
                      fillCondition.strict =
                          conditionOption == 'All Conditions';
                      collection.automaticFillConditions = fillCondition;
                      widget.screenBloc.add(
                          UpdateCollectionDetail(collectionModel: collection));
                    }
                  });
                },
                dataSource: productConditionOptions.map((e) {
                  return {
                    'display': e,
                    'value': e,
                  };
                }).toList(),
                textField: 'display',
                valueField: 'value',
              ),
            ),
          ),
          conditionOption == 'No Conditions' ? Container()
              : ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 16, right: 16),
            itemBuilder: (context, index) {
              Filter filter = state.collectionDetail.automaticFillConditions
                  .filters[index];
              print('${filter.value} ${filter.field} ${filter.fieldCondition}');
              Map<String,
                  String> filterConditions = filterConditionsByFilterType(
                  filter.field);
              print(filterConditions);
              return Container(
                color: Color(0x20111111),
                padding: EdgeInsets.only(left: 16, right: 16),
                height: 64,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                          ),
                          Text(
                            'Title',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              icon: Container(),
                              underline: Container(),
                              isExpanded: true,
                              value: filter.field,
                              onChanged: (value) {
                                CollectionModel collection = state
                                    .collectionDetail;
                                FillCondition fillCondition = collection
                                    .automaticFillConditions;
                                Filter f = filter;
                                f.field = value;
                                Map<String,
                                    String> conditions = filterConditionsByFilterType(
                                    filter.field);
                                print(conditions);
                                f.fieldCondition = conditions.keys.first;
                                fillCondition.filters[index] = f;
                                collection.automaticFillConditions =
                                    fillCondition;
                                widget.screenBloc.add(UpdateCollectionDetail(
                                    collectionModel: collection));
                              },
                              items: conditionFields.keys.map((label) =>
                                  DropdownMenuItem(
                                    child: Text(
                                      conditionFields[label],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    value: label,
                                  ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                          ),
                          Text(
                            'Condition',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              icon: Container(),
                              underline: Container(),
                              isExpanded: true,
                              value: filter.fieldCondition,
                              onChanged: (value) {
                                CollectionModel collection = state
                                    .collectionDetail;
                                FillCondition fillCondition = collection
                                    .automaticFillConditions;
                                Filter f = filter;
                                f.fieldCondition = value;
                                fillCondition.filters[index] = f;
                                collection.automaticFillConditions =
                                    fillCondition;
                                widget.screenBloc.add(UpdateCollectionDetail(
                                    collectionModel: collection));
                              },
                              items: filterConditions.keys.map((String value) =>
                                  DropdownMenuItem(
                                    child: Text(
                                      filterConditions[value],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    value: value,
                                  ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              height: 64,
                              child: TextFormField(
                                onChanged: (String text) {
                                  CollectionModel collection = state
                                      .collectionDetail;
                                  FillCondition fillCondition = collection
                                      .automaticFillConditions;
                                  filter.value = text;
                                  fillCondition.filters[index] = filter;
                                  collection.automaticFillConditions =
                                      fillCondition;
                                  widget.screenBloc.add(UpdateCollectionDetail(
                                      collectionModel: collection));
                                },
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                    labelText: Language.getProductStrings(
                                        'Value'),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w200,
                                    ),
                                    border: UnderlineInputBorder(),
                                    contentPadding: EdgeInsets.all(8)
                                ),
                                initialValue: filter.value,
                                maxLines: 1,
                                minLines: 1,
                                expands: false,
                              ),
                            ),),
                          MaterialButton(
                            onPressed: () {
                              CollectionModel collection = state
                                  .collectionDetail;
                              FillCondition fillCondition = collection
                                  .automaticFillConditions;
                              fillCondition.filters.remove(filter);
                              collection.automaticFillConditions =
                                  fillCondition;
                              widget.screenBloc.add(UpdateCollectionDetail(
                                  collectionModel: collection));
                            },
                            height: 24,
                            elevation: 0,
                            minWidth: 0,
                            shape: CircleBorder(),
                            visualDensity: VisualDensity.comfortable,
                            child: SvgPicture.asset(
                              'assets/images/xsinacircle.svg', width: 24,
                              height: 24,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0,
                thickness: 0.5,
                color: Color(0x80888888),
              );
            },
            itemCount: state.collectionDetail != null ? state.collectionDetail
                .automaticFillConditions.filters.length : 0,
            physics: NeverScrollableScrollPhysics(),
          ),
          conditionOption == 'No Conditions' ? Container() : Container(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              onPressed: () {
                CollectionModel collection = state.collectionDetail;
                FillCondition fillCondition = collection
                    .automaticFillConditions;
                fillCondition.strict = conditionOption == 'All Conditions';
                Filter filter = Filter(field: 'title',
                  fieldCondition: 'is',
                  fieldType: 'string',
                  value: '',);
                fillCondition.filters.add(filter);
                collection.automaticFillConditions = fillCondition;
                widget.screenBloc.add(
                    UpdateCollectionDetail(collectionModel: collection));
              },
              child: Text(
                Language.getProductListStrings('+ Add Condition'),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///                   Collection Detail - Description
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
              initialValue: state.collectionDetail != null ? state
                  .collectionDetail.description : '',
              onChanged: (String text) {
                CollectionModel model = state.collectionDetail;
                model.description = text;
                widget.screenBloc.add(
                    UpdateCollectionDetail(collectionModel: model));
              },
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 10,
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
  ///                   Collection Detail - Products
  ///---------------------------------------------------------------------------

  Widget _getProductsList(ProductsScreenState state) {
    if (_selectedSectionIndex != 2) return Container();
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        ProductsModel product = state.collectionProducts[index];
        String imgUrl = '';
        if (product.images.length > 0 ) {
          imgUrl = product.images.first;
        }
        return Container(
          height: 60,
          padding: EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Row(
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
                    placeholder: (context, url) => Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
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
                      child: SvgPicture.asset('assets/images/no_image.svg', width: 20, height: 20,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                  ),
                  Flexible(
                    child: Text(
                      product.title,
                    ),
                  ),
                ],
              ),
              ),
              Row(
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: '${product.price} ${numberFormat.simpleCurrencySymbol(product.currency)} ',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      List<ProductsModel> products = state.collectionProducts;
                      List<ProductsModel> deletes = [];
                      deletes.addAll(state.deleteList);
                      products.remove(product);
                      deletes.add(product);
                      widget.screenBloc.add(UpdateCollectionDetail(collectionModel: state.collectionDetail, collectionProducts: products, deleteList: deletes));
                    },
                    height: 30,
                    elevation: 0,
                    minWidth: 0,
                    shape: CircleBorder(),
                    visualDensity: VisualDensity.comfortable,
                    child: SvgPicture.asset('assets/images/xsinacircle.svg', width: 30, height: 30,),
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
      itemCount: state.collectionProducts.length,
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
      widget.screenBloc.add(UploadImageToCollection(file: croppedFile));
    }

  }

}
