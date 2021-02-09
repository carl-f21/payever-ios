import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';

import '../theme.dart';

class GoogleMapAddressField extends StatefulWidget {
  final String googleAutocomplete;
  final Function onChanged;
  final double height;
  const GoogleMapAddressField({this.googleAutocomplete, this.onChanged, this.height = 65});
  @override
  _GoogleMapAddressFieldState createState() => _GoogleMapAddressFieldState();
}

class _GoogleMapAddressFieldState extends State<GoogleMapAddressField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 16,
          ),
          SvgPicture.asset(
            'assets/images/google-auto-complete.svg',
            color: iconColor(),
          ),
          Expanded(
            child: TextFormField(
              style: textFieldStyle,
              initialValue: widget.googleAutocomplete ?? '',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              onChanged: (val) {
                widget.onChanged(val);
              },
              decoration: textFieldDecoration(Language.getSettingsStrings('form.create_form.address.google_autocomplete.label')),
            ),
          ),
        ],
      ),
    );
  }
}
