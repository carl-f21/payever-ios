import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/contacts/models/model.dart';
import 'package:payever/theme.dart';

class ContactOptionContentView extends StatefulWidget {
  final Function onAddNewField;
  final Function onSelectPrevious;
  final List<Field> fields;

  ContactOptionContentView({
    this.onAddNewField,
    this.onSelectPrevious,
    this.fields = const [],
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactOptionContentViewState();
  }
}

class _ContactOptionContentViewState extends State<ContactOptionContentView> {

  bool isPrevious = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double height = (isPrevious ? 64 * widget.fields.length :  64 * 2) + MediaQuery.of(context).padding.bottom;
    if (height > (Measurements.height / 2.0)) {
      height = Measurements.height / 2.0;
    }
    return Container(
      height: height,
      padding: EdgeInsets.all(16),
      child: isPrevious ? ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              widget.onSelectPrevious(widget.fields[index]);
            },
            title: Text(
              widget.fields[index].name,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 0, thickness: 0.5, color: Colors.white38,);
        },
        itemCount: widget.fields.length,
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            onTap: (){
              widget.onAddNewField();
            },
            title: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 8),
                  width: 24,
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/images/add.svg', color: iconColor(),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Text(
                  'Add field',
                ),
              ],
            ),
            dense: true,
          ),
          ListTile(
            onTap: (){
              setState(() {
                isPrevious = true;
              });
            },
            title: Text(
              'Choose previous option',
            ),
            dense: true,
          ),
        ],
      ),
    );
  }
}
