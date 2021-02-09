import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/products/views/add_variant_color_screen.dart';

class MultiSelectDialogItem {
  const MultiSelectDialogItem(this.value, this.label);

  final String value;
  final String label;
}

class MultiSelectDialog extends StatefulWidget {
  MultiSelectDialog(
      {Key key, this.initialSelectedValues, this.title, this.okButtonLabel, this.cancelButtonLabel, this.colorMaps = const {}, this.addButtonLabel})
      : super(key: key);

  final List<String> initialSelectedValues;
  final String title;
  final String okButtonLabel;
  final String addButtonLabel;
  final String cancelButtonLabel;
  final Map<String, Color> colorMaps;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  final _selectedValues = List<String>();
  Map<String, Color> colorMaps = {};
  List<MultiSelectDialogItem> items = [];

  void initState() {
    super.initState();
    colorMaps.addAll(widget.colorMaps);
    colorMaps.keys.forEach((item) {
      items.add(MultiSelectDialogItem(item, item));
    });

    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(String itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onAddTap() async {
    print('result');

    final result = await Navigator.push(
      context,
      PageTransition(
        child: AddVariantColorScreen(),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 500),
      ),
    );


    if (result != null) {
      if (result is Map) {
        Color color = result['color'];
        String name = result['name'];
        setState(() {
          if (colorMaps.containsKey(name)) {

          } else {
            print(result);
            items.add(MultiSelectDialogItem(name, name));
            print(items);
          }
          colorMaps[name] = color;

        });
      }
    }

  }

  void _onSubmitTap() {
    Navigator.pop(context, [_selectedValues, colorMaps]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(widget.addButtonLabel),
          onPressed: _onAddTap,
        ),
        FlatButton(
          child: Text(widget.cancelButtonLabel),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text(widget.okButtonLabel),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Row(
        children: <Widget>[
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: colorMaps[item.value],
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1,
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(item.label),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.blue,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
