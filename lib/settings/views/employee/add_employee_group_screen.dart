import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/views/sub_view/search_text_content_view.dart';

class AddEmployeeGroupScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  AddEmployeeGroupScreen({
    this.globalStateModel,
    this.setScreenBloc,
  });

  @override
  _AddEmployeeGroupScreenState createState() => _AddEmployeeGroupScreenState();
}

class _AddEmployeeGroupScreenState extends State<AddEmployeeGroupScreen> {
  bool _isPortrait;
  bool _isTablet;

  List<String> employeeTableStatus = [];

  @override
  void initState() {
    super.initState();
    employeeTableStatus.addAll(['Position', 'Mail']);
    widget.setScreenBloc.add(GetEmployeesEvent());
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
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: Appbar('Add Employee'),
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
      color: overlayBackground(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              MaterialButton(
                onPressed: () {
                  showSearchTextDialog(state);
                },
                minWidth: 20,
                child: SvgPicture.asset(
                  'assets/images/searchicon.svg',
                  width: 20,
                  color: iconColor(),
                ),
              ),
              PopupMenuButton<MenuItem>(
                icon: SvgPicture.asset(
                  'assets/images/filter.svg',
                  width: 20,
                  color: iconColor(),
                ),
                offset: Offset(0, 100),
                onSelected: (MenuItem item) => item.onTap(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: overlayBackground(),
                itemBuilder: (BuildContext context) {
                  return appBarPopUpActions(context, state).map((MenuItem item) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PopupMenuButton<MenuItem>(
                icon: SvgPicture.asset(
                  'assets/images/employee-filter.svg',
                  width: 20,
                  height: 20,
                  color: iconColor(),
                ),
                offset: Offset(0, 100),
                onSelected: (MenuItem item) => item.onTap(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: overlayBackground(),
                itemBuilder: (BuildContext context) {
                  return appBarEmployeeTablePopUpActions(context, state)
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
            ],
          ),
        ],
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
                    Text(emp.employee.fullName ?? '-'),
                  ),
                  employeeTableStatus.contains('Position') ? DataCell(
                    Text(emp.employee.positionType ?? '-'),
                  ): DataCell(Container()),
                  employeeTableStatus.contains('Mail') ? DataCell(
                    Text(emp.employee.email ?? '-'),
                  ): DataCell(Container()),
                ],
                ),
          ) .toList(),
        ),
      ),
    );
  }

  Widget _thirdAppbar(SettingScreenState state) {

    int selectedCount = state.employeeListModels.where((element) => element.isChecked).toList().length;
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
            color: overlayBackground(),
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
                    child: SvgPicture.asset(
                      'assets/images/xsinacircle.svg',
                      color: iconColor(),
                    ),
                    onTap: () {
                       widget.setScreenBloc
                          .add(SelectAllEmployeesEvent(isSelect: false));
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
                color: overlayBackground(),
                itemBuilder: (BuildContext context) {
                  return addEployeeToGroupPopup(context, state).map((MenuItem item) {
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

  Widget _getBody(SettingScreenState state) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _secondAppbar(state),
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
                  child: employeeTableBody(context, state),
                ),
                _thirdAppbar(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<MenuItem> appBarPopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Name',
        onTap: () async {},
      ),
      MenuItem(
        title: 'Position',
        onTap: () async {},
      ),
      MenuItem(
        title: 'E-mail',
        onTap: () {},
      ),
      MenuItem(
        title: 'Status',
        onTap: () {},
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
          List<Employee> selected = [];
          state.employeeListModels.forEach((element) {
            if (element.isChecked) {
              selected.add(element.employee);
            }
          });

          widget.setScreenBloc.add(AddEmployeeToGroupEvent(employees: selected));
          Navigator.pop(context);
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
            searchText: '',
            onSelected: (value) {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

}
