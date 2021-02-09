import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/connect/models/connect.dart';

import '../../../../theme.dart';

class PaySuccessView extends StatefulWidget {
  final ChannelSetFlow channelSetFlow;
  final WorkshopScreenBloc screenBloc;

  PaySuccessView({this.channelSetFlow, this.screenBloc});

  @override
  _PaySuccessViewState createState() =>
      _PaySuccessViewState(channelSetFlow: this.channelSetFlow);
}

class _PaySuccessViewState extends State<PaySuccessView> {
  final ChannelSetFlow channelSetFlow;
  Payment payment;
  PaymentDetails paymentDetails;

  _PaySuccessViewState({this.channelSetFlow}) {
    payment = this.channelSetFlow.payment;
    if (payment != null) {
      paymentDetails = payment.paymentDetails;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkshopScreenBloc, WorkshopScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, state) {
          return _body;
        });
  }

  get _body {
    List<CheckoutPaymentOption> payments = channelSetFlow.paymentOptions
        .where((element) => element.id == channelSetFlow.paymentOptionId)
        .toList();
    String paymentMethod = payments.first.paymentMethod;
    bool cash = paymentMethod == 'cash';

    return Center(
      child: BlurEffectView(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Icon(
                Icons.check,
                size: 30,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Text(
                'Thank you! Your order has been placed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              cash ? _wireTransferWidget
               : _thirdPartyPaymentWidget,
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  widget.screenBloc.add(RefreshWorkShopEvent());
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 24,
                elevation: 0,
                minWidth: 0,
                color: overlayBackground(),
                child: Text(
                  Language.getSettingsStrings('actions.yes'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  get _wireTransferWidget {
    NumberFormat format = NumberFormat();
    String currency =
    format.simpleCurrencySymbol(widget.channelSetFlow.currency);

    DateTime paymentDate = DateTime.parse(payment.createdAt);
    String paymentDataStr = formatDate(
        paymentDate, [dd, '.', mm, '.', yyyy, ' ', hh, ':', mm, ':', ss]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Total',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                      '$currency${widget.channelSetFlow.total.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: _divider,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Recipient',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                      paymentDetails.merchantBankAccountHolder ??
                          '',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Name of the bank',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(paymentDetails.merchantBankName,
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'City of the bank',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(paymentDetails.merchantBankCity,
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'IBAN',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(payment.bankAccount.iban,
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'BIC',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(payment.bankAccount.bic,
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: _divider,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Text(
                paymentDetails.merchantCompanyName,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Text(paymentDataStr, style: TextStyle(fontSize: 16)),
          ],
        ),
        Container(
            width: double.infinity,
            child: Text(
                widget.channelSetFlow.billingAddress.fullAddress,
                style: TextStyle(fontSize: 16))),
        SizedBox(
          height: 40,
        ),
        Text('Reference',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold)),
        Text(widget.channelSetFlow.reference,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  get _thirdPartyPaymentWidget {
      PayResult payResult = widget.screenBloc.state.payResult;
      if (payResult == null)
        return Container();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 30,),
          Flexible(child: Text('You can view the SEPA direct debit mandate here:')),
          SizedBox(height: 20,),
          Text(payResult.paymentDetails.mandateReference, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
        ],
      );
  }

  get _divider {
    return Divider(
      height: 0,
      thickness: 0.5,
      color: iconColor(),
    );
  }
}
