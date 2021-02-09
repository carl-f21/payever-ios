import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:super_rich_text/super_rich_text.dart';

import '../../theme.dart';

class SelectLanguage extends StatefulWidget {
  final bool isRegister;

  const SelectLanguage({this.isRegister = true});

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {

  @override
  Widget build(BuildContext context) {
    Alignment _alignment = (widget.isRegister && GlobalUtils.isTablet(context))? Alignment.bottomRight : Alignment.bottomCenter;
    double rightMargin = (widget.isRegister && GlobalUtils.isTablet(context))? 16 : 0;
    return Container(
      alignment: _alignment,
      margin: EdgeInsets.fromLTRB(0, 0, rightMargin, 0),
      child: Container(
        width: 60,
        height: 40,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Container(
          height: 30,
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                value: 'EN',
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withAlpha(160),
                  size: 18,
                ),
                elevation: 4,
                style:
                TextStyle(fontSize: 12),
                dropdownColor: Color.fromRGBO(0, 0, 0, 0.6),
                underline: Container(),
                onChanged: (val) {},
                items: <String>['EN', 'DE', 'NR', 'PL', 'UK']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget tabletTermsOfService(bool _isTablet) {
  return _isTablet ? Container(
    margin: EdgeInsets.only(bottom: 20),
    alignment: Alignment.bottomCenter,
    width: 370,
    child: termsOfServiceNote(),
  ) : Container();
}

Widget termsOfServiceNote() {
  return  SuperRichText(
    text:
    'By registering you agree to payever llTerms of Servicell and have read the llPrivacy Policyll',
    style: TextStyle(color: iconColor(), fontSize: 14),
    textAlign: TextAlign.center,
    othersMarkers: [
      MarkerText.withUrl(
          marker: 'll',
          style: TextStyle(color: iconColor(), fontWeight: FontWeight.bold),
          urls: [GlobalUtils.termsLink, GlobalUtils.privacyLink]),
    ],
  );
}