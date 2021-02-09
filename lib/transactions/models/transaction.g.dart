// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Month _$MonthFromJson(Map<String, dynamic> json) {
  return Month()
    ..date = json['date'] as String
    ..amount = json['amount'] as num
    ..currency = json['currency'] as String;
}

Map<String, dynamic> _$MonthToJson(Month instance) => <String, dynamic>{
      'date': instance.date,
      'amount': instance.amount,
      'currency': instance.currency,
    };

Day _$DayFromJson(Map<String, dynamic> json) {
  return Day()
    ..date = json['date'] as String
    ..amount = json['amount'] as num
    ..currency = json['currency'] as String;
}

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'date': instance.date,
      'amount': instance.amount,
      'currency': instance.currency,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction()
    ..collection = (json['collection'] as List)
        ?.map((e) =>
            e == null ? null : Collection.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..paginationData = json['pagination_data'] == null
        ? null
        : PaginationData.fromJson(
            json['pagination_data'] as Map<String, dynamic>)
    ..usages = json['usage'] == null
        ? null
        : Usages.fromJson(json['usage'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'collection': instance.collection,
      'pagination_data': instance.paginationData,
      'usage': instance.usages,
    };

Collection _$CollectionFromJson(Map<String, dynamic> json) {
  return Collection()
    ..actionRunning = json['action_running'] as bool
    ..amount = json['amount'] as num
    ..billingAddress = json['billing_address'] == null
        ? null
        : BillingAddress.fromJson(
            json['billing_address'] as Map<String, dynamic>)
    ..businessOptionId = json['business_option_id'] as int
    ..businessUuid = json['business_uuid'] as String
    ..channel = json['channel'] as String
    ..channelSetUuid = json['channel_set_uuid'] as String
    ..createdAt = json['created_at'] as String
    ..currency = json['currency'] as String
    ..customerEmail = json['customer_email'] as String
    ..customerName = json['customer_name'] as String
    ..history = (json['history'] as List)
        ?.map((e) =>
            e == null ? null : TDHistory.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..merchantEmail = json['merchant_email'] as String
    ..merchantName = json['merchant_name'] as String
    ..originalId = json['original_id'] as String
    ..paymentFlowId = json['payment_flow_id'] as String
    ..place = json['place'] as String
    ..reference = json['reference'] as String
    ..santanderApplications = (json['santander_applications'] as List)
        ?.map((e) => e as String)
        ?.toList()
    ..status = json['status'] as String
    ..total = json['total'] as num
    ..type = json['type'] as String
    ..updatedAt = json['updated_at'] as String
    ..uuid = json['uuid'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'action_running': instance.actionRunning,
      'amount': instance.amount,
      'billing_address': instance.billingAddress,
      'business_option_id': instance.businessOptionId,
      'business_uuid': instance.businessUuid,
      'channel': instance.channel,
      'channel_set_uuid': instance.channelSetUuid,
      'created_at': instance.createdAt,
      'currency': instance.currency,
      'customer_email': instance.customerEmail,
      'customer_name': instance.customerName,
      'history': instance.history,
      'merchant_email': instance.merchantEmail,
      'merchant_name': instance.merchantName,
      'original_id': instance.originalId,
      'payment_flow_id': instance.paymentFlowId,
      'place': instance.place,
      'reference': instance.reference,
      'santander_applications': instance.santanderApplications,
      'status': instance.status,
      'total': instance.total,
      'type': instance.type,
      'updated_at': instance.updatedAt,
      'uuid': instance.uuid,
      '_id': instance.id,
    };

BillingAddress _$BillingAddressFromJson(Map<String, dynamic> json) {
  return BillingAddress()
    ..city = json['city'] as String
    ..country = json['country'] as String
    ..countryName = json['country_name'] as String
    ..email = json['email'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..salutation = json['salutation'] as String
    ..street = json['street'] as String
    ..zipCode = json['zip_code'] as String
    ..id = json['id'] as String
    ..company = json['company'] as String
    ..fullAddress = json['full_address'] as String
    ..phone = json['phone'] as String
    ..socialSecurityNumber = json['social_security_number'] as String
    ..streetName = json['street_name'] as String
    ..streetNumber = json['street_number'] as String
    ..type = json['type'] as String
    ..userUuid = json['user_uuid'] as String;
}

Map<String, dynamic> _$BillingAddressToJson(BillingAddress instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'country_name': instance.countryName,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'salutation': instance.salutation,
      'street': instance.street,
      'zip_code': instance.zipCode,
      'id': instance.id,
      'company': instance.company,
      'full_address': instance.fullAddress,
      'phone': instance.phone,
      'social_security_number': instance.socialSecurityNumber,
      'street_name': instance.streetName,
      'street_number': instance.streetNumber,
      'type': instance.type,
      'user_uuid': instance.userUuid,
    };

PaginationData _$PaginationDataFromJson(Map<String, dynamic> json) {
  return PaginationData()
    ..page = json['page'] as num
    ..total = json['total'] as num
    ..amount = json['amount'] as num
    ..currency = json['amount_currency'] as String;
}

Map<String, dynamic> _$PaginationDataToJson(PaginationData instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total': instance.total,
      'amount': instance.amount,
      'amount_currency': instance.currency,
    };

Usages _$UsagesFromJson(Map<String, dynamic> json) {
  return Usages()
    ..specificStatuses =
        (json['specific_statuses'] as List)?.map((e) => e as String)?.toList()
    ..statuses = (json['statuses'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$UsagesToJson(Usages instance) => <String, dynamic>{
      'specific_statuses': instance.specificStatuses,
      'statuses': instance.statuses,
    };

TransactionDetails _$TransactionDetailsFromJson(Map<String, dynamic> json) {
  return TransactionDetails()
    ..actions = (json['actions'] as List)
        ?.map((e) =>
            e == null ? null : Actions.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..billingAddress = json['billing_address'] == null
        ? null
        : TDBillingAddress.fromJson(
            json['billing_address'] as Map<String, dynamic>)
    ..business = json['business'] == null
        ? null
        : BusinessUUid.fromJson(json['business'] as Map<String, dynamic>)
    ..cart = json['cart'] == null
        ? null
        : CartItems.fromJson(json['cart'] as Map<String, dynamic>)
    ..channel = json['channel'] == null
        ? null
        : TDChannel.fromJson(json['channel'] as Map<String, dynamic>)
    ..channelSet = json['channel_set'] == null
        ? null
        : TDChannelSet.fromJson(json['channel_set'] as Map<String, dynamic>)
    ..customer = json['customer'] == null
        ? null
        : Customer.fromJson(json['customer'] as Map<String, dynamic>)
    ..details = json['details'] == null
        ? null
        : TDDetails.fromJson(json['details'] as Map<String, dynamic>)
    ..history = (json['history'] as List)
        ?.map((e) =>
            e == null ? null : TDHistory.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..merchant = json['merchant'] == null
        ? null
        : Merchant.fromJson(json['merchant'] as Map<String, dynamic>)
    ..paymentFlow = json['payment_flow'] == null
        ? null
        : PaymentFlow.fromJson(json['payment_flow'] as Map<String, dynamic>)
    ..paymentOption = json['payment_option'] == null
        ? null
        : PaymentOption.fromJson(json['payment_option'] as Map<String, dynamic>)
    ..shipping = json['shipping'] == null
        ? null
        : ShippingOption.fromJson(json['shipping'] as Map<String, dynamic>)
    ..status = json['status'] == null
        ? null
        : Status.fromJson(json['status'] as Map<String, dynamic>)
    ..store = json['store'] == null
        ? null
        : Store.fromJson(json['store'] as Map<String, dynamic>)
    ..transaction = json['transaction'] == null
        ? null
        : TDTransaction.fromJson(json['transaction'] as Map<String, dynamic>)
    ..userId = json['user'] == null
        ? null
        : UserId.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TransactionDetailsToJson(TransactionDetails instance) =>
    <String, dynamic>{
      'actions': instance.actions,
      'billing_address': instance.billingAddress,
      'business': instance.business,
      'cart': instance.cart,
      'channel': instance.channel,
      'channel_set': instance.channelSet,
      'customer': instance.customer,
      'details': instance.details,
      'history': instance.history,
      'merchant': instance.merchant,
      'payment_flow': instance.paymentFlow,
      'payment_option': instance.paymentOption,
      'shipping': instance.shipping,
      'status': instance.status,
      'store': instance.store,
      'transaction': instance.transaction,
      'user': instance.userId,
    };

Actions _$ActionsFromJson(Map<String, dynamic> json) {
  return Actions()
    ..action = json['action'] as String
    ..enabled = json['enabled'] as bool;
}

Map<String, dynamic> _$ActionsToJson(Actions instance) => <String, dynamic>{
      'action': instance.action,
      'enabled': instance.enabled,
    };

TDBillingAddress _$TDBillingAddressFromJson(Map<String, dynamic> json) {
  return TDBillingAddress()
    ..city = json['city'] as String
    ..country = json['country'] as String
    ..countryName = json['country_name'] as String
    ..email = json['email'] as String
    ..firstName = json['first_name'] as String
    ..id = json['id'] as String
    ..lastName = json['last_name'] as String
    ..salutation = json['salutation'] as String
    ..street = json['street'] as String
    ..zipCode = json['zip_code'] as String;
}

Map<String, dynamic> _$TDBillingAddressToJson(TDBillingAddress instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'country_name': instance.countryName,
      'email': instance.email,
      'first_name': instance.firstName,
      'id': instance.id,
      'last_name': instance.lastName,
      'salutation': instance.salutation,
      'street': instance.street,
      'zip_code': instance.zipCode,
    };

CartItems _$CartItemsFromJson(Map<String, dynamic> json) {
  return CartItems()
    ..items = (json['items'] as List)
        ?.map(
            (e) => e == null ? null : Items.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..availableRefundItems = (json['available_refund_items'] as List)
        ?.map((e) => e == null
            ? null
            : AvailableRefundItems.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CartItemsToJson(CartItems instance) => <String, dynamic>{
      'items': instance.items,
      'available_refund_items': instance.availableRefundItems,
    };

Items _$ItemsFromJson(Map<String, dynamic> json) {
  return Items()
    ..createdAt = json['created_at'] as String
    ..id = json['id'] as String
    ..identifier = json['identifier'] as String
    ..name = json['name'] as String
    ..price = json['price'] as num
    ..priceNet = json['price_net'] as num
    ..quantity = json['quantity'] as num
    ..thumbnail = json['thumbnail'] as String
    ..updatedAt = json['upadated_at'] as String
    ..vatRate = json['vat_rate'] as num
    ..options = (json['options'] as List)
        ?.map((e) =>
            e == null ? null : Option.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
      'created_at': instance.createdAt,
      'id': instance.id,
      'identifier': instance.identifier,
      'name': instance.name,
      'price': instance.price,
      'price_net': instance.priceNet,
      'quantity': instance.quantity,
      'thumbnail': instance.thumbnail,
      'upadated_at': instance.updatedAt,
      'vat_rate': instance.vatRate,
      'options': instance.options,
    };

BusinessUUid _$BusinessUUidFromJson(Map<String, dynamic> json) {
  return BusinessUUid()..uuid = json['uuid'] as String;
}

Map<String, dynamic> _$BusinessUUidToJson(BusinessUUid instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
    };

UserId _$UserIdFromJson(Map<String, dynamic> json) {
  return UserId()..userId = json['id'] as String;
}

Map<String, dynamic> _$UserIdToJson(UserId instance) => <String, dynamic>{
      'id': instance.userId,
    };

Option _$OptionFromJson(Map<String, dynamic> json) {
  return Option()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..value = json['value'] as String;
}

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
    };

AvailableRefundItems _$AvailableRefundItemsFromJson(Map<String, dynamic> json) {
  return AvailableRefundItems()
    ..count = json['count'] as num
    ..itemUuid = json['item_uuid'] as String;
}

Map<String, dynamic> _$AvailableRefundItemsToJson(
        AvailableRefundItems instance) =>
    <String, dynamic>{
      'count': instance.count,
      'item_uuid': instance.itemUuid,
    };

TDChannel _$TDChannelFromJson(Map<String, dynamic> json) {
  return TDChannel()..name = json['name'] as String;
}

Map<String, dynamic> _$TDChannelToJson(TDChannel instance) => <String, dynamic>{
      'name': instance.name,
    };

TDChannelSet _$TDChannelSetFromJson(Map<String, dynamic> json) {
  return TDChannelSet()..uuid = json['uuid'] as String;
}

Map<String, dynamic> _$TDChannelSetToJson(TDChannelSet instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer()
    ..email = json['email'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
    };

TDDetails _$TDDetailsFromJson(Map<String, dynamic> json) {
  return TDDetails()
    ..order = json['order'] == null
        ? null
        : Order.fromJson(json['order'] as Map<String, dynamic>)
    ..advertisingAccepted = json['advertising_accepted'] as bool
    ..birthday = json['birthday'] as String
    ..conditionsAccepted = json['conditions_accepted'] as bool
    ..riskSessionId = json['risk_session_id'] as String
    ..iban = json['iban'] as String;
}

Map<String, dynamic> _$TDDetailsToJson(TDDetails instance) => <String, dynamic>{
      'order': instance.order,
      'advertising_accepted': instance.advertisingAccepted,
      'birthday': instance.birthday,
      'conditions_accepted': instance.conditionsAccepted,
      'risk_session_id': instance.riskSessionId,
      'iban': instance.iban,
    };

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order()
    ..financeId = json['finance_id'] as String
    ..applicationNo = json['application_no'] as String
    ..applicationNumber = json['application_number'] as String
    ..usageText = json['usage_text'] as String
    ..panId = json['pan_id'] as String
    ..reference = json['reference'] as String;
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'finance_id': instance.financeId,
      'application_no': instance.applicationNo,
      'application_number': instance.applicationNumber,
      'usage_text': instance.usageText,
      'pan_id': instance.panId,
      'reference': instance.reference,
    };

TDHistory _$TDHistoryFromJson(Map<String, dynamic> json) {
  return TDHistory()
    ..action = json['action'] as String
    ..createdAt = json['created_at'] as String
    ..id = json['id'] as String
    ..paymentStatus = json['payment_status'] as String
    ..amount = json['amount'] as num;
}

Map<String, dynamic> _$TDHistoryToJson(TDHistory instance) => <String, dynamic>{
      'action': instance.action,
      'created_at': instance.createdAt,
      'id': instance.id,
      'payment_status': instance.paymentStatus,
      'amount': instance.amount,
    };

Merchant _$MerchantFromJson(Map<String, dynamic> json) {
  return Merchant()
    ..email = json['email'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$MerchantToJson(Merchant instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
    };

PaymentFlow _$PaymentFlowFromJson(Map<String, dynamic> json) {
  return PaymentFlow()..id = json['id'] as String;
}

Map<String, dynamic> _$PaymentFlowToJson(PaymentFlow instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

PaymentOption _$PaymentOptionFromJson(Map<String, dynamic> json) {
  return PaymentOption()
    ..downPayment = json['down_payment'] as num
    ..id = json['id'] as num
    ..type = json['type'] as String
    ..paymentFee = json['payment_fee'] as num;
}

Map<String, dynamic> _$PaymentOptionToJson(PaymentOption instance) =>
    <String, dynamic>{
      'down_payment': instance.downPayment,
      'id': instance.id,
      'type': instance.type,
      'payment_fee': instance.paymentFee,
    };

ShippingOption _$ShippingOptionFromJson(Map<String, dynamic> json) {
  return ShippingOption()
    ..methodName = json['method_name'] as String
    ..deliveryFee = json['delivery_fee'] as num;
}

Map<String, dynamic> _$ShippingOptionToJson(ShippingOption instance) =>
    <String, dynamic>{
      'method_name': instance.methodName,
      'delivery_fee': instance.deliveryFee,
    };

Status _$StatusFromJson(Map<String, dynamic> json) {
  return Status()
    ..general = json['general'] as String
    ..place = json['place'] as String
    ..specific = json['specific'] as String;
}

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'general': instance.general,
      'place': instance.place,
      'specific': instance.specific,
    };

Store _$StoreFromJson(Map<String, dynamic> json) {
  return Store()..id = json['store'] as String;
}

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'store': instance.id,
    };

TDTransaction _$TDTransactionFromJson(Map<String, dynamic> json) {
  return TDTransaction()
    ..amount = json['amount'] as num
    ..amountRefunded = json['amount_refunded'] as num
    ..amountRest = json['amount_rest'] as num
    ..total = json['total'] as num
    ..createdAt = json['created_at'] as String
    ..currency = json['currency'] as String
    ..id = json['id'] as String
    ..originalID = json['original_id'] as String
    ..reference = json['reference'] as String
    ..updatedAt = json['updated_at'] as String
    ..uuid = json['uuid'] as String;
}

Map<String, dynamic> _$TDTransactionToJson(TDTransaction instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'amount_refunded': instance.amountRefunded,
      'amount_rest': instance.amountRest,
      'total': instance.total,
      'created_at': instance.createdAt,
      'currency': instance.currency,
      'id': instance.id,
      'original_id': instance.originalID,
      'reference': instance.reference,
      'updated_at': instance.updatedAt,
      'uuid': instance.uuid,
    };
