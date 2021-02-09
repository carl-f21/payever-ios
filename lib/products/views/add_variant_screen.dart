import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/products/widgets/multi_select_formfield.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';

import 'add_variant_option_screen.dart';

class AddVariantScreen extends StatefulWidget {

  final ProductsScreenBloc productsScreenBloc;

  AddVariantScreen({this.productsScreenBloc});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddVariantScreenState();
  }
}

class _AddVariantScreenState extends State<AddVariantScreen> {

  VariantsScreenBloc screenBloc;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  bool isShownColorPicker = false;

  @override
  void initState() {
    super.initState();
    screenBloc = new VariantsScreenBloc(productsScreenBloc: widget.productsScreenBloc);
    screenBloc.add(VariantsScreenInitEvent());
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
            key: scaffoldKey,
            backgroundColor: Colors.black,
            appBar: _appBar(state),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: Form(
                  key: formKey,
                  autovalidate: false,
                  child: Container(
                    child: _getBody(state),
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
            '+ Add Variant',
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
                                  color: overlayBackground(),
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
                                  color: overlayBackground(),
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
              bool valid = true;
              state.children.forEach((element) {
                if (element.name == '') {
                  Fluttertoast.showToast(
                    msg: 'Option name is not valid',
                    toastLength: Toast.LENGTH_SHORT,
                    textColor: Colors.red,
                    fontSize: 14,
                  );
                  valid = false;
                  return;
                } else if (element.values.length == 0) {
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
              if (valid) {
                screenBloc.add(CreateVariantsEvent());
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: BlurEffectView(
              padding: EdgeInsets.only(top: 12),
              radius: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListView.separated(
                    padding: EdgeInsets.all(4),
                    itemCount: state.children.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildOptionItems(context, index, state);
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                        thickness: 0.5,
                        color: Colors.transparent,
                      );
                    },
                  ),
                  Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Color(0x80888888),
                  ),
                  Container(
                    height: 64,
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
                            List<TagVariantItem> children = [];
                            children.addAll(state.children);
                            children.add(TagVariantItem(name: 'Color', type: 'color', values: [], key: '${children.length}'));
                            screenBloc.add(UpdateTagVariantItems(items: children));
                          } else if (result == 'other') {
                            List<TagVariantItem> children = [];
                            children.addAll(state.children);
                            children.add(TagVariantItem(name: 'Default', type: 'string', values: [], key: '${children.length}'));
                            screenBloc.add(UpdateTagVariantItems(items: children));
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItems(BuildContext context, int index, VariantsScreenState state) {
    return IntrinsicHeight(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 8, top: 4, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                margin: EdgeInsets.all(1),
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  color: overlayBackground(),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), topLeft: Radius.circular(8),),
                ),
                alignment: Alignment.center,
                child: TextFormField(
                  onTap: () {
                    if (isShownColorPicker)
                      Navigator.pop(context);
                    setState(() {
                      isShownColorPicker = false;
                    });
                  },
                  onChanged: (val) {
                    List<TagVariantItem> children = [];
                    children.addAll(state.children);
                    children[index].name = val;
                    screenBloc.add(UpdateTagVariantItems(items: children));
                  },
                  initialValue: state.children[index].name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
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
                padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: overlayBackground(),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                child: state.children[index].type == 'string'
                    ? Tags(
                  itemCount: state.children[index].values.length,
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  runSpacing: 8,
                  itemBuilder: (int i) {
                    return ItemTags(
                      key: Key('filterItem$i'),
                      index: i,
                      title: state.children[index].values[i],
                      color: Colors.white12,
                      activeColor: Colors.white12,
                      textActiveColor: Colors.white,
                      textColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.only(
                        left: 8, top: 4, bottom: 4, right: 8,
                      ),
                      removeButton: ItemTagsRemoveButton(
                          backgroundColor: Colors.transparent,
                          onRemoved: () {
                            return true;
                          }
                      ),
                    );
                  },
                  textField: TagsTextField(
                    hintText: '',
                    autofocus: false,
                    onChanged: (val) {
                      if (isShownColorPicker)
                        Navigator.pop(context);
                      setState(() {
                        isShownColorPicker = false;
                      });
                    },
                    textStyle: TextStyle(
                      fontSize: 14,
                      //height: 1
                    ),
                    enabled: true,
                    inputDecoration: InputDecoration(
                      hintText: '',
                      labelText: 'Option value',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    constraintSuggestion: false,
                    suggestions: null,
                    onSubmitted: (String str) {
                      setState(() {
                        List<TagVariantItem> children = [];
                        children.addAll(state.children);
                        List<String> values = children[index].values;
                        values.add(str);
                        children[index].values = values;
                        screenBloc.add(UpdateTagVariantItems(items: children));
                      });
                    },
                  ),
                ): Container(
                  child: MultiSelectFormField(
                    autovalidate: false,
                    titleText: 'Color options',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    hintText: 'Please choose one or more',
                    initialValue: [state.children[index].values, state.colorsMap],
                    validator: (val) {
                      if (val[0].length == 0) {
                        return 'Option value is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value == null) return;
                      List<TagVariantItem> children = [];
                      children.addAll(state.children);
                      print(value);
                      List<String> values = value[0];
                      children[index].values = values;
                      screenBloc.add(UpdateTagVariantItems(items: children));
                    },
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    if (state.children.length > 1) {
                      List<TagVariantItem> children = [];
                      children.addAll(state.children);
                      children.removeAt(index);
                      screenBloc.add(UpdateTagVariantItems(items: children));
                    }
                  });
                },
                minWidth: 0,
                child: SvgPicture.asset(
                  'assets/images/xsinacircle.svg',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TagVariantItem {
  TagVariantItem({
    this.name,
    this.type,
    this.values = const [],
    this.key,
  });
  String key;
  String name;
  String type;
  List<String> values;
}

class VariantColorOption {
  String title;
  Color color;
  bool checked;
  
  VariantColorOption({
    this.title,
    this.color,
    this.checked,
  });
}