import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';

class CheckoutSectionScreenEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class CheckoutSectionScreenInitEvent extends CheckoutSectionScreenEvent {
  final String businessId;

  CheckoutSectionScreenInitEvent({
    this.businessId,
  });

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class UpdateCheckoutSectionsEvent extends CheckoutSectionScreenEvent {
  final String businessId;
  final Checkout checkout;

  UpdateCheckoutSectionsEvent({this.businessId, this.checkout,});
}