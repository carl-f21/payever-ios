library multiselect_formfield;

import 'package:flutter/material.dart';

import 'multi_select_dialog.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
//  final List dataSource;
//  final String textField;
//  final String valueField;
  final Function change;
  final Function open;
  final Function close;
  final Widget leading;
  final Widget trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color fillColor;
  final InputBorder border;

  MultiSelectFormField(
      {FormFieldSetter<dynamic> onSaved,
        FormFieldValidator<dynamic> validator,
        dynamic initialValue,
        bool autovalidate = false,
        this.titleText = 'Title',
        this.hintText = 'Tap to select one or more',
        this.required = false,
        this.errorText = 'Please select one or more options',
        this.leading,
        this.change,
        this.open,
        this.close,
        this.okButtonLabel = 'OK',
        this.cancelButtonLabel = 'CANCEL',
        this.fillColor,
        this.border,
        this.trailing,
      })
      : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue,
    autovalidate: autovalidate,
    builder: (FormFieldState<dynamic> state) {
      List<Widget> _buildSelectedOptions(state) {
        List<Widget> selectedOptions = [];

        if (state.value != null) {
          if (state.value.length < 1) {
            return [];
          }
          state.value[0].forEach((item) {
            var existingItem = state.value[1].keys.toList().singleWhere((itm) => itm == item, orElse: () => null);
            selectedOptions.add(
              Chip(
                padding: EdgeInsets.all(0),
                label: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: state.value[1][existingItem],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      )
                  ),
                ),
              ),
            );
          });
        }

        return selectedOptions;
      }
      return InkWell(
        onTap: () async {
          List initialSelected = state.value[0];
          if (initialSelected == null) {
            initialSelected = List();
          }

          List result = await showDialog<List>(
            context: state.context,
            builder: (BuildContext context) {
              return MultiSelectDialog(
                title: titleText,
                okButtonLabel: okButtonLabel,
                cancelButtonLabel: cancelButtonLabel,
                initialSelectedValues: initialSelected,
                colorMaps: state.value[1],
                addButtonLabel: 'Add Color',
              );
            },
          );

          if (result != null) {
            state.didChange(result);
            state.save();
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            errorText: state.hasError ? state.errorText : null,
            errorMaxLines: 4,
            fillColor: Colors.transparent,
            border: border ?? UnderlineInputBorder(),
          ),
          isEmpty: state.value == null || state.value == '',
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        titleText,
                        style: TextStyle(fontSize: 12.0,),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.value != null && state.value.length > 0
                    ? Wrap(
                  spacing: 4.0,
                  runSpacing: 0.0,
                  children: _buildSelectedOptions(state),
                )
                    : new Container(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    hintText,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
