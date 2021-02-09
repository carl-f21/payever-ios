import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/views/employee/add_employee_group_screen.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';
import 'package:payever/theme.dart';

class AddGroupScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final Group group;
  AddGroupScreen({
    this.globalStateModel,
    this.setScreenBloc,
    this.group,
  });

  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  Business activeBusiness;

  final _formKey = GlobalKey<FormState>();

  Group group;
  String name;
  List<BusinessApps> businessApps = [];
  int selectedIndex = -1;
  List<Acl> acls = [];

  bool isEmployee = true;

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
    if (widget.group != null) {
      widget.setScreenBloc.add(GetGroupDetailEvent(group: widget.group));
      group = widget.group;
      name = group.name;
      acls = group.acls;
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
        widget.group == null ?
        'Add Group' : 'Edit Group',
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
          if(widget.group != null) {
            Fluttertoast.showToast(msg: 'Group successfully updated');
          } else {
            Fluttertoast.showToast(msg: 'Activation link sent to the Group successfully!');
          }
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {}
        if (state.emailInvalid) {
          Fluttertoast.showToast(msg: 'Group name already exist!');
          widget.setScreenBloc.add(ClearEmailInvalidEvent());
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (context, SettingScreenState state) {
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
                              padding: EdgeInsets.only(top: 10),
                              height: 64,
                              color: overlayBackground(),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 16),
                                      onChanged: (val) {
                                        setState(() {

                                        });
                                      },
                                      initialValue: name ?? '',
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                                        labelText: Language.getPosTpmStrings('Name'),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue, width: 0.5),
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.push(context, PageTransition(
                                        child: AddEmployeeGroupScreen(
                                          globalStateModel: widget.globalStateModel,
                                          setScreenBloc: widget.setScreenBloc,
                                        ),
                                        type: PageTransitionType.fade,
                                        duration: Duration(microseconds: 300),
                                      ));
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    height: 24,
                                    minWidth: 110,
                                    color: overlayColor(),
                                    elevation: 0,
                                    child: Text(
                                      'Add Employee',
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12,),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isEmployee = true;
                                      });
                                    },
                                    color: overlayColor().withOpacity(isEmployee ? 1: 0.5),
                                    height: 24,
                                    elevation: 0,
                                    child: AutoSizeText(
                                      'Employees',
                                      minFontSize: 8,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        isEmployee = false;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    color: overlayColor().withOpacity(!isEmployee ? 1: 0.5),
                                    elevation: 0,
                                    height: 24,
                                    child: AutoSizeText(
                                      'Access',
                                      maxLines: 1,
                                      minFontSize: 8,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isEmployee ? _employee(state) : _accesses(state),
                          SaveBtn(
                            isUpdating: state.isUpdating,
                            color: overlayBackground(),
                            isBottom: false,
                            onUpdate: () {
                              if (_formKey.currentState.validate() &&
                                  !state.isUpdating) {
                                if (name.isEmpty) {
                                  Fluttertoast.showToast(msg: 'Group name required');
                                  return;
                                }


                                if (widget.group != null) {
                                  Map<String, dynamic> body = {};
                                  List<Map<String, dynamic>> aclsList = [];
                                  acls.forEach((element) {
                                    aclsList.add(element.toDictionary());
                                  });
                                  body['acls'] = aclsList;
                                  String groupName;
                                  if (name != widget.group.name) {
                                    groupName = name;
                                    body['name'] = name;
                                  }
                                  List<String> added = [];
                                  List<String> deleted = [];
                                  List<Employee> original = widget.group.employees;
                                  original.forEach((org) {
                                    bool has = false;
                                    state.groupDetail.employees.forEach((element) {
                                      if (org.id == element.id) {
                                        has = true;
                                      }
                                    });
                                    if (!has) {
                                      deleted.add(org.id);
                                    }
                                  });
                                  state.groupDetail.employees.forEach((element) {
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
                                  widget.setScreenBloc.add(UpdateGroupEvent(groupId: widget.group.id, body: body, addEmployees: added, deleteEmployees: deleted, groupName: groupName));
                                } else {
                                  Map<String, dynamic> body = {};
                                  List<Map<String, dynamic>> aclsList = [];
                                  acls.forEach((element) {
                                    aclsList.add(element.toDictionary());
                                  });
                                  body['acls'] = aclsList;
                                  body['name'] = name;

                                  List<String> employees = [];
                                  if (state.employees.length > 0) {
                                    state.employees.forEach((element) {
                                      employees.add(element.id);
                                    });
                                    body['employees'] = employees;
                                  }
                                  widget.setScreenBloc.add(CreateGroupEvent(body: body, groupName: name));
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

  Widget _employee(SettingScreenState state) {
    if (state.groupDetail == null) {
      return Container();
    }
    double height = 56.0 * state.groupDetail.employees.length;
    return Container(
      height: height > 300 ? 300 : height,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.separated(
        shrinkWrap: false,
        itemBuilder: (context, index) {
          Employee employee = state.groupDetail.employees[index];
          String fullName = employee.fullName ?? ('${employee.firstName ?? ''} ${employee.lastName ?? ''}');
          return Row(
            children: <Widget>[
              Expanded(
                child: Text(fullName),
              ),
              MaterialButton(
                onPressed: () {
                  Group group = state.groupDetail;
                  List<Employee> employees = group.employees;
                  employees.remove(employee);
                  widget.setScreenBloc.add(AddEmployeeToGroupEvent(employees: employees));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 24,
                minWidth: 30,
                color: overlayBackground(),
                elevation: 0,
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
            thickness: 0.5,
          );
        },
        itemCount: state.groupDetail.employees.length,
      ),
    );
  }

  Widget _accesses(SettingScreenState state) {
    return Container(
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
                  elevation: 0,
                  color: overlayBackground().withOpacity(0.2),
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
                      color: Colors.transparent,
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
                        widget.group != null ? Padding(
                          padding: EdgeInsets.only(top: 16),
                        ): Container(),
                        widget.group != null ? Text(
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
                ],
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
  }
}
