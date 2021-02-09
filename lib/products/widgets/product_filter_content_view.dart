import 'package:flutter/material.dart';
import 'package:payever/products/widgets/product_filter_range_content_view.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/models/enums.dart';

class ProductFilterContentView extends StatefulWidget {
  final Function onSelected;
  ProductFilterContentView({this.onSelected});
  @override
  _ProductFilterContentViewState createState() => _ProductFilterContentViewState();
}

class _ProductFilterContentViewState extends State<ProductFilterContentView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
              color: overlayColor(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Filter by:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(height: 0, thickness: 0, color: Colors.transparent,);
                  },
                  itemCount: filterProducts.keys.toList().length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        filterProducts[filterProducts.keys.toList()[index]],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        showMeDialog(context, filterProducts.keys.toList()[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showMeDialog(BuildContext context, String filterType) {
    String filtername = filterProducts[filterType];
    debugPrint('FilterTypeName => $filterType');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Filter by: $filtername',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: ProductFilterRangeContentView(
                type: filterType,
                onSelected: (value) {
                  Navigator.pop(context);
                  widget.onSelected(value);
                }
            ),
          );
        });
  }
}
