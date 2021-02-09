import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payever/commons/utils/draggable_widget.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/template_view.dart';

class TemplateDetailScreen extends StatefulWidget {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;

  const TemplateDetailScreen({this.shopPage, this.template, this.stylesheets});

  @override
  _TemplateDetailScreenState createState() => _TemplateDetailScreenState(shopPage, template, stylesheets);
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;
  DragController dragController = DragController();
  int count = 0;
  _TemplateDetailScreenState(this.shopPage, this.template, this.stylesheets);
  StreamController<double> controller = StreamController.broadcast();
  double position;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(shopPage.name),
        body: SafeArea(
          child: /*_dragSize()*/TemplateView(
            shopPage: shopPage,
            template: template,
            stylesheets: stylesheets,
          ),
        ));
  }

  Widget _dragSize() {
    return StreamBuilder(
      stream: controller.stream,
      builder: (context, snapshot) => Container(
        alignment: Alignment.bottomCenter,
        color: Colors.red,
        height: snapshot.hasData ? snapshot.data : 200.0,
        width: double.infinity,
        child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              position = /*MediaQuery.of(context).size.height -*/
              details.globalPosition.dy;
              print('position dy = ${position}');
              position.isNegative
                  ? Navigator.pop(context)
                  : controller.add(position);
            },
            behavior: HitTestBehavior.translucent,
            child: Text('Child')),
      ),
    );
  }

  Widget _draggable() {
    return Container(
      color: Colors.white,
      child: Stack(
          children:[
            // other widgets...
            DraggableWidget(
              bottomMargin: 80,
              topMargin: 80,
              intialVisibility: true,
              horizontalSapce: 20,
              shadowBorderRadius: 50,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
              initialPosition: AnchoringPosition.topLeft,
              dragController: dragController,
            )
          ]
      ),
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Draggable(
              child: buildBox("+1", Colors.red[200]),
              feedback: buildBox("+1", Colors.red[200]),
              childWhenDragging: buildBox("+1", Colors.grey[300]),
              data: 1,
              onDragStarted: (){
                print("onDragStarted");
              },
              onDragCompleted: (){
                print("onDragCompleted");
              },
              onDragEnd: (details){
                print("onDragEnd Accept = "+details.wasAccepted.toString());
                print("onDragEnd Velocity = "+details.velocity.pixelsPerSecond.distance.toString());
                print("onDragEnd Offeset= "+details.offset.direction.toString());
              },
              onDraggableCanceled: (Velocity velocity, Offset offset){
                print("onDraggableCanceled "+velocity.toString());
              },
            ),
            Draggable(
              child: buildBox("-1", Colors.blue[200]),
              feedback: buildBox("-1", Colors.blue[200]),
              childWhenDragging: buildBox("-1", Colors.blue[300]),
              data: -1,
            )
          ]),
          DragTarget(
            builder: (BuildContext context, List<int> candidateData,
                List<dynamic> rejectedData) {
              print("candidateData = " +
                  candidateData.toString() +
                  " , rejectedData = " +
                  rejectedData.toString());
              return buildBox("$count", Colors.green[200]);
            },
            onWillAccept: (data) {
              print("onWillAccept");
              return data == 1 || data == -1; // accept when data = 1 only.
            },
            onAccept: (data) {
              print("onAccept");
              count += data;
            },
            onLeave: (data) {
              print("onLeave");
            },
          )
        ],
      ),
    );
  }

  Container buildBox(String title, Color color) {
    return Container(
        width: 100,
        height: 100,
        color: color,
        child: Center(
            child: Text(title,
                style: TextStyle(fontSize: 18, color: Colors.black))));
  }
}


