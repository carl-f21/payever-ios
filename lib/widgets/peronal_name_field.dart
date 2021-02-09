import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

import '../theme.dart';

class PersonalNameField extends StatefulWidget {
  final String salutation;
  final String firstName;
  final String lastName;
  final Function salutationChanged;
  final Function firstNameChanged;
  final Function lastNameChanged;
  final double height;

  const PersonalNameField(
      {this.salutation,
      this.firstName,
      this.lastName,
      this.salutationChanged,
      this.firstNameChanged,
      this.lastNameChanged,
      this.height = 65});

  @override
  _PersonalNameFieldState createState() => _PersonalNameFieldState();
}

class _PersonalNameFieldState extends State<PersonalNameField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Row(
        children: <Widget>[
          Flexible(
            child: BlurEffectView(
              color: overlayRow(),
              radius: 0,
              child: Container(
                height: widget.height,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 16, right: 8),
                child: DropdownButtonFormField(
                  items: List.generate(2, (index) {
                    return DropdownMenuItem(
                      child: Text(
                        Language.getConnectStrings(index == 0
                            ? 'user_business_form.form.contactDetails.salutation.options.SALUTATION_MR'
                            : 'user_business_form.form.contactDetails.salutation.options.SALUTATION_MRS'),
                      ),
                      value: index == 0 ? 'SALUTATION_MR' : 'SALUTATION_MRS',
                    );
                  }).toList(),
                  onChanged: (val) {
                    widget.salutationChanged(val);
                  },
                  value: widget.salutation != '' ? widget.salutation : null,
                  icon: Flexible(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  hint: Text(
                    Language.getSettingsStrings(
                        'form.create_form.contact.salutation.label'),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2),
          ),
          Flexible(
            child: BlurEffectView(
              color: overlayRow(),
              radius: 0,
              child: Container(
                height: widget.height,
                alignment: Alignment.center,
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  onChanged: (val) {
                    widget.firstNameChanged(val);
                  },
                  initialValue: widget.firstName ?? '',
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getCommerceOSStrings('forms.personal_create.firstName.label'),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'First name is required!';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2),
          ),
          Flexible(
            child: BlurEffectView(
              color: overlayRow(),
              radius: 0,
              child: Container(
                height: widget.height,
                alignment: Alignment.center,
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  onChanged: (val) {
                    widget.lastNameChanged(val);
                  },
                  textCapitalization: TextCapitalization.words,
                  initialValue: widget.lastName ?? '',
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    labelText: Language.getCommerceOSStrings('forms.personal_create.lastName.label'),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Last name is required!';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
