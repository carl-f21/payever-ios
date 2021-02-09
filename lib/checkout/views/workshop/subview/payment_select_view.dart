import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/workshop/widget/payment_option.dart';
import 'package:payever/checkout/widgets/workshop_header_item.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/theme.dart';

class PaymentSelectView extends StatefulWidget {
  final bool enable;
  final bool approved;
  final bool expanded;
  final bool isUpdating;
  final Function onTapApprove;
  final Function onTapChangePayment;
  final Function onTapPay;
  final ChannelSetFlow channelSetFlow;
  final String subtitle;
  final Function onChangeCredit;

  const PaymentSelectView(
      {this.enable,
      this.approved,
      this.expanded,
      this.isUpdating,
      this.onTapApprove,
      this.onTapPay,
      this.channelSetFlow,
      this.onTapChangePayment,
      this.subtitle,
      this.onChangeCredit});

  @override
  _PaymentSelectViewState createState() => _PaymentSelectViewState();
}

class _PaymentSelectViewState extends State<PaymentSelectView> {

  @override
  Widget build(BuildContext context) {
    ChannelSetFlow channelSetFlow = widget.channelSetFlow;

    List<CheckoutPaymentOption> paymentOptions;
    num paymentOptionId;
    paymentOptions = channelSetFlow.paymentOptions;
    paymentOptionId = channelSetFlow.paymentOptionId;
    if (!widget.enable) {
      return Container();
    }
    bool noPymentOption = paymentOptions == null || paymentOptions.isEmpty;

    String payBtnTitle, paymentMethod;
    CheckoutPaymentOption paymentOption;
    if (!noPymentOption) {
      List<CheckoutPaymentOption>payments = paymentOptions.where((element) => element.id == paymentOptionId).toList();
      if (payments == null || payments.isEmpty) {
        payBtnTitle = 'Continue';
      } else {
        paymentOption = payments.first;
        paymentMethod = paymentOption.paymentMethod;
        if (paymentMethod == null) {
          payBtnTitle = 'Continue';
        } else if (paymentMethod.contains('santander')) {
          payBtnTitle =
          'Buy now for ${Measurements.currency(channelSetFlow.currency)}${channelSetFlow.amount}';
        } else if (paymentMethod == GlobalUtils.PAYMENT_CASH) {
          payBtnTitle = 'Pay now';
        } else if (paymentMethod == GlobalUtils.PAYMENT_INSTANT) {
          payBtnTitle = 'Pay';
        } else {
          payBtnTitle = 'Pay';
        }
      }
    }

    return Column(
      children: <Widget>[
        WorkshopHeader(
          title: 'SELECT PAYMENT',
          subTitle: widget.subtitle,
          isExpanded: widget.expanded,
          isApproved: widget.approved,
          onTap: () => widget.onTapApprove,
        ),
        Visibility(
          visible: widget.expanded,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              noPaymentOptionError(noPymentOption),
              noPymentOption ? Container() : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        CheckoutPaymentOption paymentOption = paymentOptions[index];
                        return PaymentOptionCell(
                          channelSetFlow: channelSetFlow,
                          paymentOption: paymentOption,
                          isSelected: paymentOptionId == paymentOption.id,
                          onTapChangePayment: (id) => widget.onTapChangePayment(id),
                          onChangeCredit: (Map cardJson){
                            widget.onChangeCredit(cardJson);
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 0,
                          height: 10,
                          color: Colors.transparent,
                        );
                      },
                      itemCount: paymentOptions.length),
                  Container(
                    height: 41,
                    child: SizedBox.expand(
                      child: InkWell(
                        onTap: () {
                          if (paymentMethod == null || paymentMethod.isEmpty) return;
                          Map<String, dynamic>body = _getPaymentRequestBody(paymentMethod, paymentOption);
                          widget.onTapPay(body);
                        },
                        child: Container(
                          decoration: overlayBtnDecoration(),
                          alignment: Alignment.center,
                          child: widget.isUpdating
                              ? Center(
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    backgroundColor: GlobalUtils.theme == 'light' ? Colors.white : Colors.black,
                                  )))
                              : Text(
                            payBtnTitle ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: GlobalUtils.theme == 'light' ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ],
    );

  }

  Widget noPaymentOptionError(bool noPymentOption) {
    return Visibility(
      visible: noPymentOption,
      child: BlurEffectView(
        borderRadius: BorderRadius.circular(4),
        color: overlayColor(),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.red, size: 40,),
              SizedBox(width: 20,),
              Flexible(child: Text('Unfortunately no payment options available. It could be that the order amount is too low/high for the available payment options, or you entered an alternative shipping address (not allowed for some payment options).'))
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getPaymentRequestBody(
      String paymentMethod, CheckoutPaymentOption paymentOption) {
    ChannelSetFlow channelSetFlow = widget.channelSetFlow;
    BillingAddress billingAddress = channelSetFlow.billingAddress;
    Map<String, dynamic> body = {};
    if (paymentMethod == GlobalUtils.PAYMENT_CASH) return {};
    if (billingAddress == null) return {};

    Map<String, dynamic> address = {
      'city': billingAddress.city,
      'country': billingAddress.country,
      'email': billingAddress.email,
      'firstName': billingAddress.firstName,
      'lastName': billingAddress.lastName,
      'phone': billingAddress.phone,
      'salutation': billingAddress.salutation,
      'street': billingAddress.street,
      'zipCode': billingAddress.zipCode,
    };

    Map<String, dynamic> payment = {
      'address': address,
      'amount': channelSetFlow.amount,
      'apiCallId': channelSetFlow.apiCallId,
      'businessId': channelSetFlow.businessId,
      'businessName': channelSetFlow.businessName,
      'channel': channelSetFlow.channel,
      'channelSetId': channelSetFlow.channelSetId,
      'currency': channelSetFlow.currency,
      'customerEmail': billingAddress.email,
      'customerName': '${billingAddress.firstName} ${billingAddress.lastName}',
      'deliveryFee': channelSetFlow.shippingFee ?? 0,
      'flowId': channelSetFlow.id,
      'reference': channelSetFlow.reference,
      'shippingAddress': null /*channelSetFlow.shippingAddresses*/,
      'total': channelSetFlow.total
    };

    Map<String, dynamic> paymentDetails = {};
    if (paymentMethod == GlobalUtils.PAYMENT_INSTANT) {
      paymentDetails = {
        'adsAgreement': paymentOption.isCheckedAds ?? false,
        'recipientHolder': channelSetFlow.businessName,
        'recipientIban': channelSetFlow.businessIban,
        'senderHolder':
            '${billingAddress.firstName} ${billingAddress.lastName}',
        'senderIban': channelSetFlow.businessIban,
      };
    } else if (paymentMethod == GlobalUtils.PAYMENT_PAYPAL) {
      paymentDetails = {
        'frontendCancelUrl':
            '${Env.wrapper}/pay/${channelSetFlow.id}/redirect-to-choose-payment',
        'frontendFinishUrl':
            '${Env.wrapper}/pay/${channelSetFlow.id}/redirect-to-payment',
      };
    } else if (paymentMethod == GlobalUtils.PAYMENT_STRIPE_DIRECT) {
      paymentDetails = {'iban': channelSetFlow.businessIban};
    } else if (paymentMethod == GlobalUtils.PAYMENT_STRIPE) {
      paymentDetails = {
        'postbackUrl':
            '${Env.wrapper}/pay/${channelSetFlow.id}/stripe-postback',
        'tokenId': ''
      };
    } else {
      paymentDetails = {
        'adsAgreement': paymentOption.isCheckedAds ?? false,
        'recipientHolder': channelSetFlow.businessName,
        'recipientIban': channelSetFlow.businessIban,
        'senderHolder':
        '${billingAddress.firstName} ${billingAddress.lastName}',
        'senderIban': channelSetFlow.businessIban,
      };
    }

    // List<dynamic>paymentItems = [];

    body['payment'] = payment;
    body['paymentDetails'] = paymentDetails;
    body['paymentItems'] = [];

    return body;
  }

  Color overlayBtnBackground() {
    if (GlobalUtils.theme == 'dark') {
      return Color.fromRGBO(0, 0, 0, 0.3);
    } else if (GlobalUtils.theme == 'light') {
      return Color.fromRGBO(245, 245, 245, 0.6);
    } else {
      return Color.fromRGBO(0, 0, 0, 0.2);
    }
  }

  BoxDecoration overlayBtnDecoration() {
    if (GlobalUtils.theme == 'dark') {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(237, 237, 244, 1),
              Color.fromRGBO(174, 176, 183, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
      );
    } else if (GlobalUtils.theme == 'light') {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color.fromRGBO(44, 44, 44, 0.95),
      );
    }
    return BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: overlayBtnBackground(),
    );
  }
}
