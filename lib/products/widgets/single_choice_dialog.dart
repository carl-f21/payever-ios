import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/views/add_variant_color_screen.dart';

typedef Widget ItemBuilder<T>(T item);
class SingleChoiceConfirmationDialog<T> extends StatefulWidget {
  final String initialSelectedValues;
  final String title;
  final String okButtonLabel;
  final String addButtonLabel;
  final String cancelButtonLabel;
  final Map<String, Color> colorMaps;

  SingleChoiceConfirmationDialog({
    Key key,
    this.initialSelectedValues,
    this.title,
    this.okButtonLabel,
    this.addButtonLabel,
    this.cancelButtonLabel,
    this.colorMaps,
  })  : super(key: key);

  @override
  _SingleChoiceConfirmationDialogState<T> createState() =>
      _SingleChoiceConfirmationDialogState<T>();
}

class _SingleChoiceConfirmationDialogState<T>
    extends State<SingleChoiceConfirmationDialog<T>> {
  T _chosenItem;

  String _selectedValue = '';
  Map<String, Color> colorMaps = {};
  List<VariantOption> items = [];

  @override
  void initState() {
    super.initState();
    colorMaps.addAll(widget.colorMaps);
    colorMaps.keys.forEach((item) {
      VariantOption option = VariantOption();
      option.name = item;
      option.value = item;
      items.add(option);
    });

    _selectedValue = widget.initialSelectedValues;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Color options'),
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
          child: Text('Add Color'),
          onPressed: _onAddTap,
        ),
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }


  Widget _buildItem(VariantOption item) {
    final checked = _selectedValue == item.value;
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
          Text(item.name),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.blue,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }

  void _onItemCheckedChange(String itemValue, bool checked) {
    setState(() {
      _selectedValue = itemValue;
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
            items.add(VariantOption(name: name, value: name));
            print(items);
          }
          colorMaps[name] = color;

        });
      }
    }

  }

  void _onSubmitTap() {
    Navigator.pop(context, [_selectedValue, colorMaps]);
  }

}
