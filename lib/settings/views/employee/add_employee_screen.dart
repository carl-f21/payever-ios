
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/libraries/flutter_tagging.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';
import 'package:payever/theme.dart';


class AddEmployeeScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final Employee employee;
  AddEmployeeScreen({
    this.globalStateModel,
    this.setScreenBloc,
    this.employee,
  });

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  Business activeBusiness;

  final _formKey = GlobalKey<FormState>();
  int selectedSection = 0;
  Employee employee;
  String email;
  String firstName;
  String lastName;
  String positionType;
  List<Group> group = [];
  List<BusinessApps> businessApps = [];
  int selectedIndex = -1;
  List<Acl> acls = [];

  @override
  void initState() {
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    if (widget.setScreenBloc.dashboardScreenBloc.state.businessWidgets != null) {
      businessApps = widget.setScreenBloc.dashboardScreenBloc.state.businessWidgets.where((element) {
        if (element.installed) {
          Acl acl = element.allowedAcls;
          acl.setAll(false);
          acl.microService = element.code;
          acls.add(acl);
        }
        return element.installed;
      }).toList();
    }
    print('businessApps => $businessApps');
    if (widget.employee != null) {
      employee = widget.employee;
      email = employee.email;
      firstName = employee.firstName;
      lastName = employee.lastName;
      group = employee.groups;
      positionType = employee.positionType;
      if (employee.roles.length > 0) {
        Role role = employee.roles.first;
        if (role.permissions.length > 0) {
          acls = role.permissions.first.acls;
          print('acls => ${acls.first.toMap()}');
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  get _body {
    return Scaffold(
      appBar: Appbar(
        widget.employee == null ? 'Add Employee' : 'Edit Employee',
        onClose: () {
          showConfirmDialog();
        },
      ),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: _updateForm,
        ),
      ),
    );
  }

  get _updateForm {
    return BlocListener(
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, SettingScreenState state) {
        if (state is SettingScreenUpdateSuccess) {
          if(widget.employee != null) {
            Fluttertoast.showToast(msg: 'Employee successfully updated');
          } else {
            Fluttertoast.showToast(msg: 'Activation link sent to the employee successfully!');
          }
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {}
        if (state.emailInvalid) {
          Fluttertoast.showToast(msg: 'Email address already exist!');
          widget.setScreenBloc.add(ClearEmailInvalidEvent());
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (context, state) {
          List<GroupTag> tags = [];
          if (employee != null) {
            tags = employee.groups.map((element) {
              return GroupTag(
                name: element.name,
                position: state.employeeGroups.length,
                category: element,
              );
            }).toList();
          }

          return Center(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                width: Measurements.width,
                child: BlurEffectView(
                  color: overlayBackground(),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          BlurEffectView(
                            color: overlayBackground(),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: Container(
                              height: 56,
                              color: overlayBackground(),
                              child: SizedBox.expand(
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      if (selectedSection == 0) {
                                        selectedSection = -1;
                                      } else {
                                        selectedSection = 0;
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/account.svg',
                                              color: iconColor(),
                                              width: 16,
                                              height: 16,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Info',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        selectedSection == 0 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          selectedSection == 0
                              ? ( widget.employee != null ?
                          Container(
                            height: 64,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: BlurEffectView(
                                    color: overlayRow(),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                        },
                                        initialValue: firstName ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('First Name'),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Flexible(
                                  child: BlurEffectView(
                                    color: overlayRow(),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                        },
                                        initialValue: lastName ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('Last Name'),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ): Container()) : Container(),
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          selectedSection == 0 ? Container(
                            height: 64,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: BlurEffectView(
                                    color: overlayRow(),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16),
                                        onChanged: (val) {
                                          setState(() {
                                            email = val;
                                          });
                                        },
                                        initialValue: email ?? '',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                                          labelText: Language.getPosTpmStrings('Mail'),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                          ),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        readOnly: widget.employee != null,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Flexible(
                                  child: BlurEffectView(
                                    color: overlayRow(),
                                    radius: 0,
                                    child: Container(
                                      height: 64,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 16, right: 8),
                                      child: DropdownButtonFormField(
                                        items: List.generate(GlobalUtils.positionsListOptions().length, (index) {
                                          return DropdownMenuItem(
                                            child: Text(
                                              GlobalUtils.positionsListOptions()[index],
                                            ),
                                            value: GlobalUtils.positionsListOptions()[index],
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            positionType = val;
                                          });
                                        },
                                        value: positionType != '' ? positionType : null,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: Text(
                                          'Position',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ): Container(),
                          selectedSection == 0 ? SizedBox(height: 2,): Container(),
                          selectedSection == 0 ? BlurEffectView(
                            color: overlayRow(),
                            radius: 0,
                            child: Container(
                              color: overlayBackground(),
                              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlutterTagging<GroupTag>(
                                      initialItems: tags,
                                      textFieldConfiguration: TextFieldConfiguration(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Groups (optional)',
                                        ),
                                      ),
                                      findSuggestions: GroupSuggestService(
                                        categories: state.employeeGroups,
                                        addedCategories: group,
                                      ).getGroup,
                                      additionCallback: (value) {
                                        return GroupTag(
                                          name: value,
                                          position: state.employeeGroups.length,
                                        );
                                      },
                                      onAdded: (language) {
                                        // api calls here, triggered when add to tag button is pressed
                                        return GroupTag();
                                      },
                                      configureChip: (lang) {
                                        return ChipConfiguration(
                                          label: Text(lang.name),
                                          labelStyle: TextStyle(color: iconColor()),
                                          deleteIconColor: iconColor(),
                                        );
                                      },
                                      onChanged: () {
                                        List cates = tags.map((e) {
                                          return e.category;
                                        }).toList();
                                        group = cates;
                                      },
                                      configureSuggestion: (GroupTag tag ) {
                                        return SuggestionConfiguration(
                                          title: Text(tag.name),
                                          additionWidget: Chip(
                                            avatar: Icon(
                                              Icons.add_circle,
                                              color: iconColor(),
                                            ),
                                            label: Text('Add New Group'),
                                            labelStyle: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ),
                            ),
                          ): Container(),
                          BlurEffectView(
                            color: overlayBackground(),
                            radius: 0,
                            child: Container(
                              height: 56,
                              color: overlayBackground(),
                              child: SizedBox.expand(
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      if (selectedSection == 1) {
                                        selectedSection = -1;
                                      } else {
                                        selectedSection = 1;
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/icon-security.svg',
                                              width: 16,
                                              height: 16,
                                              color: iconColor(),),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Apps Access',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        selectedSection == 1 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          selectedSection == 1 ? Container(
                            height: 300,
                            child: ListView.separated(
                              shrinkWrap: false,
                              itemBuilder: (context, index) {
                                BusinessApps businessApp = businessApps[index];
                                String icon = businessApp.dashboardInfo != null ? businessApp.dashboardInfo.icon: null;
                                if (icon == null) {
                                  return Container();
                                }
                                icon = icon.replaceAll('32', '64');
                                int aclIndex = acls.indexWhere((element) => element.microService == businessApp.code);
                                if (aclIndex > -1 && aclIndex < 100) {

                                } else {
                                  return Container();
                                }
                                Acl acl = acls[aclIndex];
                                String accessString = 'No Access';
                                if (acl.isFullAccess() == 1) {
                                  accessString = 'Custom Access';
                                } else if (acl.isFullAccess() == 2) {
                                  accessString = 'Full Access';
                                }
                                return BlurEffectView(
                                  color: Colors.transparent,
                                  radius: 0,
                                  child: Column(
                                    children: <Widget>[
                                      MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            if (selectedIndex == index) {
                                              selectedIndex = -1;
                                            } else {
                                              selectedIndex = index;
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 65,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 44,
                                                      height: 44,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(22),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            '${Env.cdnIcon}$icon',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 16,),
                                                    Flexible(
                                                      child: Text(
                                                        businessApp.code[0].toUpperCase() + businessApp.code.substring(1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    accessString,
                                                  ),
                                                  SizedBox(width: 8,),
                                                  SvgPicture.asset(
                                                    selectedIndex == index
                                                        ? 'assets/images/ic_minus.svg':
                                                    'assets/images/ic_plus.svg',
                                                    width: 16,
                                                    height: 16,
                                                    color: iconColor(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 0,
                                        thickness: 0.5,
                                      ),
                                      selectedIndex == index ? ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (ctx, idx) {
                                          String key = idx == 0
                                              ? 'Full Access'
                                              : businessApp.allowedAcls.toMap().keys.toList()[idx - 1];
                                          bool isChecked = false;
                                          if (idx == 0) {
                                            isChecked = acl.isFullAccess() == 2;
                                          } else {
                                            isChecked = acl.toMap()[key];
                                          }
                                          String permissionString = key[0].toUpperCase() + key.substring(1);
                                          return BlurEffectView(
                                            color: overlayRow(),
                                            radius: 0,
                                            child: MaterialButton(
                                              onPressed: () {
                                                isChecked = !isChecked;
                                                if (idx == 0) {
                                                  setState(() {
                                                    acl.setAll(isChecked);
                                                    acls[aclIndex] = acl;
                                                  });
                                                } else {
                                                  setState(() {
                                                    Map<String, bool> map = acl.toMap();
                                                    map[key] = isChecked;
                                                    acl.updateDict(map);
                                                    acls[aclIndex] = acl;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 60,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      permissionString,
                                                    ),
                                                    Transform.scale(
                                                      scale: 0.7,
                                                      child: CupertinoSwitch(
                                                        onChanged: (val) {
                                                          if (idx == 0) {
                                                            setState(() {
                                                              acl.setAll(val);
                                                              acls[aclIndex] = acl;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              Map<String, bool> map = acl.toMap();
                                                              map[key] = val;
                                                              acl.updateDict(map);
                                                              acls[aclIndex] = acl;
                                                            });
                                                          }
                                                        },
                                                        value: isChecked,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (ctx, idx) {
                                          return Divider(
                                            height: 0,
                                            thickness: 0.5,
                                          );
                                        },
                                        itemCount: businessApp.allowedAcls.toMap().keys.length + 1,
                                      ): Container(),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 0,
                                  thickness: 0.5,
                                );
                              },
                              itemCount: businessApps.length,
                            ),
                          ): Container(),
                          SaveBtn(
                            isUpdating: state.isUpdating,
                            color: overlayBackground(),
                            isBottom: false,
                            onUpdate: () {
                              if (_formKey.currentState.validate() &&
                                  !state.isUpdating) {
                                if (email.isEmpty) {
                                  Fluttertoast.showToast(msg: 'Email required');
                                  return;
                                }
                                if (!Validators.isValidEmail(email)) {
                                  Fluttertoast.showToast(msg: 'Email is not valid');
                                  return;
                                }
                                if (positionType == null || positionType == '') {
                                  Fluttertoast.showToast(msg: 'Position required');
                                  return;
                                }
                                if (widget.employee != null) {
                                  Map<String, dynamic> body = {};
                                  List<Map<String, dynamic>> aclsList = [];
                                  acls.forEach((element) {
                                    aclsList.add(element.toDictionary());
                                  });
                                  body['acls'] = aclsList;
                                  body['position'] = positionType;
                                  List<String> added = [];
                                  List<String> deleted = [];
                                  List<Group> original = widget.employee.groups;
                                  original.forEach((org) {
                                    bool has = false;
                                    group.forEach((element) {
                                      if (org.id == element.id) {
                                        has = true;
                                      }
                                    });
                                    if (!has) {
                                      deleted.add(org.id);
                                    }
                                  });
                                  group.forEach((element) {
                                    bool has = false;
                                    original.forEach((org) {
                                      if (org.id == element.id) {
                                        has = true;
                                      }
                                    });
                                    if (!has) {
                                      added.add(element.id);
                                    }
                                  });
                                  widget.setScreenBloc.add(UpdateEmployeeEvent(employeeId: widget.employee.id, body: body, addGroups: added, deleteGroups: deleted));
                                } else {
                                  Map<String, dynamic> body = {};
                                  List<Map<String, dynamic>> aclsList = [];
                                  acls.forEach((element) {
                                    aclsList.add(element.toDictionary());
                                  });
                                  body['acls'] = aclsList;
                                  body['position'] = positionType;
                                  body['email'] = email;
                                  List<String> groupList = [];
                                  if (group.length > 0) {
                                    group.forEach((element) {
                                      groupList.add(element.id);
                                    });
                                    body['groups'] = groupList;
                                  }
                                  widget.setScreenBloc.add(CreateEmployeeEvent(body: body, email: email,));
                                }
                              }
                            },
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

  showConfirmDialog() {
    showCupertinoDialog(
      context: context,
      builder: (builder) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Wrap(
                children: <Widget>[
                  BlurEffectView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        SvgPicture.asset('assets/images/info.svg', color: iconColor(),),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Text(
                          Language.getPosStrings('Are you sure you want to close this page?'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        widget.employee != null ? Padding(
                          padding: EdgeInsets.only(top: 16),
                        ): Container(),
                        widget.employee != null ? Text(
                          Language.getPosStrings('Changes will be lost'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ): Container(),
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
                                Language.getSettingsStrings('actions.no'),
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
                                Language.getSettingsStrings('actions.yes'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        );
      },
    );
  }
}

class GroupSuggestService {
  final List<Group> categories;
  final List<Group> addedCategories;
  GroupSuggestService( {this.categories = const [], this.addedCategories = const [],});

  Future<List<GroupTag>> getGroup(String query) async {
    List list = categories.where((element) {
      bool isadded = false;
      addedCategories.forEach((e) {
        if (e.name == element.name) {
          isadded = true;
        }
      });
      return !isadded;
    }).toList();

    List<GroupTag> categoryTags = [];
    list.forEach((element) {
      categoryTags.add(GroupTag(
        name: element.name,
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
