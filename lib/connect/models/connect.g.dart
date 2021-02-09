// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutPaymentOption _$CheckoutPaymentOptionFromJson(
    Map<String, dynamic> json) {
  return CheckoutPaymentOption()
    ..acceptFee = json['accept_fee'] as bool
    ..contractLength = json['contract_length'] as num
    ..descriptionFee = json['description_fee'] as String
    ..descriptionOffer = json['description_offer'] as String
    ..fixedFee = json['fixed_fee'] as num
    ..id = json['id'] as num
    ..imagePrimaryFilename = json['image_primary_filename'] as String
    ..imageSecondaryFilename = json['image_secondary_filename'] as String
    ..instructionText = json['instruction_text'] as String
    ..max = json['max'] as num
    ..merchantAllowedCountries = json['merchant_allowed_countries']
    ..min = json['min'] as num
    ..name = json['name'] as String
    ..options = json['options'] == null
        ? null
        : CurrencyOption.fromJson(json['options'] as Map<String, dynamic>)
    ..paymentMethod = json['payment_method'] as String
    ..relatedCountry = json['related_country'] as String
    ..relatedCountryName = json['related_country_name'] as String
    ..settings = json['settings']
    ..slug = json['slug'] as String
    ..status = json['status'] as String
    ..thumbnail1 = json['thumbnail1'] as String
    ..thumbnail2 = json['thumbnail2'] as String
    ..variableFee = json['variable_fee'] as num
    ..variants = (json['variants'] as List)
        ?.map((e) =>
            e == null ? null : Variant.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..isCheckedAds = json['isCheckedAds'] as bool;
}

Map<String, dynamic> _$CheckoutPaymentOptionToJson(
        CheckoutPaymentOption instance) =>
    <String, dynamic>{
      'accept_fee': instance.acceptFee,
      'contract_length': instance.contractLength,
      'description_fee': instance.descriptionFee,
      'description_offer': instance.descriptionOffer,
      'fixed_fee': instance.fixedFee,
      'id': instance.id,
      'image_primary_filename': instance.imagePrimaryFilename,
      'image_secondary_filename': instance.imageSecondaryFilename,
      'instruction_text': instance.instructionText,
      'max': instance.max,
      'merchant_allowed_countries': instance.merchantAllowedCountries,
      'min': instance.min,
      'name': instance.name,
      'options': instance.options,
      'payment_method': instance.paymentMethod,
      'related_country': instance.relatedCountry,
      'related_country_name': instance.relatedCountryName,
      'settings': instance.settings,
      'slug': instance.slug,
      'status': instance.status,
      'thumbnail1': instance.thumbnail1,
      'thumbnail2': instance.thumbnail2,
      'variable_fee': instance.variableFee,
      'variants': instance.variants,
      'isCheckedAds': instance.isCheckedAds,
    };

CurrencyOption _$CurrencyOptionFromJson(Map<String, dynamic> json) {
  return CurrencyOption()
    ..countries = (json['countries'] as List)?.map((e) => e as String)?.toList()
    ..currencies =
        (json['currencies'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$CurrencyOptionToJson(CurrencyOption instance) =>
    <String, dynamic>{
      'countries': instance.countries,
      'currencies': instance.currencies,
    };

Variant _$VariantFromJson(Map<String, dynamic> json) {
  return Variant()
    ..acceptFee = json['accept_fee'] as bool
    ..completed = json['completed'] as bool
    ..credentials = json['credentials']
    ..credentialsValid = json['credentials_valid'] as bool
    ..isDefault = json['default'] as bool
    ..fixedFee = json['fixed_fee'] as num
    ..generalStatus = json['general_status'] as String
    ..id = json['id'] as num
    ..max = json['max'] as num
    ..min = json['min'] as num
    ..name = json['name'] as String
    ..options = json['options']
    ..paymentMethod = json['payment_method'] as String
    ..paymentOptionId = json['payment_option_id'] as num
    ..shopRedirectEnabled = json['shop_redirect_enabled'] as bool
    ..status = json['status'] as String
    ..uuid = json['uuid'] as String
    ..variableFee = json['variable_fee'] as num;
}

Map<String, dynamic> _$VariantToJson(Variant instance) => <String, dynamic>{
      'accept_fee': instance.acceptFee,
      'completed': instance.completed,
      'credentials': instance.credentials,
      'credentials_valid': instance.credentialsValid,
      'default': instance.isDefault,
      'fixed_fee': instance.fixedFee,
      'general_status': instance.generalStatus,
      'id': instance.id,
      'max': instance.max,
      'min': instance.min,
      'name': instance.name,
      'options': instance.options,
      'payment_method': instance.paymentMethod,
      'payment_option_id': instance.paymentOptionId,
      'shop_redirect_enabled': instance.shopRedirectEnabled,
      'status': instance.status,
      'uuid': instance.uuid,
      'variable_fee': instance.variableFee,
    };
