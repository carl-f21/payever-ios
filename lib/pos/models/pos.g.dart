// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Terminal _$TerminalFromJson(Map<String, dynamic> json) {
  return Terminal()
    ..active = json['active'] as bool
    ..business = json['business'] as String
    ..channelSet = json['channelSet'] as String
    ..createdAt = json['createdAt'] as String
    ..defaultLocale = json['defaultLocale'] as String
    ..subscription = (json['integrationSubscriptions'] as List)
        ?.map((e) => e as String)
        ?.toList()
    ..locales = (json['locales'] as List)?.map((e) => e as String)?.toList()
    ..logo = json['logo'] as String
    ..name = json['name'] as String
    ..theme = json['theme'] as String
    ..updatedAt = json['updatedAt'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$TerminalToJson(Terminal instance) => <String, dynamic>{
      'active': instance.active,
      'business': instance.business,
      'channelSet': instance.channelSet,
      'createdAt': instance.createdAt,
      'defaultLocale': instance.defaultLocale,
      'integrationSubscriptions': instance.subscription,
      'locales': instance.locales,
      'logo': instance.logo,
      'name': instance.name,
      'theme': instance.theme,
      'updatedAt': instance.updatedAt,
      '_id': instance.id,
    };

ChannelSet _$ChannelSetFromJson(Map<String, dynamic> json) {
  return ChannelSet(
    json['id'] as String,
    json['name'] as String,
    json['type'] as String,
  )
    ..checkout = json['checkout'] as String
    ..customPolicy = json['customPolicy'] as bool
    ..policyEnabled = json['policyEnabled'] as bool;
}

Map<String, dynamic> _$ChannelSetToJson(ChannelSet instance) =>
    <String, dynamic>{
      'checkout': instance.checkout,
      'customPolicy': instance.customPolicy,
      'policyEnabled': instance.policyEnabled,
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product()
    ..channelSet = json['channelSet'] as String
    ..id = json['id'] as String
    ..lastSell = json['lastSell'] as String
    ..name = json['name'] as String
    ..thumbnail = json['thumbnail'] as String
    ..uuid = json['uuid'] as String
    ..quantity = json['quantity'] as num;
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'channelSet': instance.channelSet,
      'id': instance.id,
      'lastSell': instance.lastSell,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
      'uuid': instance.uuid,
      'quantity': instance.quantity,
    };

ProductFilterOption _$ProductFilterOptionFromJson(Map<String, dynamic> json) {
  return ProductFilterOption()
    ..name = json['name'] as String
    ..values = (json['values'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$ProductFilterOptionToJson(
        ProductFilterOption instance) =>
    <String, dynamic>{
      'name': instance.name,
      'values': instance.values,
    };

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return CartItem(
    id: json['id'] as String,
    sku: json['sku'] as String,
    price: json['price'] as num,
    uuid: json['uuid'] as String,
    quantity: json['quantity'] as num,
    identifier: json['identifier'] as String,
    image: json['image'] as String,
    name: json['name'] as String,
    vat: json['vat'] as num,
  )..inStock = json['inStock'] as bool;
}

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'id': instance.id,
      'identifier': instance.identifier,
      'image': instance.image,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'vat': instance.vat,
      'sku': instance.sku,
      'uuid': instance.uuid,
      'inStock': instance.inStock,
    };

Communication _$CommunicationFromJson(Map<String, dynamic> json) {
  return Communication()
    ..createdAt = json['createdAt'] as String
    ..installed = json['installed'] as bool
    ..integration = json['integration'] == null
        ? null
        : Integration.fromJson(json['integration'] as Map<String, dynamic>)
    ..updatedAt = json['updatedAt'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$CommunicationToJson(Communication instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'installed': instance.installed,
      'integration': instance.integration,
      'updatedAt': instance.updatedAt,
      '_id': instance.id,
    };

Integration _$IntegrationFromJson(Map<String, dynamic> json) {
  return Integration()
    ..allowedBusinesses = json['allowedBusinesses'] as List
    ..category = json['category'] as String
    ..displayOptions = json['displayOptions'] == null
        ? null
        : DisplayOption.fromJson(json['displayOptions'] as Map<String, dynamic>)
    ..createdAt = json['createdAt'] as String
    ..enabled = json['enabled'] as bool
    ..installationOptions = json['installationOptions'] == null
        ? null
        : InstallationOptions.fromJson(
            json['installationOptions'] as Map<String, dynamic>)
    ..name = json['name'] as String
    ..order = json['order'] as int
    ..updatedAt = json['updatedAt'] as String
    ..id = json['_id'] as String
    ..reviews = json['reviews'] as List
    ..timesInstalled = json['timesInstalled'] as int
    ..versions = json['versions'] as List
    ..connect = json['connect'] == null
        ? null
        : Connect.fromJson(json['connect'] as Map<String, dynamic>);
}

Map<String, dynamic> _$IntegrationToJson(Integration instance) =>
    <String, dynamic>{
      'allowedBusinesses': instance.allowedBusinesses,
      'category': instance.category,
      'displayOptions': instance.displayOptions,
      'createdAt': instance.createdAt,
      'enabled': instance.enabled,
      'installationOptions': instance.installationOptions,
      'name': instance.name,
      'order': instance.order,
      'updatedAt': instance.updatedAt,
      '_id': instance.id,
      'reviews': instance.reviews,
      'timesInstalled': instance.timesInstalled,
      'versions': instance.versions,
      'connect': instance.connect,
    };

InstallationOptions _$InstallationOptionsFromJson(Map<String, dynamic> json) {
  return InstallationOptions()
    ..appSupport = json['appSupport'] as String
    ..category = json['category'] as String
    ..countryList = json['countryList'] as List
    ..description = json['description'] as String
    ..developer = json['developer'] as String
    ..languages = json['languages'] as String
    ..links = (json['links'] as List)
        ?.map((e) =>
            e == null ? null : LinkObj.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..optionIcon = json['optionIcon'] as String
    ..price = json['price'] as String
    ..pricingLink = json['pricingLink'] as String
    ..website = json['website'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$InstallationOptionsToJson(
        InstallationOptions instance) =>
    <String, dynamic>{
      'appSupport': instance.appSupport,
      'category': instance.category,
      'countryList': instance.countryList,
      'description': instance.description,
      'developer': instance.developer,
      'languages': instance.languages,
      'links': instance.links,
      'optionIcon': instance.optionIcon,
      'price': instance.price,
      'pricingLink': instance.pricingLink,
      'website': instance.website,
      '_id': instance.id,
    };

LinkObj _$LinkObjFromJson(Map<String, dynamic> json) {
  return LinkObj()
    ..type = json['type'] as String
    ..url = json['url'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$LinkObjToJson(LinkObj instance) => <String, dynamic>{
      'type': instance.type,
      'url': instance.url,
      '_id': instance.id,
    };

DisplayOption _$DisplayOptionFromJson(Map<String, dynamic> json) {
  return DisplayOption()
    ..icon = json['icon'] as String
    ..title = json['title'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$DisplayOptionToJson(DisplayOption instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'title': instance.title,
      '_id': instance.id,
    };

Connect _$ConnectFromJson(Map<String, dynamic> json) {
  return Connect()
    ..fromAction = json['fromAction'] == null
        ? null
        : Action.fromJson(json['fromAction'] as Map<String, dynamic>)
    ..url = json['url'] as String
    ..url1 = json['url1'] as String;
}

Map<String, dynamic> _$ConnectToJson(Connect instance) => <String, dynamic>{
      'fromAction': instance.fromAction,
      'url': instance.url,
      'url1': instance.url1,
    };

Action _$ActionFromJson(Map<String, dynamic> json) {
  return Action()
    ..actionEndpoint = json['actionEndpoint'] as String
    ..initEndpoint = json['initEndpoint'] as String;
}

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'actionEndpoint': instance.actionEndpoint,
      'initEndpoint': instance.initEndpoint,
    };

DevicePaymentSettings _$DevicePaymentSettingsFromJson(
    Map<String, dynamic> json) {
  return DevicePaymentSettings()
    ..autoresponderEnabled = json['autoresponderEnabled'] as bool
    ..enabled = json['enabled'] as bool
    ..secondFactor = json['secondFactor'] as bool
    ..verificationType = json['verificationType'] as int;
}

Map<String, dynamic> _$DevicePaymentSettingsToJson(
        DevicePaymentSettings instance) =>
    <String, dynamic>{
      'autoresponderEnabled': instance.autoresponderEnabled,
      'enabled': instance.enabled,
      'secondFactor': instance.secondFactor,
      'verificationType': instance.verificationType,
    };

DevicePaymentInstall _$DevicePaymentInstallFromJson(Map<String, dynamic> json) {
  return DevicePaymentInstall()
    ..installed = json['installed'] as bool
    ..name = json['name'] as String;
}

Map<String, dynamic> _$DevicePaymentInstallToJson(
        DevicePaymentInstall instance) =>
    <String, dynamic>{
      'installed': instance.installed,
      'name': instance.name,
    };
