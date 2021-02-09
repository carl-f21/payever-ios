import 'package:flutter/material.dart';
import 'package:payever/dashboard/fake_dashboard_screen.dart';

class DashBoardBackGround extends StatefulWidget {
  final bool isLoading;

  const DashBoardBackGround({this.isLoading = false});
  @override
  _DashBoardBackGroundState createState() => _DashBoardBackGroundState();
}

class _DashBoardBackGroundState extends State<DashBoardBackGround> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://payever.azureedge.net/images/commerceos-background.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          widget.isLoading ? Container() : FakeDashboardScreen(),
        ],
      ),
    );
  }
}
