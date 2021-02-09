import 'package:flutter/material.dart';

import '../../theme.dart';


class ExportContentView extends StatefulWidget {
  final Function onSelectType;

  ExportContentView({this.onSelectType});

  @override
  _ExportContentViewState createState() => _ExportContentViewState();
}

class _ExportContentViewState extends State<ExportContentView> {
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 272,
      color: Colors.transparent,
        child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: BoxDecoration(
                  color: overlayFilterViewBackground(),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                  ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Format:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  ListTile(
                    title: Text(
                      'CSV',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    dense: true,
                    onTap: () {
                      widget.onSelectType(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'ODS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    dense: true,
                    onTap: () {
                      widget.onSelectType(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'XLS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    dense: true,
                    onTap: () {
                      widget.onSelectType(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    dense: true,
                    onTap: () {
                      widget.onSelectType(3);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
        ),
    ),
    );
  }
}
