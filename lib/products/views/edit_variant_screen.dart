import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/products/variants/variants.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/single_choice_dialog.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';

import 'add_variant_option_screen.dart';

class EditVariantScreen extends StatefulWidget {

  final Variants variants;
  final ProductsScreenBloc productsScreenBloc;

  EditVariantScreen({this.variants, this.productsScreenBloc,});

  @override
  State<StatefulWidget> createState() {
    return _EditVariantScreenState();
  }
}

class _EditVariantScreenState extends State<EditVariantScreen> {
  final formKey = new GlobalKey<FormState>();
  VariantsScreenBloc screenBloc;
  bool isLoading = false;
  Map<String, Color> colorsMap = {
    'Blue': Color(0xff0084ff),
    'Green': Color(0xff81d552),
    'Yellow': Color(0xffeebd40),
    'Pink': Color(0xffde68a5),
    'Brown': Color(0xff594139),
    'Black': Color(0xff000000),
    'White': Color(0xffffffff),
    'Grey': Color(0xff434243),
  };

  @override
  void initState() {
    super.initState();
    screenBloc = new VariantsScreenBloc(productsScreenBloc: widget.productsScreenBloc);
    screenBloc.add(VariantsScreenInitEvent(variants: widget.variants));
  }

  @override
  void dispose() {
    super.dispose();
    screenBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, VariantsScreenState state) async {
        if (state is VariantsScreenStateSuccess) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<VariantsScreenBloc, VariantsScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, VariantsScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
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
        },
      ),
    );
  }

  Widget _appBar(VariantsScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Edit Variant',
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
              showCupertinoDialog(
                context: context,
                builder: (builder) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      height: 250,
                      child: BlurEffectView(
                        color: overlayColor(),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Icon(Icons.info),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('Editing Variants'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('Do you really want to close editing a Variant? Because all data will be lost when unsaved and you will not be able to restore it?'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  height: 24,
                                  elevation: 0,
                                  minWidth: 0,
                                  color: Colors.white10,
                                  child: Text(
                                    Language.getPosStrings('actions.no'),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  height: 24,
                                  elevation: 0,
                                  minWidth: 0,
                                  color: Colors.white10,
                                  child: Text(
                                    Language.getPosStrings('actions.yes'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
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
            child: isLoading ? Center(
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
              bool valid = true;
              state.variants.options.forEach((element) {
                if (element.name == '') {
                  Fluttertoast.showToast(
                    msg: 'Option name is not valid',
                    toastLength: Toast.LENGTH_SHORT,
                    textColor: Colors.red,
                    fontSize: 14,
                  );
                  valid = false;
                  return;
                } else if (element.value == '') {
                  Fluttertoast.showToast(
                    msg: "Option value is required",
                    toastLength: Toast.LENGTH_SHORT,
                    textColor: Colors.red,
                    fontSize: 14,
                  );
                  valid = false;
                  return;
                } else {
                  List list = state.children.where((e) => element.name == e.name).toList();
                  if (list.length > 1) {
                    Fluttertoast.showToast(
                      msg: "Option name is not valid",
                      toastLength: Toast.LENGTH_SHORT,
                      textColor: Colors.red,
                      fontSize: 14,
                    );
                    valid = false;
                    return;
                  }
                }
              });
              if (state.variants.sku == '') {
                Fluttertoast.showToast(
                  msg: "SKU is required",
                  toastLength: Toast.LENGTH_SHORT,
                  textColor: Colors.red,
                  fontSize: 14,
                );
                valid = false;
                return;
              }
              if (valid) {
                screenBloc.add(SaveVariantsEvent());
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _getBody(VariantsScreenState state) {
    if (state.variants == null) {
      return Container();
    }
    String imgUrl = '';
    if (state.variants.images.length > 0) {
      imgUrl = widget.variants.images.first;
    }
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: BlurEffectView(
                child: Container(
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
                      state.variants.images.length > 0 ? Container(
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
                            if (state.variants.images.length != index) {
                              img = state.variants.images[index];
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
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ): Icon(Icons.add),
                                    ),
                                  ),
                                  img != '' ? InkWell(
                                    onTap: () {
                                      Variants variants = state.variants;
                                      variants.images.remove(img);
                                      screenBloc.add(UpdateVariantDetail(
                                        inventoryModel: state.inventory,
                                        variants: variants,
                                        increaseStock: state.increaseStock,
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
                          itemCount: state.variants.images.length + 1,
                        ),
                      ): Container(),
                      ListView.separated(
                        itemCount: widget.variants.options.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildOptionItems(context, index, state);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 0,
                            color: Color(0x80888888),
                            thickness: 0.5,
                          );
                        },
                      ),
                      Divider(
                        height: 0,
                        thickness: 0.5,
                        color: Color(0x80888888),
                      ),
                      Container(
                        height: 44,
                        padding: EdgeInsets.only(bottom: 8, right: 8),
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          child: Text(
                            Language.getProductStrings('+ Add option'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              PageTransition(
                                child: AddVariantOptionScreen(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                              ),
                            );

                            if (result != null) {
                              if (result == 'color') {
                                VariantOption option = VariantOption(name: 'Color', value: '');
                                Variants variants = state.variants;
                                variants.options.add(option);
                                screenBloc.add(UpdateVariantDetail(variants: variants, inventoryModel: state.inventory, increaseStock: state.increaseStock,));
                              } else if (result == 'other') {
                                VariantOption option = VariantOption(name: 'Default', value: '');
                                Variants variants = state.variants;
                                variants.options.add(option);
                                screenBloc.add(UpdateVariantDetail(variants: variants, inventoryModel: state.inventory, increaseStock: state.increaseStock,));
                              }
                            }
                          },
                        ),
                      ),
                      Container(
                        height: 56,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: overlayBackground(),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                        ),
                        child: TextFormField(
                          onChanged: (val) {
                            Variants variants = state.variants;
                            variants.price = int.parse(val) ?? 0;
                            screenBloc.add(UpdateVariantDetail(
                              inventoryModel: state.inventory,
                              variants: variants,
                              increaseStock: state.increaseStock,
                            ));
                          },
                          initialValue: '${state.variants.price ?? 0}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                              fillColor: Color(0x80111111),
                              labelText: Language.getProductStrings('Variants price'),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: overlayBackground(),
                              ),
                              child: TextFormField(
                                onChanged: (val) {
                                  Variants variants = state.variants;
                                  variants.salePrice = int.parse(val) ?? 0;
                                  screenBloc.add(UpdateVariantDetail(
                                    inventoryModel: state.inventory,
                                    variants: variants,
                                    increaseStock: state.increaseStock,
                                  ));
                                },
                                initialValue: '${state.variants.salePrice ?? 0}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                    fillColor: Color(0x80111111),
                                    labelText: Language.getProductStrings('Variants sale price'),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w200,
                                    ),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: overlayBackground(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Sale',
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      onChanged: (val) {
                                        Variants variants = state.variants;
                                        variants.onSales = val;
                                        screenBloc.add(UpdateVariantDetail(
                                          inventoryModel: state.inventory,
                                          variants: variants,
                                          increaseStock: state.increaseStock,
                                        ));
                                      },
                                      value: state.variants.onSales ?? false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: overlayBackground(),
                              ),
                              child: TextFormField(
                                onChanged: (val) {
                                  Variants variants = state.variants;
                                  variants.sku = val;
                                  screenBloc.add(UpdateVariantDetail(
                                    inventoryModel: state.inventory,
                                    variants: variants,
                                    increaseStock: state.increaseStock,
                                  ));
                                },
                                initialValue: state.variants.sku ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                    fillColor: Color(0x80111111),
                                    labelText: Language.getProductStrings('SKU'),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w200,
                                    ),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: overlayBackground(),
                              ),
                              child: TextFormField(
                                onChanged: (val) {
                                  Variants variants = state.variants;
                                  variants.barcode = val;
                                  screenBloc.add(UpdateVariantDetail(
                                    inventoryModel: state.inventory,
                                    variants: variants,
                                    increaseStock: state.increaseStock,
                                  ));
                                },
                                initialValue: state.variants.barcode ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                    fillColor: Color(0x80111111),
                                    labelText: Language.getProductStrings('Barcode'),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w200,
                                    ),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: overlayBackground(),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      'Should payever track inventory',
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      onChanged: (val) {
                                        InventoryModel inventory = state.inventory ?? InventoryModel();
                                        inventory.isTrackable = !inventory.isTrackable;
                                        screenBloc.add(UpdateVariantDetail(
                                            increaseStock: state.increaseStock,
                                            variants: state.variants,
                                            inventoryModel: inventory));
                                      },
                                      value: state.inventory != null ? state.inventory.isTrackable: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 56,
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: overlayBackground(),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      Language.getProductStrings('info.placeholders.inventory'),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 8, right: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          InkWell(
                                            child: Icon(Icons.remove_circle_outline,),
                                            onTap: () {
                                              num increase = state.increaseStock;
                                              if (state.inventory.stock + increase > 0) {
                                                screenBloc.add(UpdateVariantDetail(increaseStock: increase - 1, variants: state.variants, inventoryModel: state.inventory));
                                              }
                                            },
                                          ),
                                          Flexible(
                                            child: AutoSizeText(
                                              '${state.inventory != null ? state.inventory.stock + state.increaseStock: state.increaseStock}',
                                              minFontSize: 10,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            child: Icon(Icons.add_circle_outline,),
                                            onTap: () {
                                              num increase = state.increaseStock;
                                              screenBloc.add(UpdateVariantDetail(increaseStock: increase + 1, variants: state.variants, inventoryModel: state.inventory));
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
                        ],
                      ),
                      Container(
                        height: 150,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: overlayBackground(),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                        ),
                        alignment: Alignment.topLeft,
                        child: TextFormField(
                          onChanged: (val) {
                            Variants variants = state.variants;
                            variants.description = val;
                            screenBloc.add(UpdateVariantDetail(
                              inventoryModel: state.inventory,
                              variants: variants,
                              increaseStock: state.increaseStock,
                            ));
                          },
                          minLines: 1,
                          maxLines: 10,
                          initialValue: state.variants.description ?? '',
                          textInputAction: TextInputAction.newline,
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                              labelText: Language.getProductStrings('Variant description'),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItems(BuildContext context, int index, VariantsScreenState state) {
    VariantOption option = state.variants.options[index];
    TextEditingController valueEdit = TextEditingController(text: option.value);
    return Container(
      margin: EdgeInsets.only(left: 8, top: 4, bottom: 4),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: overlayBackground(),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), topLeft: Radius.circular(8)),
              ),
              child: TextFormField(
                onChanged: (val) {
                  Variants variants = state.variants;
                  option.name = val;
                  variants.options[index] = option;
                  screenBloc.add(UpdateVariantDetail(
                    inventoryModel: state.inventory,
                    variants: variants,
                    increaseStock: state.increaseStock,
                  ));
                },
                initialValue: option.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                    fillColor: Color(0x80111111),
                    labelText: Language.getProductStrings('Option name'),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: overlayBackground(),
                borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
              ),
              child: TextFormField(
                controller: valueEdit,
                key: Key('option$index'),
                onTap: option.name == 'Color' ?  () async {
                  List result = await showDialog<List>(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChoiceConfirmationDialog(
                        title: 'Color options',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        initialSelectedValues: option.value,
                        colorMaps: colorsMap,
                        addButtonLabel: 'Add Color',
                      );
                    },
                  );

                  if (result != null) {
                    setState(() {
                      Variants variants = state.variants;
                      VariantOption option = variants.options[index];
                      colorsMap = result[1];
                      String value = result[0];
                      option.value = value;
                      variants.options[index] = option;
                      screenBloc.add(UpdateVariantDetail(increaseStock: state.increaseStock, variants: variants, inventoryModel: state.inventory));
                    });
                  }
                }: null,
                readOnly: option.name == 'Color' ? true: false,
                onChanged: (val) {
                  Variants variants = state.variants;
                  option.value = val;
                  variants.options[index] = option;
                  screenBloc.add(UpdateVariantDetail(
                    inventoryModel: state.inventory,
                    variants: variants,
                    increaseStock: state.increaseStock,
                  ));
                },
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                    fillColor: Color(0x80111111),
                    labelText: Language.getProductStrings('Option value'),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Variants variants = state.variants;
              if (variants.options.length > 1) {
                variants.options.removeAt(index);
                screenBloc.add(UpdateVariantDetail(
                  inventoryModel: state.inventory,
                  variants: variants,
                  increaseStock: state.increaseStock,
                ));
              }
            },
            minWidth: 0,
            child: SvgPicture.asset(
              'assets/images/xsinacircle.svg',
            ),
          ),
        ],
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
      screenBloc.add(UploadVariantImageToProduct(file: croppedFile));
    }

  }

}