import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/models/enums.dart';
import 'package:payever/transactions/models/transaction.dart';

class ProductFilterRangeContentView extends StatefulWidget {
  final String type;
  final Function onSelected;
  ProductFilterRangeContentView({this.type, this.onSelected});

  @override
  _ProductFilterRangeContentViewState createState() => _ProductFilterRangeContentViewState();
}

class _ProductFilterRangeContentViewState extends State<ProductFilterRangeContentView> {

  DateTime selectedDate;
  String filterConditionName = '';
  TextEditingController filterValueController = TextEditingController();
  TextEditingController filterValueController1 = TextEditingController();
  Currency selectedCurrency;
  String selectedOptions;

  @override
  Widget build(BuildContext context) {
    Map<String, String> conditions = filterConditionsByFilterType(widget.type);
    debugPrint('conditions => $conditions');
    Map<String, String> options = getOptionsByFilterType(widget.type);
    if (filterConditionName == '') {
      filterConditionName = conditions.keys.toList().first;
    }
    if (selectedDate != null) {
      filterValueController.text = formatDate(selectedDate, [m, '/', d, '/', yy]);
    }
    int dropdown = 2;
    if (widget.type == 'currency') {
      dropdown = 0;
    } else if (widget.type == 'status' ||
      widget.type == 'specific_status' ||
      widget.type == 'channel' ||
      widget.type == 'type') {
      dropdown = 1;
    }
    return Container(
        child: Container(
          padding: EdgeInsets.fromLTRB(0 , 6, 0, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: overlayBackground(),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
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
                    dropdown == 0 ?
                      Container(
                        height: 60,
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: new FutureBuilder(
                          future: DefaultAssetBundle.of(context).loadString('assets/json/currency.json'),
                          builder: (context, snapshot) {
                            List<Currency> currencies = parseJosn(snapshot.data.toString());
                            return currencies.isNotEmpty ?
                            DropdownButton<String>(
                              isExpanded: true,
                              underline: Container(),
                              itemHeight: 60,
                              hint: Text(
                                'Option',
                              ),
                              value: selectedCurrency != null ? selectedCurrency.name : null,
                              items: currencies.map((Currency value) {
                                return DropdownMenuItem<String>(
                                  value: value.name,
                                  child: Text(
                                    value.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  int index = currencies.indexWhere((element) => element.name == value);
                                  selectedCurrency = currencies[index];
                                });
                              },
                            ): Container(child: CircularProgressIndicator(),);
                          },
                        ),
                      ) : Container(),
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
                    dropdown == 2
                        ? Column(
                          children: <Widget>[
                            Container(
                                height: 60,
                                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextField(
                                        controller: filterValueController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: (filterConditionName == 'between') ? 'From' : hintTextByFilter(widget.type),
                                        ),
                                        style: TextStyle(
                                            fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    widget.type == 'created_at'
                                        ? IconButton(
                                            icon: Icon(Icons.calendar_today),
                                            onPressed: () async {
                                              final DateTime picked =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate != null
                                                    ? selectedDate
                                                    : DateTime.now(),
                                                firstDate: DateTime(2000, 1),
                                                lastDate: DateTime(2030, 12),
                                              );
                                              if (picked != null &&
                                                  picked != selectedDate) {
                                                setState(() {
                                                  selectedDate = picked;
                                                });
                                              }
                                            },
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            Visibility(
                              visible: filterConditionName == 'between' ,
                              child: Container(
                              height: 60,
                              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: filterValueController1,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'To',
                                      ),
                                      style: TextStyle(
                                          fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  widget.type == 'created_at'
                                      ? IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      final DateTime picked =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate != null
                                            ? selectedDate
                                            : DateTime.now(),
                                        firstDate: DateTime(2000, 1),
                                        lastDate: DateTime(2030, 12),
                                      );
                                      if (picked != null &&
                                          picked != selectedDate) {
                                        setState(() {
                                          selectedDate = picked;
                                        });
                                      }
                                    },
                                  )
                                      : Container(),
                                ],
                              ),
                            ),)
                          ],
                        )
                        : Container(),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    if (widget.type == 'currency') {
                      if (selectedCurrency == null) {
                        widget.onSelected(null);
                      } else {
                        widget.onSelected(
                          FilterItem(
                            type: widget.type,
                            condition: filterConditionName,
                            value: selectedCurrency.code,
                            disPlayName: selectedCurrency.name,
                          ),
                        );
                      }
                    } else if (widget.type == 'created_at') {
                      if (selectedDate == null) {
                        widget.onSelected(null);
                      } else {
                        widget.onSelected(
                          FilterItem(
                            type: widget.type,
                            condition: filterConditionName,
                            value: formatDate(selectedDate, [yyyy, '-', mm, '-', dd]),
                            disPlayName: filterValueController.text,
                          ),
                        );
                      }
                    } else if (widget.type == 'status' ||
                        widget.type == 'specific_status' ||
                        widget.type == 'channel' ||
                        widget.type == 'type') {
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
                            value1: filterValueController1.text,
                            disPlayName: filterConditionName != 'between'
                                ? filterValueController.text
                                : filterValueController.text +
                                ' and ' +
                                filterValueController1.text,
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
        ));
  }

  List<Currency> parseJosn(String response) {
    if(response==null){
      return [];
    }
    final parsed = json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Currency>((json) => new Currency.fromJson(json)).toList();
  }

}
