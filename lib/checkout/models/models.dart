import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Checkout {
  Checkout();

  @JsonKey(name: 'businessId')    String businessId = '';
  @JsonKey(name: 'connections')   List<String> connections = [];
  @JsonKey(name: 'createdAt')     String createdAt;
  @JsonKey(name: 'default')       bool isDefault = false;
  @JsonKey(name: 'logo')          String logo = '';
  @JsonKey(name: 'name')          String name = '';
  @JsonKey(name: 'sections')      List<Section> sections = [];
  @JsonKey(name: 'settings')      CheckoutSettings settings;
  @JsonKey(name: 'updatedAt')     String updatedAt = '';
  @JsonKey(name: '__v')           num v = 0;
  @JsonKey(name: '_id')           String id = '';

  factory Checkout.fromJson(Map<String, dynamic> json) => _$CheckoutFromJson(json);
  Map<String, dynamic> toJson() => _$CheckoutToJson(this);
}

@JsonSerializable()
class Section {
  Section();

  @JsonKey(name: 'code')                String code = '';
  @JsonKey(name: 'defaultEnabled')      bool defaultEnabled;
  @JsonKey(name: 'enabled')             bool enabled;
  @JsonKey(name: 'fixed')               bool fixed;
  @JsonKey(name: 'order')               num order = 0;
  @JsonKey(name: '_id')                 String id = '';
  @JsonKey(name: 'excluded_channels')   List<String> excludedChannels = [];
  @JsonKey(name: 'subsections')         List<SubSection> subsections = [];

  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);
  Map<String, dynamic> toJson() => _$SectionToJson(this);
}

@JsonSerializable()
class SubSection {
  SubSection();

  @JsonKey(name: 'code')  String code;
  @JsonKey(name: 'rules') List<Rule> rules = [];
  @JsonKey(name: '_id')   String id;

  factory SubSection.fromJson(Map<String, dynamic> json) => _$SubSectionFromJson(json);
  Map<String, dynamic> toJson() => _$SubSectionToJson(this);
}

@JsonSerializable()
class Rule {
  Rule();

  @JsonKey(name: 'operator')  String operator;
  @JsonKey(name: 'property')  String property;
  @JsonKey(name: 'type')      String type;
  @JsonKey(name: '_id')       String id;

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
  Map<String, dynamic> toJson() => _$RuleToJson(this);
}

@JsonSerializable()
class CheckoutSettings {
  CheckoutSettings();

  @JsonKey(name: 'cspAllowedHosts')   List<String> cspAllowedHosts = [];
  @JsonKey(name: 'languages')         List<Lang> languages = [];
  @JsonKey(name: 'message')           String message = '';
  @JsonKey(name: 'phoneNumber')       String phoneNumber = '';
  @JsonKey(name: 'styles')            Style styles;
  @JsonKey(name: 'testingMode')       bool testingMode = false;

  factory CheckoutSettings.fromJson(Map<String, dynamic> json) => _$CheckoutSettingsFromJson(json);
  // Map<String, dynamic> toJson() => _$CheckoutSettingsToJson(this);

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['cspAllowedHosts'] = cspAllowedHosts;
    List<Map<String, dynamic>>langs = [];
    languages.forEach((element) {
      langs.add(element.toJson());
    });
    map['languages'] = langs;
    map['message'] = message;
    map['phoneNumber'] = phoneNumber;
    if (styles != null)
      map['styles'] = styles.toDictionary();
    map['testingMode'] = testingMode;
    return {'settings':map};
  }
}

@JsonSerializable()
class Lang {
  Lang();

  @JsonKey(name: 'active')          bool active = false;
  @JsonKey(name: 'code')            String code = '';
  @JsonKey(name: 'isDefault',)      bool isDefault = false;
  @JsonKey(name: 'isHovered')       bool isHovered = false;
  @JsonKey(name: 'isToggleButton')  bool isToggleButton = false;
  @JsonKey(name: 'name')            String name = '';
  @JsonKey(name: 'id')              String id = '';

  factory Lang.fromJson(Map<String, dynamic> json) => _$LangFromJson(json);
  Map<String, dynamic> toJson() => _$LangToJson(this);
}

@JsonSerializable()
class Style {
  Style();

  @JsonKey(name: 'button')                          ButtonStyle button = ButtonStyle();
  @JsonKey(name: 'page')                            PageStyle page = PageStyle();
  @JsonKey(name: 'id')                              String id = '';
  @JsonKey(name: '_id')                             String id1 = '';
  @JsonKey(name: 'active')                          bool active = true;
  @JsonKey(name: 'businessHeaderBackgroundColor')   String businessHeaderBackgroundColor = '#fff';
  @JsonKey(name: 'businessHeaderBorderColor')       String businessHeaderBorderColor = '#dfdfdf';
  @JsonKey(name: 'buttonBackgroundColor')           String buttonBackgroundColor = '#333333';
  @JsonKey(name: 'buttonBackgroundDisabledColor')   String buttonBackgroundDisabledColor = '#656565';
  @JsonKey(name: 'buttonBorderRadius')              String buttonBorderRadius = '4px';
  @JsonKey(name: 'buttonTextColor')                 String buttonTextColor = '#ffffff';
  @JsonKey(name: 'inputBackgroundColor')            String inputBackgroundColor = '#ffffff';
  @JsonKey(name: 'inputBorderColor')                String inputBorderColor = '#dfdfdf';
  @JsonKey(name: 'inputBorderRadius')               String inputBorderRadius = '4px';
  @JsonKey(name: 'inputTextPrimaryColor')           String inputTextPrimaryColor = '#3a3a3a';
  @JsonKey(name: 'inputTextSecondaryColor')         String inputTextSecondaryColor = '#999999';
  @JsonKey(name: 'pageBackgroundColor')             String pageBackgroundColor = '#f7f7f7';
  @JsonKey(name: 'pageLineColor')                   String pageLineColor = '#dfdfdf';
  @JsonKey(name: 'pageTextLinkColor')               String pageTextLinkColor = '#444444';
  @JsonKey(name: 'pageTextPrimaryColor')            String pageTextPrimaryColor = '#777777';
  @JsonKey(name: 'pageTextSecondaryColor')          String pageTextSecondaryColor = '#8e8e8e';

  factory Style.fromJson(Map<String, dynamic> json) => _$StyleFromJson(json);
  // Map<String, dynamic> toJson() => _$StyleToJson(this);

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    if (button != null)
      map['button'] = button.toDictionary();
    if (page != null)
      map['page'] = page.toJson();
    map['id'] = id;
    map['_id'] = id1;
    map['active'] = active;
    map['businessHeaderBackgroundColor'] = businessHeaderBackgroundColor;
    map['businessHeaderBorderColor'] = businessHeaderBorderColor;
    map['buttonBackgroundColor'] = buttonBackgroundColor;
    map['buttonBackgroundDisabledColor'] = buttonBackgroundDisabledColor;
    map['buttonBorderRadius'] = buttonBorderRadius;
    map['buttonTextColor'] = buttonTextColor;
    map['inputBackgroundColor'] = inputBackgroundColor;
    map['inputBorderColor'] = inputBorderColor;
    map['inputBorderRadius'] = inputBorderRadius;
    map['inputTextPrimaryColor'] = inputTextPrimaryColor;
    map['inputTextSecondaryColor'] = inputTextSecondaryColor;
    map['pageBackgroundColor'] = pageBackgroundColor;
    map['pageLineColor'] = pageLineColor;
    map['pageTextLinkColor'] = pageTextLinkColor;
    map['pageTextPrimaryColor'] = pageTextPrimaryColor;
    map['pageTextSecondaryColor'] = pageTextSecondaryColor;

    return map;
  }
}

@JsonSerializable()
class PageStyle {
  PageStyle();

  @JsonKey(name: 'background')  String background = '#ffffff';

  factory PageStyle.fromJson(Map<String, dynamic> json) => _$PageStyleFromJson(json);
  Map<String, dynamic> toJson() => _$PageStyleToJson(this);
}

@JsonSerializable()
class ButtonStyle {
  ButtonStyle();

  @JsonKey(name: 'corners')   String corners = 'round-32';
  @JsonKey(name: 'color')     ButtonColorStyle color = ButtonColorStyle();

  factory ButtonStyle.fromJson(Map<String, dynamic> json) => _$ButtonStyleFromJson(json);
  // Map<String, dynamic> toJson() => _$ButtonStyleToJson(this);

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['corners'] = corners;
    if (color != null)
      map['color'] = color.toJson();
    return map;
  }
}

@JsonSerializable()
class ButtonColorStyle {
  ButtonColorStyle();

  @JsonKey(name: 'borders')   String borders = '#fff';
  @JsonKey(name: 'fill')      String fill = '#fff';
  @JsonKey(name: 'text')      String text = '#fff';

  factory ButtonColorStyle.fromJson(Map<String, dynamic> json) => _$ButtonColorStyleFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonColorStyleToJson(this);
}

@JsonSerializable()
class CheckoutFlow {
  CheckoutFlow();

  @JsonKey(name: 'businessUuid')    String businessUuid = '';
  @JsonKey(name: 'channelType')     String channelType = '';
  @JsonKey(name: 'currency')        String currency = '';
  @JsonKey(name: 'customPolicy')    bool customPolicy = false;
  @JsonKey(name: 'languages')       List<Lang> languages = [];
  @JsonKey(name: 'limits')          dynamic limits = {};
  @JsonKey(name: 'logo')            String logo = '';
  @JsonKey(name: 'message')         String message = '';
  @JsonKey(name: 'name')            String name = '';
  @JsonKey(name: 'paymentMethods')  List<String> paymentMethods = [];
  @JsonKey(name: 'phoneNumber')     String phoneNumber = '';
  @JsonKey(name: 'policyEnabled')   bool policyEnabled = false;
  @JsonKey(name: 'sections')        List<Section> sections = [];
  @JsonKey(name: 'styles')          Style styles;
  @JsonKey(name: 'testingMode')     bool testingMode = false;
  @JsonKey(name: 'uuid')            String uuid = '';

  factory CheckoutFlow.fromJson(Map<String, dynamic> json) => _$CheckoutFlowFromJson(json);
  Map<String, dynamic> toJson() => _$CheckoutFlowToJson(this);
}

@JsonSerializable()
class ChannelSetFlow {
  @JsonKey(name: 'accept_terms_payever')          String acceptTermsPayever;
  @JsonKey(name: 'amount', defaultValue: 0)       num amount;
  @JsonKey(name: 'api_call')                      String apiCall;
  @JsonKey(name: 'api_call_cart')                 String apiCallCart;
  @JsonKey(name: 'api_call_id')                   String apiCallId;
  @JsonKey(name: 'billing_address')               BillingAddress billingAddress;
  @JsonKey(name: 'business_address_line')         String businessAddressLine;
  @JsonKey(name: 'business_iban')                 String businessIban;
  @JsonKey(name: 'business_id')                   String businessId;
  @JsonKey(name: 'business_logo')                 String businessLogo;
  @JsonKey(name: 'business_name')                 String businessName;
  @JsonKey(name: 'business_shipping_option_id')   String businessShippingOptionId;
  @JsonKey(name: 'can_identify_by_ssn')           bool canIdentifyBySsn = false;
  @JsonKey(name: 'cancel_url')                    String cancelUrl;
  @JsonKey(name: 'cart')                          List<CartItem> cart = [];
  @JsonKey(name: 'channel')                       String channel;
  @JsonKey(name: 'channel_set_id')                String channelSetId;
  @JsonKey(name: 'client_id')                     String clientId;
  @JsonKey(name: 'comment')                       String comment;
  @JsonKey(name: 'connection_id')                 String connectionId;
  @JsonKey(name: 'countries')                     Map<String, String> countries = {};
  @JsonKey(name: 'currency')                      String currency;
  @JsonKey(name: 'different_address')             bool differentAddress = false;
  @JsonKey(name: 'express')                       bool express = false;
  @JsonKey(name: 'extra')                         dynamic extra;
  @JsonKey(name: 'failure_url')                   String failureUrl;
  @JsonKey(name: 'finance_type')                  String financeType;
  @JsonKey(name: 'flash_bag')                     List flashBag = [];
  @JsonKey(name: 'flow_identifier')               String flowIdentifier;
  @JsonKey(name: 'force_legacy_cart_step')        bool forceLegacyCartStep = false;
  @JsonKey(name: 'force_legacy_use_inventory')    bool forceLegacyUseInventory = false;
  @JsonKey(name: 'guest_token')                   String guestToken;
  @JsonKey(name: 'hide_salutation')               bool hideSalutation = false;
  @JsonKey(name: 'id')                            String id;
  @JsonKey(name: 'ip_hash')                       String ipHash;
  @JsonKey(name: 'logged_in_id')                  String loggedInId;
  @JsonKey(name: 'merchant_reference')            String merchantReference;
  @JsonKey(name: 'notice_url')                    String noticeUrl;
  @JsonKey(name: 'payment')                       Payment payment;
  @JsonKey(name: 'payment_method')                String paymentMethod;
  @JsonKey(name: 'payment_option_id')             num paymentOptionId;
  @JsonKey(name: 'payment_options')               List<CheckoutPaymentOption> paymentOptions = [];
  @JsonKey(name: 'pending_url')                   String pendingUrl;
  @JsonKey(name: 'pos_merchant_mode')             String posMerchantMode;
  @JsonKey(name: 'reference')                     String reference;
  @JsonKey(name: 'seller_email')                  String sellerEmail;
  @JsonKey(name: 'shipping_address_id')           String shippingAddressId;
  @JsonKey(name: 'shipping_addresses')            List shippingAddresses = [];
  @JsonKey(name: 'shipping_category')             String shippingCategory;
  @JsonKey(name: 'shipping_fee')                  num shippingFee = 0;
  @JsonKey(name: 'shipping_method_code')          String shippingMethodCode;
  @JsonKey(name: 'shipping_method_name')          String shippingMethodName;
  @JsonKey(name: 'shipping_option_name')          String shippingOptionName;
  @JsonKey(name: 'shipping_options')              List shippingOptions = [];
  @JsonKey(name: 'shipping_order_id')             String shippingOrderId;
  @JsonKey(name: 'shipping_type')                 String shippingType;
  @JsonKey(name: 'shop_url')                      String shopUrl;
  @JsonKey(name: 'single_address')                bool singleAddress = false;
  @JsonKey(name: 'state')                         String state;
  @JsonKey(name: 'success_url')                   String successUrl;
  @JsonKey(name: 'tax_value')                     num taxValue = 0;
  @JsonKey(name: 'total')                         num total = 0;
  @JsonKey(name: 'user_account_id')               String userAccountId;
  @JsonKey(name: 'values')                        dynamic values;
  @JsonKey(name: 'variant_id')                    String variantId;
  @JsonKey(name: 'x_frame_host')                  String xFrameHost;

  ChannelSetFlow();
  factory ChannelSetFlow.fromJson(Map<String, dynamic> json) => _$ChannelSetFlowFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelSetFlowToJson(this);
}

@JsonSerializable()
class IntegrationModel {
  IntegrationModel();

  @JsonKey(name: 'integration')   String integration;
  @JsonKey(name: '_id')           String id;

  factory IntegrationModel.fromJson(Map<String, dynamic> json) => _$IntegrationModelFromJson(json);
  Map<String, dynamic> toJson() => _$IntegrationModelToJson(this);
}

@JsonSerializable()
class FinanceExpressSetting {
  FinanceExpressSetting();

  @JsonKey(name: 'banner-and-rate')   FinanceExpress bannerAndRate;
  @JsonKey(name: 'bubble')            FinanceExpress bubble;
  @JsonKey(name: 'button')            FinanceExpress button;
  @JsonKey(name: 'text-link')         FinanceExpress textLink;

  factory FinanceExpressSetting.fromJson(Map<String, dynamic> json) => _$FinanceExpressSettingFromJson(json);
  Map<String, dynamic> toJson() => _$FinanceExpressSettingToJson(this);
}

@JsonSerializable()
class FinanceExpress {
  FinanceExpress();

  @JsonKey(name: 'adaptiveDesign')    bool adaptiveDesign = false;
  @JsonKey(name: 'bgColor')           String bgColor = '#fff';
  @JsonKey(name: 'borderColor')       String borderColor = '#fff';
  @JsonKey(name: 'buttonColor')       String buttonColor = '#fff';
  @JsonKey(name: 'displayType')       String displayType = '';
  @JsonKey(name: 'linkColor')         String linkColor = '#fff';
  @JsonKey(name: 'linkTo')            String linkTo = '';
  @JsonKey(name: 'order')             String order = 'asc';
  @JsonKey(name: 'size')              num size = 0;
  @JsonKey(name: 'textColor')         String textColor = '#fff';
  @JsonKey(name: 'visibility')        bool visibility = true;
  @JsonKey(name: 'alignment')         String alignment = 'center';
  @JsonKey(name: 'corners')           String corners = 'round';
  @JsonKey(name: 'height')            num height = 0;
  @JsonKey(name: 'textSize')          String textSize = '';
  @JsonKey(name: 'width')             num width = 0;

  factory FinanceExpress.fromJson(Map<String, dynamic> json) => _$FinanceExpressFromJson(json);
  Map<String, dynamic> toJson() => _$FinanceExpressToJson(this);
}

@JsonSerializable()
class ShopSystem {
  ShopSystem();

  @JsonKey(name: 'channel')         String channel;
  @JsonKey(name: 'createdAt')       String createdAt;
  @JsonKey(name: 'description')     String description;
  @JsonKey(name: 'documentation')   String documentation;
  @JsonKey(name: 'marketplace')     String marketplace;
  @JsonKey(name: 'pluginFiles')     List<Plugin>pluginFiles = [];
  @JsonKey(name: 'updatedAt')       String updatedAt;
  @JsonKey(name: '_id')             String id;

  factory ShopSystem.fromJson(Map<String, dynamic> json) => _$ShopSystemFromJson(json);
  Map<String, dynamic> toJson() => _$ShopSystemToJson(this);
}

@JsonSerializable()
class Plugin {
  Plugin();

  @JsonKey(name: 'createdAt')       String createdAt;
  @JsonKey(name: 'filename')        String filename;
  @JsonKey(name: 'maxCmsVersion')   String maxCmsVersion;
  @JsonKey(name: 'minCmsVersion')   String minCmsVersion;
  @JsonKey(name: 'updatedAt')       String updatedAt;
  @JsonKey(name: 'version')         String version;
  @JsonKey(name: '_id')             String id;

  factory Plugin.fromJson(Map<String, dynamic> json) => _$PluginFromJson(json);
  Map<String, dynamic> toJson() => _$PluginToJson(this);
}

@JsonSerializable()
class APIkey {
  APIkey();

  @JsonKey(name: 'businessId')    String businessId;
  @JsonKey(name: 'createdAt')     String createdAt;
  @JsonKey(name: 'grants')        List<String> grants = [];
  @JsonKey(name: 'id')            String id;
  @JsonKey(name: 'isActive')      bool isActive = true;
  @JsonKey(name: 'name')          String name;
  @JsonKey(name: 'redirectUri')   String redirectUri;
  @JsonKey(name: 'scopes')        List<String> scopes =[];
  @JsonKey(name: 'secret')        String secret;
  @JsonKey(name: 'updatedAt')     String updatedAt;
  @JsonKey(name: 'user')          String user;

  factory APIkey.fromJson(Map<String, dynamic> json) => _$APIkeyFromJson(json);
  Map<String, dynamic> toJson() => _$APIkeyToJson(this);
}

class ChannelItem {
  String name;
  String title;
  SvgPicture image;
  String button;
  bool checkValue;
  ConnectModel model;

  ChannelItem({
    this.name,
    this.title,
    this.image,
    this.button,
    this.checkValue,
    this.model,
  });
}

@JsonSerializable()
class Payment {
  Payment();

  @JsonKey(name: 'amount')                      num amount;
  @JsonKey(name: 'api_call')                    String apiCall;
  @JsonKey(name: 'address')                     PayAddress address;
  @JsonKey(name: 'bank_account')                BankAccount bankAccount;
  @JsonKey(name: 'callback_url')                String callbackUrl;
  @JsonKey(name: 'created_at')                  String createdAt;
  @JsonKey(name: 'customer_transaction_link')   String customerTransactionLink;
  @JsonKey(name: 'down_payment')                num downPayment;
  @JsonKey(name: 'flash_bag')                   List<dynamic>flashBag;
  @JsonKey(name: 'id')                          String id;
  @JsonKey(name: 'merchant_transaction_link')   String merchantTransactionLink;
  @JsonKey(name: 'notice_url')                  String noticeUrl;
  @JsonKey(name: 'payment_data')                String paymentData;
  @JsonKey(name: 'payment_details')             PaymentDetails paymentDetails;
  @JsonKey(name: 'payment_details_token')       String paymentDetailsToken;
  @JsonKey(name: 'payment_flow_id')             String paymentFlowId;
  @JsonKey(name: 'payment_option_id')           num paymentOptionId;
  @JsonKey(name: 'reference')                   String reference;
  @JsonKey(name: 'remember_me')                 bool rememberMe;
  @JsonKey(name: 'shop_redirect_enabled')       bool shopRedirectEnabled;
  @JsonKey(name: 'specific_status')             String specificStatus;
  @JsonKey(name: 'status')                      String status;
  @JsonKey(name: 'store_name')                  String storeName;
  @JsonKey(name: 'total')                       num total;

  @JsonKey(name: 'businessId')                  String businessId;
  @JsonKey(name: 'businessName')                String businessName;
  @JsonKey(name: 'channel')                     String channel;
  @JsonKey(name: 'channelSetId')                String channelSetId;
  @JsonKey(name: 'currency')                    String currency;
  @JsonKey(name: 'customerEmail')               String customerEmail;
  @JsonKey(name: 'customerName')                String customerName;
  @JsonKey(name: 'deliveryFee')                 num deliveryFee;
  @JsonKey(name: 'flowId')                      String flowId;
  @JsonKey(name: 'paymentFee')                  num paymentFee;
  @JsonKey(name: 'paymentType')                 String paymentType;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class BankAccount {
  BankAccount();

  @JsonKey(name: 'bic')   String bic;
  @JsonKey(name: 'iban')  String iban;

  factory BankAccount.fromJson(Map<String, dynamic> json) => _$BankAccountFromJson(json);
  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}

@JsonSerializable()
class PaymentDetails {
  PaymentDetails();

  @JsonKey(name: 'merchant_bank_account')           String merchantBankAccount;
  @JsonKey(name: 'merchant_bank_account_holder')    String merchantBankAccountHolder;
  @JsonKey(name: 'merchant_bank_city')              String merchantBankCity;
  @JsonKey(name: 'merchant_bank_code')              String merchantBankCode;
  @JsonKey(name: 'merchant_bank_name')              String merchantBankName;
  @JsonKey(name: 'merchant_company_name')           String merchantCompanyName;

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => _$PaymentDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentDetailsToJson(this);
}


@JsonSerializable()
class PayResult {
  PayResult();

  @JsonKey(name: 'created_at')          String createdAt;
  @JsonKey(name: 'id')                  String id;
  @JsonKey(name: 'options')             Options options;
  @JsonKey(name: 'payment')             Payment payment;
  @JsonKey(name: 'paymentDetails')      PayResultDetails paymentDetails;
  @JsonKey(name: 'paymentItems')        dynamic paymentItems;

  factory PayResult.fromJson(Map<String, dynamic> json) => _$PayResultFromJson(json);
  Map<String, dynamic> toJson() => _$PayResultToJson(this);
}

@JsonSerializable()
class PayAddress {
  PayAddress();

  @JsonKey(name: 'city')            String city;
  @JsonKey(name: 'country')         String country;
  @JsonKey(name: 'email')           String email;
  @JsonKey(name: 'firstName')       String firstName;
  @JsonKey(name: 'lastName')        String lastName;
  @JsonKey(name: 'phone')           String phone;
  @JsonKey(name: 'salutation')      String salutation;
  @JsonKey(name: 'street')          String street;
  @JsonKey(name: 'streetName')      String streetName;
  @JsonKey(name: 'streetNumber')    String streetNumber;
  @JsonKey(name: 'zipCode')         String zipCode;

  factory PayAddress.fromJson(Map<String, dynamic> json) => _$PayAddressFromJson(json);
  Map<String, dynamic> toJson() => _$PayAddressToJson(this);
}

@JsonSerializable()
class Options {
  Options();

  @JsonKey(name: 'merchantCoversFee', defaultValue: false)      bool merchantCoversFee;
  @JsonKey(name: 'shopRedirectEnabled', defaultValue: false)    bool shopRedirectEnabled;

  factory Options.fromJson(Map<String, dynamic> json) => _$OptionsFromJson(json);
  Map<String, dynamic> toJson() => _$OptionsToJson(this);
}

@JsonSerializable()
class PayResultDetails {
  PayResultDetails();

  @JsonKey(name: 'chargeId')              String chargeId;
  @JsonKey(name: 'iban')                  String iban;
  @JsonKey(name: 'mandateReference')      String mandateReference;
  @JsonKey(name: 'mandateUrl')            String mandateUrl;
  @JsonKey(name: 'sourceId')              String sourceId;

  factory PayResultDetails.fromJson(Map<String, dynamic> json) => _$PayResultDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$PayResultDetailsToJson(this);
}

String getTitleFromCode(String code) {
  switch (code) {
    case 'order':
      return 'Order';
    case 'send_to_device':
      return 'Send To Device';
    case 'choosePayment':
      return 'Choose Payment';
    case 'payment':
      return 'Payment Detail';
    case 'address':
      return 'Address';
    case 'user':
      return 'User Detail';
  }
  return '';
}

enum Finance {TEXT_LINK, BUTTON, CALCULATOR, BUBBLE}
const Map<Finance, String> FinanceType = {
  Finance.TEXT_LINK: 'text-link',
  Finance.BUTTON: 'button',
  Finance.CALCULATOR: 'banner-and-rate',
  Finance.BUBBLE: 'bubble',
};

