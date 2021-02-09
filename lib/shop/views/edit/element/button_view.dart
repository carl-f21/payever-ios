import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

import '../../../../theme.dart';

class ButtonView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ButtonView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});

  @override
  _ButtonViewState createState() => _ButtonViewState(child);
}

class _ButtonViewState extends State<ButtonView> {
  final Child child;

  _ButtonViewState(this.child);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    ButtonStyles styles;
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = ButtonStyles.fromJson(child.styles);
    } else {
      styles = styleSheet();
    }

//    if (styleSheet() != null) {
//      print(
//          'Button Styles Sheets: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
//    }
    if (styles == null ||
        styles.display == 'none' ||
        (styleSheet() != null && styleSheet().display == 'none'))
      return Container();

    return Container(
      width: styles.width,
      height: styles.height,
      decoration: BoxDecoration(
        color: colorConvert(styles.backgroundColor),
        borderRadius: BorderRadius.circular(styles.buttonBorderRadius()),
      ),
      margin: EdgeInsets.only(
          left: marginLeft(styles),
          right: styles.marginRight,
          top: marginTop(styles),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Text(
        Data.fromJson(child.data).text,
        style: TextStyle(
            color: colorConvert(styles.color),
            fontSize: styles.fontSize,
            fontWeight: styles.textFontWeight()),
      ),
    );
  }

  double marginTop(ButtonStyles styles) {
    double margin = styles.marginTop;
    int row = gridColumn(styles.gridRow);
    if (row == 1) return margin;
    List<String>rows = widget.sectionStyleSheet.gridTemplateRows.split(' ');
    for (int i = 0; i < row - 1; i ++)
      margin += double.parse(rows[i]);
    return margin;
  }

  double marginLeft(ButtonStyles styles) {
    double margin = styles.marginLeft;
    int column = gridColumn(styles.gridColumn);
    if (column == 1) return margin;
    List<String>columns = widget.sectionStyleSheet.gridTemplateColumns.split(' ');
    for (int i = 0; i < column - 1; i ++)
      margin += double.parse(columns[i]);
    return margin;
  }

  int gridRow(String _gridRow) {
    return int.parse(_gridRow.split(' ').first);
  }

  int gridColumn(String _gridColumn) {
    return int.parse(_gridColumn.split(' ').first);
  }

  ButtonStyles styleSheet() {
    try {
      return ButtonStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
