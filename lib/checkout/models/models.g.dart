// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Checkout _$CheckoutFromJson(Map<String, dynamic> json) {
  return Checkout()
    ..businessId = json['businessId'] as String
    ..connections =
        (json['connections'] as List)?.map((e) => e as String)?.toList()
    ..createdAt = json['createdAt'] as String
    ..isDefault = json['default'] as bool
    ..logo = json['logo'] as String
    ..name = json['name'] as String
    ..sections = (json['sections'] as List)
        ?.map((e) =>
            e == null ? null : Section.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..settings = json['settings'] == null
        ? null
        : CheckoutSettings.fromJson(json['settings'] as Map<String, dynamic>)
    ..updatedAt = json['updatedAt'] as String
    ..v = json['__v'] as num
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$CheckoutToJson(Checkout instance) => <String, dynamic>{
      'businessId': instance.businessId,
      'connections': instance.connections,
      'createdAt': instance.createdAt,
      'default': instance.isDefault,
      'logo': instance.logo,
      'name': instance.name,
      'sections': instance.sections,
      'settings': instance.settings,
      'updatedAt': instance.updatedAt,
      '__v': instance.v,
      '_id': instance.id,
    };

Section _$SectionFromJson(Map<String, dynamic> json) {
  return Section()
    ..code = json['code'] as String
    ..defaultEnabled = json['defaultEnabled'] as bool
    ..enabled = json['enabled'] as bool
    ..fixed = json['fixed'] as bool
    ..order = json['order'] as num
    ..id = json['_id'] as String
    ..excludedChannels =
        (json['excluded_channels'] as List)?.map((e) => e as String)?.toList()
    ..subsections = (json['subsections'] as List)
        ?.map((e) =>
            e == null ? null : SubSection.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'code': instance.code,
      'defaultEnabled': instance.defaultEnabled,
      'enabled': instance.enabled,
      'fixed': instance.fixed,
      'order': instance.order,
      '_id': instance.id,
      'excluded_channels': instance.excludedChannels,
      'subsections': instance.subsections,
    };

SubSection _$SubSectionFromJson(Map<String, dynamic> json) {
  return SubSection()
    ..code = json['code'] as String
    ..rules = (json['rules'] as List)
        ?.map(
            (e) => e == null ? null : Rule.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$SubSectionToJson(SubSection instance) =>
    <String, dynamic>{
      'code': instance.code,
      'rules': instance.rules,
      '_id': instance.id,
    };

Rule _$RuleFromJson(Map<String, dynamic> json) {
  return Rule()
    ..operator = json['operator'] as String
    ..property = json['property'] as String
    ..type = json['type'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$RuleToJson(Rule instance) => <String, dynamic>{
      'operator': instance.operator,
      'property': instance.property,
      'type': instance.type,
      '_id': instance.id,
    };

CheckoutSettings _$CheckoutSettingsFromJson(Map<String, dynamic> json) {
  return CheckoutSettings()
    ..cspAllowedHosts =
        (json['cspAllowedHosts'] as List)?.map((e) => e as String)?.toList()
    ..languages = (json['languages'] as List)
        ?.map(
            (e) => e == null ? null : Lang.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] as String
    ..phoneNumber = json['phoneNumber'] as String
    ..styles = json['styles'] == null
        ? null
        : Style.fromJson(json['styles'] as Map<String, dynamic>)
    ..testingMode = json['testingMode'] as bool;
}

Map<String, dynamic> _$CheckoutSettingsToJson(CheckoutSettings instance) =>
    <String, dynamic>{
      'cspAllowedHosts': instance.cspAllowedHosts,
      'languages': instance.languages,
      'message': instance.message,
      'phoneNumber': instance.phoneNumber,
      'styles': instance.styles,
      'testingMode': instance.testingMode,
    };

Lang _$LangFromJson(Map<String, dynamic> json) {
  return Lang()
    ..active = json['active'] as bool
    ..code = json['code'] as String
    ..isDefault = json['isDefault'] as bool
    ..isHovered = json['isHovered'] as bool
    ..isToggleButton = json['isToggleButton'] as bool
    ..name = json['name'] as String
    ..id = json['id'] as String;
}

Map<String, dynamic> _$LangToJson(Lang instance) => <String, dynamic>{
      'active': instance.active,
      'code': instance.code,
      'isDefault': instance.isDefault,
      'isHovered': instance.isHovered,
      'isToggleButton': instance.isToggleButton,
      'name': instance.name,
      'id': instance.id,
    };

Style _$StyleFromJson(Map<String, dynamic> json) {
  return Style()
    ..button = json['button'] == null
        ? null
        : ButtonStyle.fromJson(json['button'] as Map<String, dynamic>)
    ..page = json['page'] == null
        ? null
        : PageStyle.fromJson(json['page'] as Map<String, dynamic>)
    ..id = json['id'] as String
    ..id1 = json['_id'] as String
    ..active = json['active'] as bool
    ..businessHeaderBackgroundColor =
        json['businessHeaderBackgroundColor'] as String
    ..businessHeaderBorderColor = json['businessHeaderBorderColor'] as String
    ..buttonBackgroundColor = json['buttonBackgroundColor'] as String
    ..buttonBackgroundDisabledColor =
        json['buttonBackgroundDisabledColor'] as String
    ..buttonBorderRadius = json['buttonBorderRadius'] as String
    ..buttonTextColor = json['buttonTextColor'] as String
    ..inputBackgroundColor = json['inputBackgroundColor'] as String
    ..inputBorderColor = json['inputBorderColor'] as String
    ..inputBorderRadius = json['inputBorderRadius'] as String
    ..inputTextPrimaryColor = json['inputTextPrimaryColor'] as String
    ..inputTextSecondaryColor = json['inputTextSecondaryColor'] as String
    ..pageBackgroundColor = json['pageBackgroundColor'] as String
    ..pageLineColor = json['pageLineColor'] as String
    ..pageTextLinkColor = json['pageTextLinkColor'] as String
    ..pageTextPrimaryColor = json['pageTextPrimaryColor'] as String
    ..pageTextSecondaryColor = json['pageTextSecondaryColor'] as String;
}

Map<String, dynamic> _$StyleToJson(Style instance) => <String, dynamic>{
      'button': instance.button,
      'page': instance.page,
      'id': instance.id,
      '_id': instance.id1,
      'active': instance.active,
      'businessHeaderBackgroundColor': instance.businessHeaderBackgroundColor,
      'businessHeaderBorderColor': instance.businessHeaderBorderColor,
      'buttonBackgroundColor': instance.buttonBackgroundColor,
      'buttonBackgroundDisabledColor': instance.buttonBackgroundDisabledColor,
      'buttonBorderRadius': instance.buttonBorderRadius,
      'buttonTextColor': instance.buttonTextColor,
      'inputBackgroundColor': instance.inputBackgroundColor,
      'inputBorderColor': instance.inputBorderColor,
      'inputBorderRadius': instance.inputBorderRadius,
      'inputTextPrimaryColor': instance.inputTextPrimaryColor,
      'inputTextSecondaryColor': instance.inputTextSecondaryColor,
      'pageBackgroundColor': instance.pageBackgroundColor,
      'pageLineColor': instance.pageLineColor,
      'pageTextLinkColor': instance.pageTextLinkColor,
      'pageTextPrimaryColor': instance.pageTextPrimaryColor,
      'pageTextSecondaryColor': instance.pageTextSecondaryColor,
    };

PageStyle _$PageStyleFromJson(Map<String, dynamic> json) {
  return PageStyle()..background = json['background'] as String;
}

Map<String, dynamic> _$PageStyleToJson(PageStyle instance) => <String, dynamic>{
      'background': instance.background,
    };

ButtonStyle _$ButtonStyleFromJson(Map<String, dynamic> json) {
  return ButtonStyle()
    ..corners = json['corners'] as String
    ..color = json['color'] == null
        ? null
        : ButtonColorStyle.fromJson(json['color'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ButtonStyleToJson(ButtonStyle instance) =>
    <String, dynamic>{
      'corners': instance.corners,
      'color': instance.color,
    };

ButtonColorStyle _$ButtonColorStyleFromJson(Map<String, dynamic> json) {
  return ButtonColorStyle()
    ..borders = json['borders'] as String
    ..fill = json['fill'] as String
    ..text = json['text'] as String;
}

Map<String, dynamic> _$ButtonColorStyleToJson(ButtonColorStyle instance) =>
    <String, dynamic>{
      'borders': instance.borders,
      'fill': instance.fill,
      'text': instance.text,
    };

CheckoutFlow _$CheckoutFlowFromJson(Map<String, dynamic> json) {
  return CheckoutFlow()
    ..businessUuid = json['businessUuid'] as String
    ..channelType = json['channelType'] as String
    ..currency = json['currency'] as String
    ..customPolicy = json['customPolicy'] as bool
    ..languages = (json['languages'] as List)
        ?.map(
            (e) => e == null ? null : Lang.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..limits = json['limits']
    ..logo = json['logo'] as String
    ..message = json['message'] as String
    ..name = json['name'] as String
    ..paymentMethods =
        (json['paymentMethods'] as List)?.map((e) => e as String)?.toList()
    ..phoneNumber = json['phoneNumber'] as String
    ..policyEnabled = json['policyEnabled'] as bool
    ..sections = (json['sections'] as List)
        ?.map((e) =>
            e == null ? null : Section.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..styles = json['styles'] == null
        ? null
        : Style.fromJson(json['styles'] as Map<String, dynamic>)
    ..testingMode = json['testingMode'] as bool
    ..uuid = json['uuid'] as String;
}

Map<String, dynamic> _$CheckoutFlowToJson(CheckoutFlow instance) =>
    <String, dynamic>{
      'businessUuid': instance.businessUuid,
      'channelType': instance.channelType,
      'currency': instance.currency,
      'customPolicy': instance.customPolicy,
      'languages': instance.languages,
      'limits': instance.limits,
      'logo': instance.logo,
      'message': instance.message,
      'name': instance.name,
      'paymentMethods': instance.paymentMethods,
      'phoneNumber': instance.phoneNumber,
      'policyEnabled': instance.policyEnabled,
      'sections': instance.sections,
      'styles': instance.styles,
      'testingMode': instance.testingMode,
      'uuid': instance.uuid,
    };

ChannelSetFlow _$ChannelSetFlowFromJson(Map<String, dynamic> json) {
  return ChannelSetFlow()
    ..acceptTermsPayever = json['accept_terms_payever'] as String
    ..amount = json['amount'] as num ?? 0
    ..apiCall = json['api_call'] as String
    ..apiCallCart = json['api_call_cart'] as String
    ..apiCallId = json['api_call_id'] as String
    ..billingAddress = json['billing_address'] == null
        ? null
        : BillingAddress.fromJson(
            json['billing_address'] as Map<String, dynamic>)
    ..businessAddressLine = json['business_address_line'] as String
    ..businessIban = json['business_iban'] as String
    ..businessId = json['business_id'] as String
    ..businessLogo = json['business_logo'] as String
    ..businessName = json['business_name'] as String
    ..businessShippingOptionId = json['business_shipping_option_id'] as String
    ..canIdentifyBySsn = json['can_identify_by_ssn'] as bool
    ..cancelUrl = json['cancel_url'] as String
    ..cart = (json['cart'] as List)
        ?.map((e) =>
            e == null ? null : CartItem.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..channel = json['channel'] as String
    ..channelSetId = json['channel_set_id'] as String
    ..clientId = json['client_id'] as String
    ..comment = json['comment'] as String
    ..connectionId = json['connection_id'] as String
    ..countries = (json['countries'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..currency = json['currency'] as String
    ..differentAddress = json['different_address'] as bool
    ..express = json['express'] as bool
    ..extra = json['extra']
    ..failureUrl = json['failure_url'] as String
    ..financeType = json['finance_type'] as String
    ..flashBag = json['flash_bag'] as List
    ..flowIdentifier = json['flow_identifier'] as String
    ..forceLegacyCartStep = json['force_legacy_cart_step'] as bool
    ..forceLegacyUseInventory = json['force_legacy_use_inventory'] as bool
    ..guestToken = json['guest_token'] as String
    ..hideSalutation = json['hide_salutation'] as bool
    ..id = json['id'] as String
    ..ipHash = json['ip_hash'] as String
    ..loggedInId = json['logged_in_id'] as String
    ..merchantReference = json['merchant_reference'] as String
    ..noticeUrl = json['notice_url'] as String
    ..payment = json['payment'] == null
        ? null
        : Payment.fromJson(json['payment'] as Map<String, dynamic>)
    ..paymentMethod = json['payment_method'] as String
    ..paymentOptionId = json['payment_option_id'] as num
    ..paymentOptions = (json['payment_options'] as List)
        ?.map((e) => e == null
            ? null
            : CheckoutPaymentOption.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..pendingUrl = json['pending_url'] as String
    ..posMerchantMode = json['pos_merchant_mode'] as String
    ..reference = json['reference'] as String
    ..sellerEmail = json['seller_email'] as String
    ..shippingAddressId = json['shipping_address_id'] as String
    ..shippingAddresses = json['shipping_addresses'] as List
    ..shippingCategory = json['shipping_category'] as String
    ..shippingFee = json['shipping_fee'] as num
    ..shippingMethodCode = json['shipping_method_code'] as String
    ..shippingMethodName = json['shipping_method_name'] as String
    ..shippingOptionName = json['shipping_option_name'] as String
    ..shippingOptions = json['shipping_options'] as List
    ..shippingOrderId = json['shipping_order_id'] as String
    ..shippingType = json['shipping_type'] as String
    ..shopUrl = json['shop_url'] as String
    ..singleAddress = json['single_address'] as bool
    ..state = json['state'] as String
    ..successUrl = json['success_url'] as String
    ..taxValue = json['tax_value'] as num
    ..total = json['total'] as num
    ..userAccountId = json['user_account_id'] as String
    ..values = json['values']
    ..variantId = json['variant_id'] as String
    ..xFrameHost = json['x_frame_host'] as String;
}

Map<String, dynamic> _$ChannelSetFlowToJson(ChannelSetFlow instance) =>
    <String, dynamic>{
      'accept_terms_payever': instance.acceptTermsPayever,
      'amount': instance.amount,
      'api_call': instance.apiCall,
      'api_call_cart': instance.apiCallCart,
      'api_call_id': instance.apiCallId,
      'billing_address': instance.billingAddress,
      'business_address_line': instance.businessAddressLine,
      'business_iban': instance.businessIban,
      'business_id': instance.businessId,
      'business_logo': instance.businessLogo,
      'business_name': instance.businessName,
      'business_shipping_option_id': instance.businessShippingOptionId,
      'can_identify_by_ssn': instance.canIdentifyBySsn,
      'cancel_url': instance.cancelUrl,
      'cart': instance.cart,
      'channel': instance.channel,
      'channel_set_id': instance.channelSetId,
      'client_id': instance.clientId,
      'comment': instance.comment,
      'connection_id': instance.connectionId,
      'countries': instance.countries,
      'currency': instance.currency,
      'different_address': instance.differentAddress,
      'express': instance.express,
      'extra': instance.extra,
      'failure_url': instance.failureUrl,
      'finance_type': instance.financeType,
      'flash_bag': instance.flashBag,
      'flow_identifier': instance.flowIdentifier,
      'force_legacy_cart_step': instance.forceLegacyCartStep,
      'force_legacy_use_inventory': instance.forceLegacyUseInventory,
      'guest_token': instance.guestToken,
      'hide_salutation': instance.hideSalutation,
      'id': instance.id,
      'ip_hash': instance.ipHash,
      'logged_in_id': instance.loggedInId,
      'merchant_reference': instance.merchantReference,
      'notice_url': instance.noticeUrl,
      'payment': instance.payment,
      'payment_method': instance.paymentMethod,
      'payment_option_id': instance.paymentOptionId,
      'payment_options': instance.paymentOptions,
      'pending_url': instance.pendingUrl,
      'pos_merchant_mode': instance.posMerchantMode,
      'reference': instance.reference,
      'seller_email': instance.sellerEmail,
      'shipping_address_id': instance.shippingAddressId,
      'shipping_addresses': instance.shippingAddresses,
      'shipping_category': instance.shippingCategory,
      'shipping_fee': instance.shippingFee,
      'shipping_method_code': instance.shippingMethodCode,
      'shipping_method_name': instance.shippingMethodName,
      'shipping_option_name': instance.shippingOptionName,
      'shipping_options': instance.shippingOptions,
      'shipping_order_id': instance.shippingOrderId,
      'shipping_type': instance.shippingType,
      'shop_url': instance.shopUrl,
      'single_address': instance.singleAddress,
      'state': instance.state,
      'success_url': instance.successUrl,
      'tax_value': instance.taxValue,
      'total': instance.total,
      'user_account_id': instance.userAccountId,
      'values': instance.values,
      'variant_id': instance.variantId,
      'x_frame_host': instance.xFrameHost,
    };

IntegrationModel _$IntegrationModelFromJson(Map<String, dynamic> json) {
  return IntegrationModel()
    ..integration = json['integration'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$IntegrationModelToJson(IntegrationModel instance) =>
    <String, dynamic>{
      'integration': instance.integration,
      '_id': instance.id,
    };

FinanceExpressSetting _$FinanceExpressSettingFromJson(
    Map<String, dynamic> json) {
  return FinanceExpressSetting()
    ..bannerAndRate = json['banner-and-rate'] == null
        ? null
        : FinanceExpress.fromJson(
            json['banner-and-rate'] as Map<String, dynamic>)
    ..bubble = json['bubble'] == null
        ? null
        : FinanceExpress.fromJson(json['bubble'] as Map<String, dynamic>)
    ..button = json['button'] == null
        ? null
        : FinanceExpress.fromJson(json['button'] as Map<String, dynamic>)
    ..textLink = json['text-link'] == null
        ? null
        : FinanceExpress.fromJson(json['text-link'] as Map<String, dynamic>);
}

Map<String, dynamic> _$FinanceExpressSettingToJson(
        FinanceExpressSetting instance) =>
    <String, dynamic>{
      'banner-and-rate': instance.bannerAndRate,
      'bubble': instance.bubble,
      'button': instance.button,
      'text-link': instance.textLink,
    };

FinanceExpress _$FinanceExpressFromJson(Map<String, dynamic> json) {
  return FinanceExpress()
    ..adaptiveDesign = json['adaptiveDesign'] as bool
    ..bgColor = json['bgColor'] as String
    ..borderColor = json['borderColor'] as String
    ..buttonColor = json['buttonColor'] as String
    ..displayType = json['displayType'] as String
    ..linkColor = json['linkColor'] as String
    ..linkTo = json['linkTo'] as String
    ..order = json['order'] as String
    ..size = json['size'] as num
    ..textColor = json['textColor'] as String
    ..visibility = json['visibility'] as bool
    ..alignment = json['alignment'] as String
    ..corners = json['corners'] as String
    ..height = json['height'] as num
    ..textSize = json['textSize'] as String
    ..width = json['width'] as num;
}

Map<String, dynamic> _$FinanceExpressToJson(FinanceExpress instance) =>
    <String, dynamic>{
      'adaptiveDesign': instance.adaptiveDesign,
      'bgColor': instance.bgColor,
      'borderColor': instance.borderColor,
      'buttonColor': instance.buttonColor,
      'displayType': instance.displayType,
      'linkColor': instance.linkColor,
      'linkTo': instance.linkTo,
      'order': instance.order,
      'size': instance.size,
      'textColor': instance.textColor,
      'visibility': instance.visibility,
      'alignment': instance.alignment,
      'corners': instance.corners,
      'height': instance.height,
      'textSize': instance.textSize,
      'width': instance.width,
    };

ShopSystem _$ShopSystemFromJson(Map<String, dynamic> json) {
  return ShopSystem()
    ..channel = json['channel'] as String
    ..createdAt = json['createdAt'] as String
    ..description = json['description'] as String
    ..documentation = json['documentation'] as String
    ..marketplace = json['marketplace'] as String
    ..pluginFiles = (json['pluginFiles'] as List)
        ?.map((e) =>
            e == null ? null : Plugin.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..updatedAt = json['updatedAt'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$ShopSystemToJson(ShopSystem instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'createdAt': instance.createdAt,
      'description': instance.description,
      'documentation': instance.documentation,
      'marketplace': instance.marketplace,
      'pluginFiles': instance.pluginFiles,
      'updatedAt': instance.updatedAt,
      '_id': instance.id,
    };

Plugin _$PluginFromJson(Map<String, dynamic> json) {
  return Plugin()
    ..createdAt = json['createdAt'] as String
    ..filename = json['filename'] as String
    ..maxCmsVersion = json['maxCmsVersion'] as String
    ..minCmsVersion = json['minCmsVersion'] as String
    ..updatedAt = json['updatedAt'] as String
    ..version = json['version'] as String
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$PluginToJson(Plugin instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'filename': instance.filename,
      'maxCmsVersion': instance.maxCmsVersion,
      'minCmsVersion': instance.minCmsVersion,
      'updatedAt': instance.updatedAt,
      'version': instance.version,
      '_id': instance.id,
    };

APIkey _$APIkeyFromJson(Map<String, dynamic> json) {
  return APIkey()
    ..businessId = json['businessId'] as String
    ..createdAt = json['createdAt'] as String
    ..grants = (json['grants'] as List)?.map((e) => e as String)?.toList()
    ..id = json['id'] as String
    ..isActive = json['isActive'] as bool
    ..name = json['name'] as String
    ..redirectUri = json['redirectUri'] as String
    ..scopes = (json['scopes'] as List)?.map((e) => e as String)?.toList()
    ..secret = json['secret'] as String
    ..updatedAt = json['updatedAt'] as String
    ..user = json['user'] as String;
}

Map<String, dynamic> _$APIkeyToJson(APIkey instance) => <String, dynamic>{
      'businessId': instance.businessId,
      'createdAt': instance.createdAt,
      'grants': instance.grants,
      'id': instance.id,
      'isActive': instance.isActive,
      'name': instance.name,
      'redirectUri': instance.redirectUri,
      'scopes': instance.scopes,
      'secret': instance.secret,
      'updatedAt': instance.updatedAt,
      'user': instance.user,
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment()
    ..amount = json['amount'] as num
    ..apiCall = json['api_call'] as String
    ..address = json['address'] == null
        ? null
        : PayAddress.fromJson(json['address'] as Map<String, dynamic>)
    ..bankAccount = json['bank_account'] == null
        ? null
        : BankAccount.fromJson(json['bank_account'] as Map<String, dynamic>)
    ..callbackUrl = json['callback_url'] as String
    ..createdAt = json['created_at'] as String
    ..customerTransactionLink = json['customer_transaction_link'] as String
    ..downPayment = json['down_payment'] as num
    ..flashBag = json['flash_bag'] as List
    ..id = json['id'] as String
    ..merchantTransactionLink = json['merchant_transaction_link'] as String
    ..noticeUrl = json['notice_url'] as String
    ..paymentData = json['payment_data'] as String
    ..paymentDetails = json['payment_details'] == null
        ? null
        : PaymentDetails.fromJson(
            json['payment_details'] as Map<String, dynamic>)
    ..paymentDetailsToken = json['payment_details_token'] as String
    ..paymentFlowId = json['payment_flow_id'] as String
    ..paymentOptionId = json['payment_option_id'] as num
    ..reference = json['reference'] as String
    ..rememberMe = json['remember_me'] as bool
    ..shopRedirectEnabled = json['shop_redirect_enabled'] as bool
    ..specificStatus = json['specific_status'] as String
    ..status = json['status'] as String
    ..storeName = json['store_name'] as String
    ..total = json['total'] as num
    ..businessId = json['businessId'] as String
    ..businessName = json['businessName'] as String
    ..channel = json['channel'] as String
    ..channelSetId = json['channelSetId'] as String
    ..currency = json['currency'] as String
    ..customerEmail = json['customerEmail'] as String
    ..customerName = json['customerName'] as String
    ..deliveryFee = json['deliveryFee'] as num
    ..flowId = json['flowId'] as String
    ..paymentFee = json['paymentFee'] as num
    ..paymentType = json['paymentType'] as String;
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'amount': instance.amount,
      'api_call': instance.apiCall,
      'address': instance.address,
      'bank_account': instance.bankAccount,
      'callback_url': instance.callbackUrl,
      'created_at': instance.createdAt,
      'customer_transaction_link': instance.customerTransactionLink,
      'down_payment': instance.downPayment,
      'flash_bag': instance.flashBag,
      'id': instance.id,
      'merchant_transaction_link': instance.merchantTransactionLink,
      'notice_url': instance.noticeUrl,
      'payment_data': instance.paymentData,
      'payment_details': instance.paymentDetails,
      'payment_details_token': instance.paymentDetailsToken,
      'payment_flow_id': instance.paymentFlowId,
      'payment_option_id': instance.paymentOptionId,
      'reference': instance.reference,
      'remember_me': instance.rememberMe,
      'shop_redirect_enabled': instance.shopRedirectEnabled,
      'specific_status': instance.specificStatus,
      'status': instance.status,
      'store_name': instance.storeName,
      'total': instance.total,
      'businessId': instance.businessId,
      'businessName': instance.businessName,
      'channel': instance.channel,
      'channelSetId': instance.channelSetId,
      'currency': instance.currency,
      'customerEmail': instance.customerEmail,
      'customerName': instance.customerName,
      'deliveryFee': instance.deliveryFee,
      'flowId': instance.flowId,
      'paymentFee': instance.paymentFee,
      'paymentType': instance.paymentType,
    };

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) {
  return BankAccount()
    ..bic = json['bic'] as String
    ..iban = json['iban'] as String;
}

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'bic': instance.bic,
      'iban': instance.iban,
    };

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) {
  return PaymentDetails()
    ..merchantBankAccount = json['merchant_bank_account'] as String
    ..merchantBankAccountHolder = json['merchant_bank_account_holder'] as String
    ..merchantBankCity = json['merchant_bank_city'] as String
    ..merchantBankCode = json['merchant_bank_code'] as String
    ..merchantBankName = json['merchant_bank_name'] as String
    ..merchantCompanyName = json['merchant_company_name'] as String;
}

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
    <String, dynamic>{
      'merchant_bank_account': instance.merchantBankAccount,
      'merchant_bank_account_holder': instance.merchantBankAccountHolder,
      'merchant_bank_city': instance.merchantBankCity,
      'merchant_bank_code': instance.merchantBankCode,
      'merchant_bank_name': instance.merchantBankName,
      'merchant_company_name': instance.merchantCompanyName,
    };

PayResult _$PayResultFromJson(Map<String, dynamic> json) {
  return PayResult()
    ..createdAt = json['created_at'] as String
    ..id = json['id'] as String
    ..options = json['options'] == null
        ? null
        : Options.fromJson(json['options'] as Map<String, dynamic>)
    ..payment = json['payment'] == null
        ? null
        : Payment.fromJson(json['payment'] as Map<String, dynamic>)
    ..paymentDetails = json['paymentDetails'] == null
        ? null
        : PayResultDetails.fromJson(
            json['paymentDetails'] as Map<String, dynamic>)
    ..paymentItems = json['paymentItems'];
}

Map<String, dynamic> _$PayResultToJson(PayResult instance) => <String, dynamic>{
      'created_at': instance.createdAt,
      'id': instance.id,
      'options': instance.options,
      'payment': instance.payment,
      'paymentDetails': instance.paymentDetails,
      'paymentItems': instance.paymentItems,
    };

PayAddress _$PayAddressFromJson(Map<String, dynamic> json) {
  return PayAddress()
    ..city = json['city'] as String
    ..country = json['country'] as String
    ..email = json['email'] as String
    ..firstName = json['firstName'] as String
    ..lastName = json['lastName'] as String
    ..phone = json['phone'] as String
    ..salutation = json['salutation'] as String
    ..street = json['street'] as String
    ..streetName = json['streetName'] as String
    ..streetNumber = json['streetNumber'] as String
    ..zipCode = json['zipCode'] as String;
}

Map<String, dynamic> _$PayAddressToJson(PayAddress instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'salutation': instance.salutation,
      'street': instance.street,
      'streetName': instance.streetName,
      'streetNumber': instance.streetNumber,
      'zipCode': instance.zipCode,
    };

Options _$OptionsFromJson(Map<String, dynamic> json) {
  return Options()
    ..merchantCoversFee = json['merchantCoversFee'] as bool ?? false
    ..shopRedirectEnabled = json['shopRedirectEnabled'] as bool ?? false;
}

Map<String, dynamic> _$OptionsToJson(Options instance) => <String, dynamic>{
      'merchantCoversFee': instance.merchantCoversFee,
      'shopRedirectEnabled': instance.shopRedirectEnabled,
    };

PayResultDetails _$PayResultDetailsFromJson(Map<String, dynamic> json) {
  return PayResultDetails()
    ..chargeId = json['chargeId'] as String
    ..iban = json['iban'] as String
    ..mandateReference = json['mandateReference'] as String
    ..mandateUrl = json['mandateUrl'] as String
    ..sourceId = json['sourceId'] as String;
}

Map<String, dynamic> _$PayResultDetailsToJson(PayResultDetails instance) =>
    <String, dynamic>{
      'chargeId': instance.chargeId,
      'iban': instance.iban,
      'mandateReference': instance.mandateReference,
      'mandateUrl': instance.mandateUrl,
      'sourceId': instance.sourceId,
    };
