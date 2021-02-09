import 'package:flutter/material.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/models/enums.dart';

class SortContentView extends StatelessWidget {
  final String selectedIndex;
  final Function onSelected;

  SortContentView({this.selectedIndex, this.onSelected});

  @override
  Widget build(BuildContext context) {
    print(selectedIndex);
    return Container(
      height: 230,
      color: Colors.transparent, //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 30,),
                  Text(
                    'Sort by:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  onSelected(sortTransactions.keys.toList()[0]);
                },
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      alignment: Alignment.center,
                      child: selectedIndex != sortTransactions.keys.toList()[0] ? Container() : Icon(
                        Icons.check,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sortTransactions[sortTransactions.keys.toList()[0]],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  onSelected(sortTransactions.keys.toList()[1]);
                },
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 24,
                      child: selectedIndex != sortTransactions.keys.toList()[1] ? Container() : Icon(
                        Icons.check,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sortTransactions[sortTransactions.keys.toList()[1]],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  onSelected(sortTransactions.keys.toList()[2]);
                },
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      alignment: Alignment.center,
                      child: selectedIndex != sortTransactions.keys.toList()[2] ? Container() : Icon(
                        Icons.check,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sortTransactions[sortTransactions.keys.toList()[2]],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  onSelected(sortTransactions.keys.toList()[3]);
                },
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      alignment: Alignment.center,
                      child: selectedIndex != sortTransactions.keys.toList()[3] ? Container() : Icon(
                        Icons.check,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sortTransactions[sortTransactions.keys.toList()[3]],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
