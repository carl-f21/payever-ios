import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable()
class Month {
  Month();
  @JsonKey(name: 'date')        String date;
  @JsonKey(name: 'amount')      num amount;
  @JsonKey(name: 'currency')    String currency;

  factory Month.fromJson(Map<String, dynamic> json) => _$MonthFromJson(json);
  Map<String, dynamic> toJson() => _$MonthToJson(this);
}

@JsonSerializable()
class Day {
  Day();

  @JsonKey(name: 'date')        String date;
  @JsonKey(name: 'amount')      num amount;
  @JsonKey(name: 'currency')    String currency;

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
  Map<String, dynamic> toJson() => _$DayToJson(this);
}

@JsonSerializable()
class Transaction {
  Transaction();

  @JsonKey(name: 'collection')        List<Collection> collection;
  @JsonKey(name: 'pagination_data')   PaginationData paginationData;
  @JsonKey(name: 'usage')             Usages usages;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class Collection {
  Collection();

  @JsonKey(name: 'action_running')          bool actionRunning;
  @JsonKey(name: 'amount')                  num amount;
  @JsonKey(name: 'billing_address')         BillingAddress billingAddress;
  @JsonKey(name: 'business_option_id')      int businessOptionId;
  @JsonKey(name: 'business_uuid')           String businessUuid;
  @JsonKey(name: 'channel')                 String channel;
  @JsonKey(name: 'channel_set_uuid')        String channelSetUuid;
  @JsonKey(name: 'created_at')              String createdAt;
  @JsonKey(name: 'currency')                String currency;
  @JsonKey(name: 'customer_email')          String customerEmail;
  @JsonKey(name: 'customer_name')           String customerName;
  @JsonKey(name: 'history')                 List<TDHistory> history;
  @JsonKey(name: 'merchant_email')          String merchantEmail;
  @JsonKey(name: 'merchant_name')           String merchantName;
  @JsonKey(name: 'original_id')             String originalId;
  @JsonKey(name: 'payment_flow_id')         String paymentFlowId;
  @JsonKey(name: 'place')                   String place;
  @JsonKey(name: 'reference')               String reference;
  @JsonKey(name: 'santander_applications')  List<String> santanderApplications;
  @JsonKey(name: 'status')                  String status;
  @JsonKey(name: 'total')                   num total;
  @JsonKey(name: 'type')                    String type;
  @JsonKey(name: 'updated_at')              String updatedAt;
  @JsonKey(name: 'uuid')                    String uuid;
  @JsonKey(name: '_id')                     String id;

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionToJson(this);
}

@JsonSerializable()
class BillingAddress {
  BillingAddress();

  @JsonKey(name: 'city')                    String city;
  @JsonKey(name: 'country')                 String country;
  @JsonKey(name: 'country_name')            String countryName;
  @JsonKey(name: 'email')                   String email;
  @JsonKey(name: 'first_name')              String firstName;
  @JsonKey(name: 'last_name')               String lastName;
  @JsonKey(name: 'salutation')              String salutation;
  @JsonKey(name: 'street')                  String street;
  @JsonKey(name: 'zip_code')                String zipCode;
  @JsonKey(name: 'id')                      String id;
  @JsonKey(name: 'company')                 String company;
  @JsonKey(name: 'full_address')            String fullAddress;
  @JsonKey(name: 'phone')                   String phone;
  @JsonKey(name: 'social_security_number')  String socialSecurityNumber;
  @JsonKey(name: 'street_name')             String streetName;
  @JsonKey(name: 'street_number')           String streetNumber;
  @JsonKey(name: 'type')                    String type;
  @JsonKey(name: 'user_uuid')               String userUuid;

  factory BillingAddress.fromJson(Map<String, dynamic> json) => _$BillingAddressFromJson(json);
  Map<String, dynamic> toJson() => _$BillingAddressToJson(this);
}

@JsonSerializable()
class PaginationData {
  PaginationData();

  @JsonKey(name: 'page')              num page;
  @JsonKey(name: 'total')             num total;
  @JsonKey(name: 'amount')            num amount;
  @JsonKey(name: 'amount_currency')   String currency;

  factory PaginationData.fromJson(Map<String, dynamic> json) => _$PaginationDataFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationDataToJson(this);
}

@JsonSerializable()
class Usages {
  Usages();

  @JsonKey(name: 'specific_statuses')   List<String> specificStatuses;
  @JsonKey(name: 'statuses')            List<String> statuses;

  factory Usages.fromJson(Map<String, dynamic> json) => _$UsagesFromJson(json);
  Map<String, dynamic> toJson() => _$UsagesToJson(this);
}


@JsonSerializable()
class TransactionDetails {
  TransactionDetails();

  @JsonKey(name: 'actions')           List<Actions> actions;
  @JsonKey(name: 'billing_address')   TDBillingAddress billingAddress;
  @JsonKey(name: 'business')          BusinessUUid business;
  @JsonKey(name: 'cart')              CartItems cart;
  @JsonKey(name: 'channel')           TDChannel channel;
  @JsonKey(name: 'channel_set')       TDChannelSet channelSet;
  @JsonKey(name: 'customer')          Customer customer;
  @JsonKey(name: 'details')           TDDetails details;
  @JsonKey(name: 'history')           List<TDHistory> history;
  @JsonKey(name: 'merchant')          Merchant merchant;
  @JsonKey(name: 'payment_flow')      PaymentFlow paymentFlow;
  @JsonKey(name: 'payment_option')    PaymentOption paymentOption;
  @JsonKey(name: 'shipping')          ShippingOption shipping;
  @JsonKey(name: 'status')            Status status;
  @JsonKey(name: 'store')             Store store;
  @JsonKey(name: 'transaction')       TDTransaction transaction;
  @JsonKey(name: 'user')              UserId userId;

  factory TransactionDetails.fromJson(Map<String, dynamic> json) => _$TransactionDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionDetailsToJson(this);
}

@JsonSerializable()
class Actions {
  Actions();

  @JsonKey(name: 'action')      String action;
  @JsonKey(name: 'enabled')     bool enabled;

  factory Actions.fromJson(Map<String, dynamic> json) => _$ActionsFromJson(json);
  Map<String, dynamic> toJson() => _$ActionsToJson(this);
}

@JsonSerializable()
class TDBillingAddress {
  TDBillingAddress();

  @JsonKey(name: 'city')            String city;
  @JsonKey(name: 'country')         String country;
  @JsonKey(name: 'country_name')    String countryName;
  @JsonKey(name: 'email')           String email;
  @JsonKey(name: 'first_name')      String firstName;
  @JsonKey(name: 'id')              String id;
  @JsonKey(name: 'last_name')       String lastName;
  @JsonKey(name: 'salutation')      String salutation;
  @JsonKey(name: 'street')          String street;
  @JsonKey(name: 'zip_code')        String zipCode;

  factory TDBillingAddress.fromJson(Map<String, dynamic> json) => _$TDBillingAddressFromJson(json);
  Map<String, dynamic> toJson() => _$TDBillingAddressToJson(this);

}

@JsonSerializable()
class CartItems {
  CartItems();

  @JsonKey(name: 'items')                     List<Items> items;
  @JsonKey(name: 'available_refund_items')    List<AvailableRefundItems> availableRefundItems;

  factory CartItems.fromJson(Map<String, dynamic> json) => _$CartItemsFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemsToJson(this);
}

@JsonSerializable()
class Items {
  Items();

  @JsonKey(name: 'created_at')    String createdAt;
  @JsonKey(name: 'id')            String id;
  @JsonKey(name: 'identifier')    String identifier;
  @JsonKey(name: 'name')          String name;
  @JsonKey(name: 'price')         num price;
  @JsonKey(name: 'price_net')     num priceNet;
  @JsonKey(name: 'quantity')      num quantity;
  @JsonKey(name: 'thumbnail')     String thumbnail;
  @JsonKey(name: 'upadated_at')   String updatedAt;
  @JsonKey(name: 'vat_rate')      num vatRate;
  @JsonKey(name: 'options')       List<Option> options;

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemsToJson(this);

}


@JsonSerializable()
class BusinessUUid {
  BusinessUUid();

  @JsonKey(name: 'uuid')      String uuid;

  factory BusinessUUid.fromJson(Map<String, dynamic> json) => _$BusinessUUidFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessUUidToJson(this);
}

@JsonSerializable()
class UserId {
  UserId();

  @JsonKey(name: 'id')      String userId;

  factory UserId.fromJson(Map<String, dynamic> json) => _$UserIdFromJson(json);
  Map<String, dynamic> toJson() => _$UserIdToJson(this);
}

@JsonSerializable()
class Option {
  Option();

  @JsonKey(name: 'id')      String id;
  @JsonKey(name: 'name')    String name;
  @JsonKey(name: 'value')   String value;

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
  Map<String, dynamic> toJson() => _$OptionToJson(this);
}

@JsonSerializable()
class AvailableRefundItems {
  AvailableRefundItems();

  @JsonKey(name: 'count')         num count;
  @JsonKey(name: 'item_uuid')     String itemUuid;

  factory AvailableRefundItems.fromJson(Map<String, dynamic> json) => _$AvailableRefundItemsFromJson(json);
  Map<String, dynamic> toJson() => _$AvailableRefundItemsToJson(this);
}

@JsonSerializable()
class TDChannel {
  TDChannel();

  @JsonKey(name: 'name')    String name;

  factory TDChannel.fromJson(Map<String, dynamic> json) => _$TDChannelFromJson(json);
  Map<String, dynamic> toJson() => _$TDChannelToJson(this);
}

@JsonSerializable()
class TDChannelSet {
  TDChannelSet();

  @JsonKey(name: 'uuid')    String uuid;

  factory TDChannelSet.fromJson(Map<String, dynamic> json) => _$TDChannelSetFromJson(json);
  Map<String, dynamic> toJson() => _$TDChannelSetToJson(this);
}

@JsonSerializable()
class Customer {
  Customer();

  @JsonKey(name: 'email')   String email;
  @JsonKey(name: 'name')    String name;

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class TDDetails {
  TDDetails();

  @JsonKey(name: 'order')                 Order order;
  @JsonKey(name: 'advertising_accepted')  bool advertisingAccepted;
  @JsonKey(name: 'birthday')              String birthday;
  @JsonKey(name: 'conditions_accepted')   bool conditionsAccepted;
  @JsonKey(name: 'risk_session_id')       String riskSessionId;
  @JsonKey(name: 'iban')                  String iban;

  factory TDDetails.fromJson(Map<String, dynamic> json) => _$TDDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$TDDetailsToJson(this);
}

@JsonSerializable()
class Order {
  Order();

  @JsonKey(name: 'finance_id')          String financeId;
  @JsonKey(name: 'application_no')      String applicationNo;
  @JsonKey(name: 'application_number')  String applicationNumber;
  @JsonKey(name: 'usage_text')          String usageText;
  @JsonKey(name: 'pan_id')              String panId;
  @JsonKey(name: 'reference')           String reference;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class TDHistory {
  TDHistory();

  @JsonKey(name: 'action')            String action;
  @JsonKey(name: 'created_at')        String createdAt;
  @JsonKey(name: 'id')                String id;
  @JsonKey(name: 'payment_status')    String paymentStatus;
  @JsonKey(name: 'amount')            num amount;

  factory TDHistory.fromJson(Map<String, dynamic> json) => _$TDHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$TDHistoryToJson(this);
}

@JsonSerializable()
class Merchant {
  Merchant();

  @JsonKey(name: 'email')     String email;
  @JsonKey(name: 'name')      String name;

  factory Merchant.fromJson(Map<String, dynamic> json) => _$MerchantFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantToJson(this);

}

@JsonSerializable()
class PaymentFlow {
  PaymentFlow();

  @JsonKey(name: 'id')    String id;

  factory PaymentFlow.fromJson(Map<String, dynamic> json) => _$PaymentFlowFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentFlowToJson(this);

}

@JsonSerializable()
class PaymentOption {
  PaymentOption();

  @JsonKey(name: 'down_payment')    num downPayment;
  @JsonKey(name: 'id')              num id;
  @JsonKey(name: 'type')            String type;
  @JsonKey(name: 'payment_fee')     num paymentFee;

  factory PaymentOption.fromJson(Map<String, dynamic> json) => _$PaymentOptionFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentOptionToJson(this);
}

@JsonSerializable()
class ShippingOption {
  ShippingOption();

  @JsonKey(name: 'method_name')     String methodName;
  @JsonKey(name: 'delivery_fee')    num deliveryFee;

  factory ShippingOption.fromJson(Map<String, dynamic> json) => _$ShippingOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ShippingOptionToJson(this);
}

@JsonSerializable()
class Status {
  Status();

  @JsonKey(name: 'general')     String general;
  @JsonKey(name: 'place')       String place;
  @JsonKey(name: 'specific')    String specific;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Map<String, dynamic> toJson() => _$StatusToJson(this);
}

@JsonSerializable()
class Store {
  Store();

  @JsonKey(name: 'store')    String id;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable()
class TDTransaction {
  TDTransaction();

  @JsonKey(name: 'amount')              num amount;
  @JsonKey(name: 'amount_refunded')     num amountRefunded;
  @JsonKey(name: 'amount_rest')         num amountRest;
  @JsonKey(name: 'total')               num total;
  @JsonKey(name: 'created_at')          String createdAt;
  @JsonKey(name: 'currency')            String currency;
  @JsonKey(name: 'id')                  String id;
  @JsonKey(name: 'original_id')         String originalID;
  @JsonKey(name: 'reference')           String reference;
  @JsonKey(name: 'updated_at')          String updatedAt;
  @JsonKey(name: 'uuid')                String uuid;

  factory TDTransaction.fromJson(Map<String, dynamic> json) => _$TDTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TDTransactionToJson(this);
}

class Currency {
  final String name;
  final String code;
  final String symbol;

  Currency({this.name, this.code, this.symbol});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return new Currency(
      name: json['name'] as String,
      code: json['cc'] as String,
      symbol: json['symbol'] as String,
    );
  }
}