import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/contacts/widgets/contact_item_image_view.dart';

class ContactGridAddItem extends StatelessWidget {
  final Function onAdd;

  ContactGridAddItem({
    this.onAdd,
  });

  final String groupPlaceholder = 'https://payeverstage.azureedge.net/placeholders/group-placeholder.png';


  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Color.fromRGBO(0, 0, 0, 0.3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ContactItemImageView(
                groupPlaceholder,
              ),
            ),
            AspectRatio(
              aspectRatio: 6/1,
              child: Container(
                width: double.infinity,
                color: Color.fromRGBO(0, 0, 0, 0.3),
                alignment: Alignment.center,
                child: SizedBox.expand(
                  child: MaterialButton(
                    child: Text(
                      'Add Contact',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: onAdd,
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}