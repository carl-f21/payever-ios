import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TextView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const TextView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});
  @override
  _TextViewState createState() => _TextViewState(child);
}

class _TextViewState extends State<TextView> {
  final Child child;

  _TextViewState(this.child);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    String txt = '';
    if (child.data is Map) {
      Data data = Data.fromJson(child.data);
      if (data.text != null) txt = data.text;
    } else {
      print('Data is not Map: ${child.data}');
    }
//    print('text value: $txt');

    if (txt.contains('<div') ||
        txt.contains('<span') ||
        txt.contains('<font')) {
      TextStyles styles = getStyles();

      if (styles == null || styles.display == 'none') {
        return Container();
      }

//      print('Html Text Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');

      return Container(
        color: colorConvert(styles.backgroundColor, emptyColor: true),
        width: styles.textWidth(),
        height: styles.height,
        alignment: styles.getTextContainAlign(),
        margin: EdgeInsets.only(
            left: marginLeft(styles),
            right: styles.marginRight,
            top: marginTop(styles),
            bottom: styles.marginBottom),
        child: HtmlWidget(
          // the first parameter (`html`) is required
          '''
            $txt
           ''',
          textStyle: TextStyle(
              fontSize: styles.textFontSize(),
              fontWeight: styles.textFontWeight()),
        )
        /*Html(
          data: """
              $txt
              """,
          onLinkTap: (url) {
            print("Opening $url...");
          },
        )*/,
      );
    }
    TextStyles styles;
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = TextStyles.fromJson(child.styles);
    } else {
      styles = getStyles();
    }
    if (styles == null || styles.display == 'none')
      return Container();

    print('Text Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');

    return Container(
      width: styles.textWidth(),
      height: styles.height,
      margin: EdgeInsets.only(
          left: marginLeft(styles),
          right: styles.marginRight,
          top: marginTop(styles),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Text(txt,
          style: TextStyle(
              color: colorConvert(styles.color),
              fontWeight: styles.textFontWeight(),
              fontSize: styles.textFontSize())),
    );
  }

  double marginTop(TextStyles styles) {
    double margin = styles.marginTop;
    int row = gridColumn(styles.gridRow);
    if (row == 1) return margin;
    List<String>rows = widget.sectionStyleSheet.gridTemplateRows.split(' ');
    for (int i = 0; i < row - 1; i ++)
      margin += double.parse(rows[i]);
    return margin;
  }

  double marginLeft(TextStyles styles) {
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

  TextStyles getStyles() {
    try {
      return TextStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
