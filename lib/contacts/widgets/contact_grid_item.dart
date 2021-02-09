import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/contacts/models/model.dart';
import 'package:payever/contacts/widgets/contact_item_image_view.dart';
import 'package:payever/theme.dart';

class ContactGridItem extends StatelessWidget {
  final Function onTap;
  final Function onOpen;
  final ContactModel contact;

  ContactGridItem({
    this.onTap,
    this.onOpen,
    this.contact,
  });

  final String groupPlaceholder = 'https://payeverstage.azureedge.net/placeholders/group-placeholder.png';
  final String contactPlaceholder = 'https://payeverstage.azureedge.net/placeholders/contact-placeholder.png';


  @override
  Widget build(BuildContext context) {
    String email = '';
    String firstName = '';
    String lastName = '';
    String image = '';
    List<ContactField> emailFields = contact.contact.contactFields.nodes.where((element) {
      return element.field.name == 'email';
    }).toList();
    if (emailFields.length > 0) {
      email = emailFields.first.value;
    }

    List<ContactField> firstNameFields = contact.contact.contactFields.nodes.where((element) {
      return element.field.name == 'firstName';
    }).toList();
    if (firstNameFields.length > 0) {
      firstName = firstNameFields.first.value;
    }

    List<ContactField> lastNameFields = contact.contact.contactFields.nodes.where((element) {
      return element.field.name == 'lastName';
    }).toList();
    if (lastNameFields.length > 0) {
      lastName = lastNameFields.first.value;
    }

    List<ContactField> imageFields = contact.contact.contactFields.nodes.where((element) {
      return element.field.name == 'imageUrl';
    }).toList();
    if (imageFields.length > 0) {
      image = imageFields.first.value;
    }

    return GestureDetector(
      onTap: () {
        onTap(contact);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Color.fromRGBO(0, 0, 0, 0.3),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ContactItemImageView(
                    image == '' ? contactPlaceholder : image,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 6/1.67,
                      child: Container(
                        width:double.infinity,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              '$firstName $lastName',
                              maxLines: 1,
                              minFontSize: 8,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto-Medium'
                              ),
                            ),
                            SizedBox(height: 4,),
                            AutoSizeText(
                              email,
                              maxLines: 1,
                              minFontSize: 8,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'Roboto'
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 6/1,
                      child: Container(
                        width: double.infinity,
                        color: overlayBackground(),
                        alignment: Alignment.center,
                        child: SizedBox.expand(
                          child: MaterialButton(
                              child: Text(
                                'Open',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              onPressed: (){
                              onOpen(contact);
                            }
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 24,
              width: 24,
              alignment: Alignment.center,
              child: contact.isChecked ? Icon(
                Icons.check_circle_outline,
                size: 24,
              ) : Icon(
                Icons.radio_button_unchecked,
                color: Colors.white60,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}