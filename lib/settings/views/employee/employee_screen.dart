import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/views/employee/add_employee_screen.dart';
import 'package:payever/settings/views/employee/add_group_screen.dart';
import 'package:payever/settings/views/wallpaper/employee_filter_view.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/views/sub_view/search_text_content_view.dart';

class TagItemModel {
  String title;
  String type;
  TagItemModel({this.title = '', this.type});
}

class EmployeeScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  EmployeeScreen({
    this.globalStateModel,
    this.setScreenBloc,
  });

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  bool _isPortrait;
  bool _isTablet;
  bool isEmployee = true;
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List<TagItemModel> _filterItems = [];
  int _searchTagIndex = -1;

  List<String> employeeTableStatus = [];
  List<String> groupTableStatus = [];

  @override
  void initState() {
    super.initState();
    employeeTableStatus.addAll(['Position', 'Mail', 'Status']);
    groupTableStatus.addAll(['Employees']);
    widget.setScreenBloc.add(GetEmployeesEvent());
    widget.setScreenBloc.add(GetGroupEvent());
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
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        } else if (state is SettingScreenUpdateSuccess) {
          widget.setScreenBloc.add(GetEmployeesEvent());
          widget.setScreenBloc.add(GetGroupEvent());
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: Appbar('Employee'),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: state.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _getBody(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _secondAppbar(SettingScreenState state) {
    return Container(
      height: 50,
      width: double.infinity,
      color: overlaySecondAppBar(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {
                if (state.isSearching) return;
                showSearchTextDialog(state);
              },
              minWidth: 20,
              padding: EdgeInsets.zero,
              child: SvgPicture.asset(
                'assets/images/searchicon.svg',
                width: 20,
              ),
            ),
            PopupMenuButton<MenuItem>(
              icon: SvgPicture.asset(
                'assets/images/filter.svg',
                width: 20,
              ),
              offset: Offset(0, 100),
              padding: EdgeInsets.zero,
              onSelected: (MenuItem item) => item.onTap(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: overlayFilterViewBackground(),
              itemBuilder: (BuildContext context) {
                return (isEmployee ? appBarEmployeePopUpActions(context, state): appBarGroupPopUpActions(context, state)).map((MenuItem item) {
                  return PopupMenuItem<MenuItem>(
                    value: item,
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                      child: isEmployee
                          ? AddEmployeeScreen(
                              globalStateModel: widget.globalStateModel,
                              setScreenBloc: widget.setScreenBloc,
                            )
                          : AddGroupScreen(
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
              color: overlayBackground().withOpacity(1),
              elevation: 0,
              child: Text(
                isEmployee ? 'Add Employee' : 'Add Group',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            SizedBox(
              width: 70,
              child: Center(
                child: Text(
                  isEmployee ? '${state.employees.length} ${state.employees.length > 1 ? 'members' : 'member'}'
                      : '${state.groupList.length} ${state.groupList.length > 1 ? 'groups' : 'group'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12,
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
                          widget.setScreenBloc.add(GetEmployeesEvent());
                        });
                      },
                      color: overlaySwitcherBackground().withOpacity(isEmployee ? 1.0: 0.6),
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
                          widget.setScreenBloc.add(GetGroupEvent());
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      color: overlaySwitcherBackground().withOpacity(!isEmployee ? 1.0: 0.6),
                      elevation: 0,
                      height: 24,
                      child: AutoSizeText(
                        'Groups',
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
            PopupMenuButton<MenuItem>(
              icon: SvgPicture.asset(
                'assets/images/employee-filter.svg',
                width: 20,
                height: 20,
              ),
              offset: Offset(0, 100),
              onSelected: (MenuItem item) => item.onTap(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: overlayFilterViewBackground(),
              itemBuilder: (BuildContext context) {
                return (isEmployee ? appBarEmployeeTablePopUpActions(context, state) : appBarGroupTablePopUpActions(context, state))
                    .map((MenuItem item) {
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
                        item.icon != null ? item.icon : Container(),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView employeeTableBody(BuildContext ctx, SettingScreenState state) {
    int selectedCount = state.employeeListModels.where((element) => element.isChecked).toList().length;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowHeight: 50,
          headingRowHeight: 50,
          dividerThickness: 0.5,
          columnSpacing: 16,
          horizontalMargin: 16,
          columns: [
            DataColumn(
              label: IconButton(
                onPressed: () {
                  widget.setScreenBloc
                      .add(SelectAllEmployeesEvent(isSelect: true));
                },
                icon: Icon(selectedCount > 0
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
              ),
              numeric: false,
              tooltip: 'This is First Name',
            ),
            DataColumn(
              label: Text(
                'Employee',
              ),
              numeric: false,
              tooltip: 'Employee',
            ),
            employeeTableStatus.contains('Position') ? DataColumn(
              label: Text(
                'Position',
              ),
              numeric: false,
              tooltip: 'Position',
            ): DataColumn(label: Container()),
            employeeTableStatus.contains('Mail') ? DataColumn(
              label: Text(
                'Mail',
              ),
              numeric: false,
              tooltip: 'Mail',
            ): DataColumn(label: Container()),
            employeeTableStatus.contains('Status') ? DataColumn(
              label: Text(
                'Status',
              ),
              numeric: false,
              tooltip: 'Status',
            ): DataColumn(label: Container()),
            DataColumn(
              label: Container(),
              numeric: false,
              tooltip: 'Edit',
            ),
          ],
          rows: state.employeeListModels
              .map(
                (emp) => DataRow(
                cells: [
                  DataCell(
                    IconButton(
                      onPressed: () {
                        widget.setScreenBloc.add(CheckEmployeeItemEvent(model: emp));
                      },
                      icon: Icon(emp.isChecked ? Icons.check_box : Icons.check_box_outline_blank),
                    ),
                  ),
                  DataCell(
                    Text(emp.employee.fullName ?? (emp.employee.email ?? '-')),
                  ),
                  employeeTableStatus.contains('Position') ? DataCell(
                    Text(emp.employee.positionType ?? '-'),
                  ): DataCell(Container()),
                  employeeTableStatus.contains('Mail') ? DataCell(
                    Text(emp.employee.email ?? '-'),
                  ): DataCell(Container()),
                  employeeTableStatus.contains('Status') ? DataCell(
                    Text(emp.employee.status == 1 ? 'Invited' : 'Active'),
                  ): DataCell(Container()),
                  DataCell(
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: AddEmployeeScreen(
                              setScreenBloc: widget.setScreenBloc,
                              globalStateModel: widget.globalStateModel,
                              employee: emp.employee,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 0,
                      color: overlayBackground(),
                      elevation: 0,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                ]),
          ) .toList(),
        ),
      ),
    );
  }

  SingleChildScrollView groupTableBody(BuildContext ctx, SettingScreenState state) {
    int selectedCount = state.groupList.where((element) => element.isChecked).toList().length;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowHeight: 50,
          headingRowHeight: 50,
          dividerThickness: 0.5,
          columnSpacing: 16,
          horizontalMargin: 16,
          columns: [
            DataColumn(
              label: IconButton(
                onPressed: () {
                  widget.setScreenBloc
                      .add(SelectAllGroupEvent(isSelect: true));
                },
                icon: Icon(selectedCount > 0
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
              ),
              numeric: false,
            ),
            DataColumn(
              label: Text(
                'Group name',
              ),
              numeric: false,
              tooltip: 'Group name',
            ),
            groupTableStatus.contains('Employees') ? DataColumn(
              label: Text(
                'Employees',
              ),
              numeric: false,
              tooltip: 'Employees',
            ): DataColumn(label: Container()),
            DataColumn(
              label: Container(),
              numeric: false,
              tooltip: 'Edit',
            ),
          ],
          rows: state.groupList
              .map(
                (grp) => DataRow(
                cells: [
                  DataCell(
                    IconButton(
                      onPressed: () {
                        widget.setScreenBloc.add(CheckGroupItemEvent(model: grp));
                      },
                      icon: Icon(grp.isChecked ? Icons.check_box : Icons.check_box_outline_blank),
                    ),
                  ),
                  DataCell(
                    Text(grp.group.name ?? '-'),
                  ),
                  groupTableStatus.contains('Employees') ? DataCell(
                    Text(
                      '${grp.group.employees.length} ${grp.group.employees.length > 1 ? 'users' : 'user'}',
                    ),
                  ) : DataCell(Container()),
                  DataCell(
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: AddGroupScreen(
                              setScreenBloc: widget.setScreenBloc,
                              globalStateModel: widget.globalStateModel,
                              group: grp.group,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 30,
                      color: overlayBackground(),
                      elevation: 0,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                ]),
          ) .toList(),
        ),
      ),
    );
  }

  Widget _thirdAppbar(SettingScreenState state) {

    int selectedCount = isEmployee ? state.employeeListModels.where((element) => element.isChecked).toList().length
        : state.groupList.where((element) => element.isChecked).toList().length;
    return Visibility(
      visible: selectedCount > 0,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 4,
          bottom: 4,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: overlayFilterViewBackground(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                  ),
                  InkWell(
                    child: SvgPicture.asset('assets/images/xsinacircle.svg', color: iconColor(),),
                    onTap: () {
                      isEmployee ? widget.setScreenBloc
                          .add(SelectAllEmployeesEvent(isSelect: false)) : widget.setScreenBloc
                          .add(SelectAllGroupEvent(isSelect: false));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                  ),
                  Text(
                    '$selectedCount ITEM${state.employees.length > 1 ? 'S': ''} SELECTED',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<MenuItem>(
                icon: Icon(Icons.more_horiz),
                offset: Offset(0, 100),
                onSelected: (MenuItem item) => item.onTap(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: overlayFilterViewBackground(),
                itemBuilder: (BuildContext context) {
                  return (isEmployee ? selectEmployeePopUpActions(context, state) : selectGroupPopUpActions(context, state)).map((MenuItem item) {
                    return PopupMenuItem<MenuItem>(
                      value: item,
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterTagsView(SettingScreenState state) {
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 0, bottom: 0,
      ),
      child: Tags(
        key: _tagStateKey,
        itemCount: _filterItems.length,
        alignment: WrapAlignment.start,
        spacing: 4,
        runSpacing: 8,
        itemBuilder: (int index) {
          return ItemTags(
            key: Key('filterItem$index'),
            index: index,
            title: _filterItems[index].title,
            color: overlayBackground(),
            activeColor: overlayBackground(),
            textActiveColor: iconColor(),
            textColor: iconColor(),
            elevation: 0,
            padding: EdgeInsets.only(
              left: 16, top: 8, bottom: 8, right: 16,
            ),
            removeButton: ItemTagsRemoveButton(
              color: iconColor(),
              backgroundColor: Colors.transparent,
              onRemoved: () {
                if (index == _searchTagIndex) {
                  _searchTagIndex = -1;
                  isEmployee ? widget.setScreenBloc.add(
                      UpdateEmployeeSearchText(searchText: '')
                  ): widget.setScreenBloc.add(UpdateGroupSearchText(searchText: ''));
                } else {
                  List<FilterItem> filterTypes = [];
                  filterTypes.addAll(isEmployee ? state.filterEmployeeTypes: state.filterGroupTypes);
                  filterTypes.removeAt(index);
                  isEmployee ? widget.setScreenBloc.add(
                      UpdateEmployeeFilterTypeEvent(filterTypes: filterTypes)
                  ): widget.setScreenBloc.add(UpdateGroupFilterTypeEvent(filterTypes: filterTypes));
                }
                return true;
              },
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(SettingScreenState state) {
    _filterItems = [];
    if (isEmployee) {
      if (state.filterEmployeeTypes.length > 0) {
        for (int i = 0; i < state.filterEmployeeTypes.length; i++) {
          String filterString = '${filterEmployeeLabels[state.filterEmployeeTypes[i].type]} ${filterEmployeeConditions[state.filterEmployeeTypes[i].condition]}: ${state.filterEmployeeTypes[i].disPlayName}';
          TagItemModel item = TagItemModel(title: filterString, type: state.filterEmployeeTypes[i].type);
          _filterItems.add(item);
        }
      }
      if (state.searchEmployeeText.length > 0) {
        _filterItems.add(TagItemModel(title: 'Search is: ${state.searchEmployeeText}', type: null));
        _searchTagIndex = _filterItems.length - 1;
      }
    } else {
      if (state.filterGroupTypes.length > 0) {
        for (int i = 0; i < state.filterGroupTypes.length; i++) {
          String filterString = '${filterGroupLabels[state.filterGroupTypes[i].type]} ${filterEmployeeConditions[state.filterGroupTypes[i].condition]}: ${state.filterGroupTypes[i].disPlayName}';
          TagItemModel item = TagItemModel(title: filterString, type: state.filterGroupTypes[i].type);
          _filterItems.add(item);
        }
      }
      if (state.searchGroupText.length > 0) {
        _filterItems.add(TagItemModel(title: 'Search is: ${state.searchGroupText}', type: null));
        _searchTagIndex = _filterItems.length - 1;
      }
    }
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _secondAppbar(state),
          _filterTagsView(state),
          state.employees == null
              ? Container()
              : Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 50,
                        color: overlayBackground(),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: isEmployee ? employeeTableBody(context, state)
                            : groupTableBody(context, state),
                      ),
                      _thirdAppbar(state),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  void showMeDialog(BuildContext context, String filterType, SettingScreenState state) {
    String filterName = filterEmployeeLabels[filterType];
    debugPrint('FilterTypeName => $filterType');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Filter by: $filterName',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: EmployeeFilterView(
                type: filterType,
                onSelected: (FilterItem val) {
                  Navigator.pop(context);
                  List<FilterItem> filterTypes = [];
                  filterTypes.addAll(isEmployee ? state.filterEmployeeTypes: state.filterGroupTypes);
                  if (val != null) {
                    if (filterTypes.length > 0) {
                      int isExist = filterTypes.indexWhere((element) => element.type == val.type);
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
                      int isExist = filterTypes.indexWhere((element) => element.type == val.type);
                      if (isExist != null) {
                        filterTypes.removeAt(isExist);
                      }
                    }
                  }
                  isEmployee ? widget.setScreenBloc.add(
                      UpdateEmployeeFilterTypeEvent(filterTypes: filterTypes)
                  ): widget.setScreenBloc.add(UpdateGroupFilterTypeEvent(filterTypes: filterTypes));
                }
            ),
          );
        });
  }
  List<MenuItem> appBarEmployeePopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Name',
        onTap: () {
          showMeDialog(context, 'name', state);
        },
      ),
      MenuItem(
        title: 'Position',
        onTap: () {
          showMeDialog(context, 'position', state);
        },
      ),
      MenuItem(
        title: 'E-mail',
        onTap: () {
          showMeDialog(context, 'email', state);
        },
      ),
      MenuItem(
        title: 'Status',
        onTap: () {
          showMeDialog(context, 'status', state);
        },
      ),
    ];
  }

  List<MenuItem> appBarGroupPopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Name',
        onTap: () {
          showMeDialog(context, 'name', state);
        },
      ),
    ];
  }

  List<MenuItem> appBarEmployeeTablePopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Position',
        icon: employeeTableStatus.contains('Position') ? Icon(
          Icons.check,
        ): null,
        onTap: () {
          setState(() {
            employeeTableStatus.contains('Position')
                ? employeeTableStatus.remove('Position')
                : employeeTableStatus.add('Position');
          });
        },
      ),
      MenuItem(
        title: 'Mail',
        icon: employeeTableStatus.contains('Mail') ? Icon(
          Icons.check,
        ): null,
        onTap: () {
          setState(() {
            employeeTableStatus.contains('Mail')
                ? employeeTableStatus.remove('Mail')
                : employeeTableStatus.add('Mail');
          });
        },
      ),
      MenuItem(
        title: 'Status',
        icon: employeeTableStatus.contains('Status') ? Icon(
          Icons.check,
        ): null,
        onTap: () {
          setState(() {
            employeeTableStatus.contains('Status')
                ? employeeTableStatus.remove('Status')
                : employeeTableStatus.add('Status');
          });
        },
      ),
    ];
  }

  List<MenuItem> selectEmployeePopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Unselect',
        onTap: () {
          widget.setScreenBloc
              .add(SelectAllEmployeesEvent(isSelect: false));
        },
      ),
      MenuItem(
        title: 'Delete employees',
        onTap: () {
          showDeleteConfirmDialog();
        },
      ),
    ];
  }

  List<MenuItem> appBarGroupTablePopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Employees',
        icon: groupTableStatus.contains('Employees') ? Icon(
          Icons.check,
        ): null,
        onTap: () async {
          setState(() {
            groupTableStatus.contains('Employees')
                ? groupTableStatus.remove('Employees')
                : groupTableStatus.add('Employees');
          });
        },
      ),
    ];
  }

  List<MenuItem> selectGroupPopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Unselect',
        onTap: () {
          widget.setScreenBloc
              .add(SelectAllGroupEvent(isSelect: false));
        },
      ),
      MenuItem(
        title: 'Delete groups',
        onTap: () {

        },
      ),
    ];
  }

  List<MenuItem> addEployeeToGroupPopup(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Unselect',
        onTap: () {
          widget.setScreenBloc
              .add(SelectAllEmployeesEvent(isSelect: false));
        },
      ),
      MenuItem(
        title: 'Add to group',
        onTap: () {

        },
      ),
    ];
  }

  void showSearchTextDialog(SettingScreenState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          content: SearchTextContentView(
            searchText: isEmployee ? state.searchEmployeeText : state.searchGroupText,
            onSelected: (value) {
              Navigator.pop(context);
              isEmployee ? widget.setScreenBloc.add(
                  UpdateEmployeeSearchText(searchText: value)
              ): widget.setScreenBloc.add(
                  UpdateGroupSearchText(searchText: value)
              );
            },
          ),
        );
      },
    );
  }

  showDeleteConfirmDialog() {
    showCupertinoDialog(
      context: context,
      builder: (builder) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Wrap(
                children: <Widget>[
                  BlurEffectView(
                    color: Color.fromRGBO(50, 50, 50, 0.4),
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
                          Language.getPosStrings('The selected employees will be deleted?'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Text(
                          Language.getPosStrings('Do you want to proceed?'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
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
                                Language.getSettingsStrings('actions.no'),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                widget.setScreenBloc.add(DeleteEmployeeEvent());
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
