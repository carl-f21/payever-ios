import 'package:flutter/material.dart';

class SectionDetailItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isDisable;

  const SectionDetailItem(
      {this.title, this.isSelected, this.isDisable = false});

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? SectionDetailsItem(
            title: this.title,
            isDisable: this.isDisable,
          )
        : Container();
  }
}

class SectionDetailsItem extends StatefulWidget {
  final String title;
  final bool isDisable;

  const SectionDetailsItem({this.title, this.isDisable});

  @override
  _SectionDetailsItemState createState() => _SectionDetailsItemState();
}

class _SectionDetailsItemState extends State<SectionDetailsItem> {
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return isDisabled
        ? Container()
        : Container(
            height: 60,
            color: Colors.black26,
            child: Row(
              children: <Widget>[
                widget.isDisable
                    ? Container(
                        width: 60,
                        child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isDisabled = true;
                              });
                            }),
                      )
                    : SizedBox(
                        width: 60,
                      ),
                Text(
                  widget.title,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Spacer(),
                IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {}),
              ],
            ),
          );
  }
}
