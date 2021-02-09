import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/theme.dart';
import 'package:super_rich_text/super_rich_text.dart';

class InstantPaymentView extends StatefulWidget {
  final bool isSelected;
  final String name;
  final String iban;
  final String paymentMethod;
  final Function onChangedName;
  final Function onChangedIban;
  final Function onChangedAds;

  InstantPaymentView(
      {this.isSelected,
      this.name,
      this.iban,
      this.onChangedName,
      this.onChangedIban,
      this.onChangedAds,
      this.paymentMethod});

  @override
  _InstantPaymentViewState createState() => _InstantPaymentViewState();
}

class _InstantPaymentViewState extends State<InstantPaymentView> {
  TextEditingController birthdayController = TextEditingController();
  bool isChecked = false;
  DateTime birthDate;
  String birthday;
  String phone;

  @override
  Widget build(BuildContext context) {
    if (!widget.isSelected) {
      return Container();
    }

    return Column(
      children: [
        _inputFieldsWidget,
        _descriptionWidget,
      ],
    );
  }

  get _inputFieldsWidget {
    if (widget.paymentMethod == GlobalUtils.PAYMENT_INSTANT)
      return _instantInputWidget;

    if (widget.paymentMethod == GlobalUtils.PAYMENT_STRIPE_DIRECT)
      return _stripeDirectDebitWidget;

    if (widget.paymentMethod.contains('santander'))
      return _santanderInputWidget;

    return Container();
  }

  get _santanderInputWidget {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        children: <Widget>[
          BlurEffectView(
            color: overlayRow(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4)),
            child: Container(
              height: 55,
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      controller: birthdayController,
                      style: textFieldStyle,
                      onTap: () {

                      },
                      onChanged: (val) {
                        setState(() {
                          birthday = val;
                        });
                      },
                      decoration: textFieldDecoration(Language.getSettingsStrings(
                          'form.create_form.personal_information.birthday.label')),
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await showDatePicker(
                        context: context,
                        initialDate: birthDate ?? DateTime.now(),
                        firstDate: DateTime(1950, 1, 1),
                        lastDate: DateTime.now(),
                      );
                      if (result != null) {
                        setState(() {
                          birthDate = result;
                          birthdayController.text = birthDate != null
                              ? formatDate(
                              birthDate, [dd, '/', mm, '/', yyyy])
                              : '';
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SvgPicture.asset(
                        'assets/images/ic_calendar.svg',
                        width: 20,
                        height: 20,
                        color: iconColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2,),
          BlurEffectView(
            color: overlayRow(),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4)),
            child: Container(
              height: 55,
              alignment: Alignment.center,
              child: TextFormField(
                style: textFieldStyle,
                onChanged: (val) {
                  setState(() {
                    phone = val;
                  });
                },
                initialValue: phone ?? '',
                decoration: textFieldDecoration(Language.getSettingsStrings(
                    'Phone (optional)')),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  get _instantInputWidget {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        children: <Widget>[
          BlurEffectView(
            color: overlayRow(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4)),
            child: Container(
              height: 55,
              alignment: Alignment.center,
              child: TextFormField(
                style: textFieldStyle,
                onChanged: (val) => widget.onChangedName(val),
                initialValue: widget.name,
                validator: (text) {
                  if (text.isEmpty) {
                    return 'name required';
                  }
                  return null;
                },
                decoration: textFieldDecoration('Account holder'),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          SizedBox(height: 2,),
          BlurEffectView(
            color: overlayRow(),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4)),
            child: Container(
              height: 55,
              alignment: Alignment.center,
              child: TextFormField(
                style: textFieldStyle,
                onChanged: (val) => widget.onChangedIban(val),
                initialValue: widget.iban,
                validator: (text) {
                  if (text.isEmpty) {
                    return 'IBAN required';
                  }
                  return null;
                },
                decoration: textFieldDecoration('IBAN'),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  get _stripeDirectDebitWidget {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: BlurEffectView(
        color: overlayRow(),
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
          height: 55,
          alignment: Alignment.center,
          child: TextFormField(
            style: textFieldStyle,
            onChanged: (val) => widget.onChangedIban(val),
            initialValue: widget.iban,
            validator: (text) {
              if (text.isEmpty) {
                return 'iban required';
              }
              return null;
            },
            decoration: textFieldDecoration('IBAN'),
            keyboardType: TextInputType.text,
          ),
        ),
      ),
    );
  }

  get _descriptionWidget {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                setState(() {
                  isChecked = !isChecked;
                  widget.onChangedAds(isChecked);
                });
              },
              child: Icon(
                  isChecked
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  size: 24)),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: SuperRichText(
              text: (widget.paymentMethod == GlobalUtils.PAYMENT_INSTANT)
                  ? 'By clicking on the button below, personal data will be transmitted to Santander Consumer Bank AG for the purpose of reviewing creditworthiness - more information about this can be found in the &&data protection policy&&. The customer agrees to receive &&marketing communication&& by Santander. This voluntary consent can be revoked at any time.'
                  : 'By clicking on the button below you initiate a transfer of your personal data to Santander Consumer Bank AG for the purpose of carrying out the payment. For more information, see the Santander &&data policy&& for Santander instant payments. With ticking this box, the customer agrees to receive &&marketing communication&& from Santander. This consent is voluntary and may be revoked at any time.',
              style: TextStyle(fontSize: 14, color: iconColor()),
              othersMarkers: [
                MarkerText.withUrl(
                    marker: '&&',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    urls: [
                      'https://www.santander.de/static/datenschutzhinweise/direktueberweisung/',
                      'https://www.santander.de/static/datenschutzhinweise/rechnungskauf/werbehinweise.html'
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  get _divider {
    return Divider(
      height: 1,
      color: Colors.black54,
    );
  }
}
