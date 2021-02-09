import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/workshop/subview/instant_payment_view.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/app_style.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/libraries/credit_card_field.dart';
import 'package:payever/theme.dart';

class PaymentOptionCell extends StatefulWidget {
  final CheckoutPaymentOption paymentOption;
  final bool isSelected;
  final ChannelSetFlow channelSetFlow;
  final Function onTapChangePayment;
  final Function onChangeCredit;

  const PaymentOptionCell(
      {this.paymentOption,
      this.isSelected = false,
      this.onTapChangePayment,
      this.channelSetFlow,
      this.onChangeCredit
      });

  @override
  _PaymentOptionCellState createState() => _PaymentOptionCellState();
}

class _PaymentOptionCellState extends State<PaymentOptionCell> {

  TextEditingController creditCardController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expirationController = TextEditingController();

  void _submit() {
    if (widget.onChangeCredit == null) return;
    Map<String, dynamic> cardJson = {
      'number': creditCardController.text,
      'cvc': cvvController.text,
      'exp_month': int.tryParse(expirationController.text.substring(0, 2)),
      'exp_year': int.tryParse(expirationController.text.substring(3, 5)),
    };
    widget.onChangeCredit(cardJson);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: iconColor()),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                IconButton(
                    onPressed: () => widget.onTapChangePayment(widget.paymentOption.id),
                    icon: Icon(
                      widget.isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                    )),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    widget.paymentOption.name.contains('instant') ? 'Instant payment' : widget.paymentOption.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                paymentType(widget.paymentOption.paymentMethod),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          _expandedView,
        ],
      ),
    );
  }

  get _expandedView {
    BillingAddress billingAddress = widget.channelSetFlow.billingAddress;
    String name = '';
    if (billingAddress != null) {
      name =
      '${billingAddress.firstName ?? ''} ${billingAddress.lastName ?? ''}';
      if (name == ' ') name = '';
    }
    if (widget.paymentOption.paymentMethod == GlobalUtils.PAYMENT_CASH
        || widget.paymentOption.paymentMethod == GlobalUtils.PAYMENT_PAYPAL)
      return Container();

    if (widget.paymentOption.paymentMethod == GlobalUtils.PAYMENT_STRIPE)
      return _stripeWidget;

    return InstantPaymentView(
      isSelected: widget.isSelected,
      paymentMethod: widget.paymentOption.paymentMethod,
      name: name,
      iban: widget.channelSetFlow.businessIban,
      onChangedAds: (bool isCheckedAds){
        widget.paymentOption.isCheckedAds = isCheckedAds;
      },
      onChangedIban: (value) {
        widget.channelSetFlow.businessIban = value;
      },
      onChangedName: (value) {
        widget.channelSetFlow.billingAddress.firstName = value;
      },
    );
  }

  get _stripeWidget {
    if (!widget.isSelected) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlurEffectView(
            color: overlayColor(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            child: Container(
              height: 55,
              alignment: Alignment.center,
              child: CreditCardFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Credit Card Number",
                ),
                controller: creditCardController,
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Credit Card Number required';
                  }
                  return null;
                },
                onChanged: (){
                  _submit();
                },
              ),
            ),
          ),
          SizedBox(height: 2,),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                // Expanded(
                //   child: BlurEffectView(
                //     color: overlayColor(),
                //     borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(4),
                //     ),
                //     child: Container(
                //       height: 55,
                //       alignment: Alignment.center,
                //       child: TextFormField(
                //         style: textFieldStyle,
                //         onChanged: (val) {
                //
                //         },
                //         initialValue: widget.channelSetFlow.businessName,
                //         validator: (text) {
                //           if (text.isEmpty) {
                //             return 'iban required';
                //           }
                //           return null;
                //         },
                //         decoration: InputDecoration(
                //           border: OutlineInputBorder(),
                //           labelText: 'Account holder',
                //         ),
                //         keyboardType: TextInputType.text,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(width: 2,),
                Expanded(
                  child: BlurEffectView(
                    color: overlayColor(),
                    radius: 0,
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      child:ExpirationFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Card Expiration",
                          hintText: "MM/YY",
                        ),
                        controller: expirationController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Card Expiration required';
                          }
                          return null;
                        },
                        onChanged: (){
                          _submit();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2,),
                Expanded(
                  child: BlurEffectView(
                    color: overlayColor(),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(4),
                    ),
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      child: CVVFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "CVC",
                        ),
                        controller: cvvController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'CVC required';
                          }
                          return null;
                        },
                        onChanged: (){
                          _submit();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget paymentType(String type) {
    double size = AppStyle.iconRowSize(false);
    return SvgPicture.asset(
      Measurements.paymentType(type),
      height: size,
      color: Colors.red,
    );
  }
}
