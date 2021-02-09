import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/contacts/models/model.dart';

class ContactListItem extends StatelessWidget {
  final Function onTap;
  final Function onOpen;
  final bool isPortrait;
  final bool isTablet;
  final ContactModel contact;

  ContactListItem({
    this.onTap,
    this.onOpen,
    this.isTablet = false,
    this.isPortrait = true,
    this.contact,
  });

  @override
  Widget build(BuildContext context) {
    double margin = isTablet ? 24: 16;
    String email = '';
    String firstName = '';
    String lastName = '';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 66,
        padding: EdgeInsets.only(left: margin, right: margin),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: contact.isChecked ? Icon(
                Icons.check_circle_outline,
                size: 24,
              ) : Icon(
                Icons.radio_button_unchecked,
                size: 24,
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SvgPicture.asset(Measurements.channelIcon('iconType'), width: 32, color: Colors.white70,),
                  ),
                  Expanded(
                    child: Text(
                      '$firstName $lastName',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeueMed',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6),
            ),
            isTablet || !isPortrait ? Container(
              width: Measurements.width * (isPortrait ? 0.1 : 0.2),
              child: Text(
                email,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'HelveticaNeueMed',
                  fontSize: 14,
                ),
              ),
            ): Container(),
            isTablet || !isPortrait ? Padding(
              padding: EdgeInsets.only(left: 6),
            ): Container(),
            Container(
              width: !isTablet && isPortrait ? null : Measurements.width * (isTablet ? (isPortrait ? 0.15 : 0.2) : (isPortrait ? null: 0.35)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    child: MaterialButton(
                      onPressed: onOpen,
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                      height: 26,
                      minWidth: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      elevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      hoverElevation: 0,
                      child: Text(
                        Language.getPosConnectStrings('integrations.actions.open'),
                        style: TextStyle(
                          fontFamily: 'HelveticaNeueMed',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}