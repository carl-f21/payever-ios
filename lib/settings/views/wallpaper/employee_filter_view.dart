import 'package:flutter/material.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/theme.dart';

class EmployeeFilterView extends StatefulWidget {
  final String type;
  final Function onSelected;
  EmployeeFilterView({this.type, this.onSelected});

  @override
  _EmployeeFilterViewState createState() => _EmployeeFilterViewState();
}

class _EmployeeFilterViewState extends State<EmployeeFilterView> {

  String filterConditionName = '';
  TextEditingController filterValueController = TextEditingController();
  String selectedOptions;

  @override
  Widget build(BuildContext context) {
    Map<String, String> conditions = getFilterWithLabel(widget.type);
    debugPrint('conditions => $conditions');
    Map<String, String> options = getOptions(widget.type);
    if (filterConditionName == '') {
      filterConditionName = conditions.keys.toList().first;
    }
    int dropdown = 2;
    if (widget.type == 'status' ||
        widget.type == 'position') {
      dropdown = 1;
    }
    return Container(
      height: 173,
      child: Container(
        padding: EdgeInsets.fromLTRB(0 , 6, 0, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: overlayBackground(),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: Container(),
                      value: filterConditionName != '' ? filterConditionName: null,
                      items: conditions.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            conditions[value],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          filterConditionName = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.white10,
                  ),
                  dropdown == 1 ?
                  Container(
                    height: 60,
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: Container(),
                      itemHeight: 60,
                      hint: Text(
                        'Option',
                      ),
                      value: selectedOptions,
                      items: options.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            options[value],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedOptions = value;
                        });
                      },
                    ),
                  ) : Container(),
                  dropdown == 2 ? Container(
                    height: 60,
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: filterValueController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                            ),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],

                    ),
                  ): Container(),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  if (widget.type == 'status' ||
                      widget.type == 'position') {
                    if (selectedOptions == null) {
                      widget.onSelected(null);
                    } else {
                      widget.onSelected(
                        FilterItem(
                          type: widget.type,
                          condition: filterConditionName,
                          value: selectedOptions,
                          disPlayName: options[selectedOptions],
                        ),
                      );
                    }
                  } else {
                    if (filterValueController.text.length == 0) {
                      widget.onSelected(null);
                    } else {
                      widget.onSelected(
                        FilterItem(
                          type: widget.type,
                          condition: filterConditionName,
                          value: filterValueController.text,
                          disPlayName: filterValueController.text,
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  width: 60,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('Apply'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> getOptions(String type) {
    if (type == 'position') {
      return {
        'Cashier': 'Cashier',
        'Sales': 'Sales',
        'Marketing': 'Marketing',
        'Staff': 'Staff',
        'Admin': 'Admin',
        'Others': 'Others',
      };
    } else if (type == 'status') {
      return {
        '1': 'Invited',
        '2': 'Active',
      };
    }
    return {};
  }
}
