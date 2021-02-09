import '../../transactions/models/transaction.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pos.g.dart';

@JsonSerializable()
class Terminal {
  Terminal();

  @JsonKey(name: 'active')                    bool active;
  @JsonKey(name: 'business')                  String business;
  @JsonKey(name: 'channelSet')                String channelSet;
  @JsonKey(name: 'createdAt')                 String createdAt;
  @JsonKey(name: 'defaultLocale')             String defaultLocale;
  @JsonKey(name: 'integrationSubscriptions')  List<String> subscription = List();
  @JsonKey(name: 'locales')                   List<String> locales = List();
  @JsonKey(name: 'logo')                      String logo;
  @JsonKey(name: 'name')                      String name;
  @JsonKey(name: 'theme')                     String theme;
  @JsonKey(name: 'updatedAt')                 String updatedAt;
  @JsonKey(name: '_id')                       String id;

  @JsonKey(ignore:true) List<String> paymentMethods = List();
  @JsonKey(ignore:true) List<Day> lastWeek = List();
  @JsonKey(ignore:true) List<Product> bestSales = List();
  @JsonKey(ignore:true) num lastWeekAmount = 0;

  factory Terminal.fromJson(Map<String, dynamic> json) => _$TerminalFromJson(json);
  Map<String, dynamic> toJson() => _$TerminalToJson(this);

}

@JsonSerializable()
class ChannelSet {
  ChannelSet(this.id, this.name, this.type);

  @JsonKey(name: 'checkout')      String checkout;
  @JsonKey(name: 'customPolicy')  bool customPolicy = false;
  @JsonKey(name: 'policyEnabled') bool policyEnabled = false;
  @JsonKey(name: 'id')            String id;
  @JsonKey(name: 'name')          String name;
  @JsonKey(name: 'type')          String type;

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['name'] = name;
    map['type'] = type;
    map['id'] = id;
    return map;
  }

  factory ChannelSet.fromJson(Map<String, dynamic> json) => _$ChannelSetFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelSetToJson(this);
}

@JsonSerializable()
class Product {
  Product();

  @JsonKey(name: 'channelSet')      String channelSet;
  @JsonKey(name: 'id')              String id;
  @JsonKey(name: 'lastSell')        String lastSell;
  @JsonKey(name: 'name')            String name;
  @JsonKey(name: 'thumbnail')       String thumbnail;
  @JsonKey(name: 'uuid')            String uuid;
  @JsonKey(name: 'quantity')        num quantity;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class ProductFilterOption {
  ProductFilterOption();

  @JsonKey(name: 'name')      String name;
  @JsonKey(name: 'values')    List<String>values = [];

  factory ProductFilterOption.fromJson(Map<String, dynamic> json) => _$ProductFilterOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ProductFilterOptionToJson(this);
}

// add items to complete the flow object
class Cart {
  Cart();
  dynamic cart;
  List<CartItem> items = [];
  num total = 0;
  String id;
}

@JsonSerializable()
class CartItem {

  @JsonKey(name: 'id')            String id;
  @JsonKey(name: 'identifier')    String identifier;
  @JsonKey(name: 'image')         String image;
  @JsonKey(name: 'name')          String name;
  @JsonKey(name: 'price')         num price = 0;
  @JsonKey(name: 'quantity')      num quantity = 0;
  @JsonKey(name: 'vat')           num vat;
  @JsonKey(name: 'sku')           String sku;
  @JsonKey(name: 'uuid')          String uuid;
  @JsonKey(name: 'inStock')       bool inStock = true;

  CartItem(
      {this.id,
      this.sku,
      this.price,
      this.uuid,
      this.quantity,
      this.identifier,
      this.image,
      this.name,
      this.vat});

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

@JsonSerializable()
class Communication {
  Communication();

  @JsonKey(name: 'createdAt')       String createdAt;
  @JsonKey(name: 'installed')       bool installed;
  @JsonKey(name: 'integration')     Integration integration;
  @JsonKey(name: 'updatedAt')       String updatedAt;
  @JsonKey(name: '_id')             String id;

  factory Communication.fromJson(Map<String, dynamic> json) => _$CommunicationFromJson(json);
  Map<String, dynamic> toJson() => _$CommunicationToJson(this);
}

@JsonSerializable()
class Integration {
  Integration();

  @JsonKey(name: 'allowedBusinesses')     List<dynamic> allowedBusinesses = [];
  @JsonKey(name: 'category')              String category;
  @JsonKey(name: 'displayOptions')        DisplayOption displayOptions;
  @JsonKey(name: 'createdAt')             String createdAt;
  @JsonKey(name: 'enabled')               bool enabled;
  @JsonKey(name: 'installationOptions')   InstallationOptions installationOptions;
  @JsonKey(name: 'name')                  String name;
  @JsonKey(name: 'order')                 int order;
  @JsonKey(name: 'updatedAt')             String updatedAt;
  @JsonKey(name: '_id')                   String id;
  @JsonKey(name: 'reviews')               List<dynamic> reviews = [];
  @JsonKey(name: 'timesInstalled')        int timesInstalled;
  @JsonKey(name: 'versions')              List<dynamic> versions = [];
  @JsonKey(name: 'connect')               Connect connect;

  factory Integration.fromJson(Map<String, dynamic> json) => _$IntegrationFromJson(json);
  Map<String, dynamic> toJson() => _$IntegrationToJson(this);
}

@JsonSerializable()
class InstallationOptions {
  InstallationOptions();

  @JsonKey(name: 'appSupport') String appSupport;
  @JsonKey(name: 'category') String category;
  @JsonKey(name: 'countryList') List<dynamic> countryList = [];
  @JsonKey(name: 'description') String description;
  @JsonKey(name: 'developer') String developer;
  @JsonKey(name: 'languages') String languages;
  @JsonKey(name: 'links') List<LinkObj> links = [];
  @JsonKey(name: 'optionIcon') String optionIcon;
  @JsonKey(name: 'price') String price;
  @JsonKey(name: 'pricingLink') String pricingLink;
  @JsonKey(name: 'website') String website;
  @JsonKey(name: '_id') String id;

  factory InstallationOptions.fromJson(Map<String, dynamic> json) => _$InstallationOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$InstallationOptionsToJson(this);
}

@JsonSerializable()
class LinkObj {
  LinkObj();

  @JsonKey(name: 'type')  String type;
  @JsonKey(name: 'url')   String url;
  @JsonKey(name: '_id')   String id;

  factory LinkObj.fromJson(Map<String, dynamic> json) => _$LinkObjFromJson(json);
  Map<String, dynamic> toJson() => _$LinkObjToJson(this);
}

@JsonSerializable()
class DisplayOption {
  DisplayOption();

  @JsonKey(name: 'icon')  String icon;
  @JsonKey(name: 'title') String title;
  @JsonKey(name: '_id')   String id;

  factory DisplayOption.fromJson(Map<String, dynamic> json) => _$DisplayOptionFromJson(json);
  Map<String, dynamic> toJson() => _$DisplayOptionToJson(this);
}

@JsonSerializable()
class Connect {
  Connect();

  @JsonKey(name: 'fromAction')  Action fromAction;
  @JsonKey(name: 'url')         String url;
  @JsonKey(name: 'url1')        String url1;

  factory Connect.fromJson(Map<String, dynamic> json) => _$ConnectFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectToJson(this);
}

@JsonSerializable()
class Action {
  Action();

  @JsonKey(name: 'actionEndpoint')  String actionEndpoint;
  @JsonKey(name: 'initEndpoint')    String initEndpoint;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
  Map<String, dynamic> toJson() => _$ActionToJson(this);
}

@JsonSerializable()
class DevicePaymentSettings {
  DevicePaymentSettings();

  @JsonKey(name: 'autoresponderEnabled')  bool autoresponderEnabled;
  @JsonKey(name: 'enabled')               bool enabled;
  @JsonKey(name: 'secondFactor')          bool secondFactor;
  @JsonKey(name: 'verificationType')      int verificationType;

  factory DevicePaymentSettings.fromJson(Map<String, dynamic> json) => _$DevicePaymentSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$DevicePaymentSettingsToJson(this);
}

@JsonSerializable()
class DevicePaymentInstall {
  DevicePaymentInstall();

  @JsonKey(name: 'installed')   bool installed;
  @JsonKey(name: 'name')        String name;

  factory DevicePaymentInstall.fromJson(Map<String, dynamic> json) => _$DevicePaymentInstallFromJson(json);
  Map<String, dynamic> toJson() => _$DevicePaymentInstallToJson(this);
}


class CountryDropdownItem {
  final String label;
  final dynamic value;
  CountryDropdownItem({
    this.label,
    this.value,
  });

  factory CountryDropdownItem.fromMap(dynamic obj) {
    return CountryDropdownItem(
      label: obj['label'],
      value: obj['value'],
    );
  }
}


class AddPhoneNumberSettingsModel{
  String id = '';
  CountryDropdownItem country;
  String phoneNumber = '';
  bool excludeAny = false;
  bool excludeForeign = false;
  bool excludeLocal = false;
}