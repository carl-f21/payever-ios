import 'package:json_annotation/json_annotation.dart';
import 'package:payever/commons/utils/common_utils.dart';
part 'connect.g.dart';

class ConnectModel {
  String createdAt;
  bool installed;
  String updatedAt;
  String businessId;
  ConnectIntegration integration;
  num __v;
  String id;

  ConnectModel.toMap(dynamic obj) {
    createdAt = obj[GlobalUtils.DB_CONNECT_CREATED_AT];
    installed = obj[GlobalUtils.DB_CONNECT_INSTALLED];
    businessId = obj['businessId'];
    updatedAt = obj[GlobalUtils.DB_CONNECT_UPDATED_AT];
    __v = obj[GlobalUtils.DB_CONNECT_V];
    id = obj[GlobalUtils.DB_CONNECT_ID];
    dynamic integrationObj = obj[GlobalUtils.DB_CONNECT_INTEGRATION];
    if (integrationObj != null) {
      integration = ConnectIntegration.toMap(integrationObj);
    }
  }
}

class ConnectIntegration {
  List<dynamic> allowedBusinesses = [];
  String category;
  IntegrationExtension connect;
  String createdAt;
  ConnectDisplayOptions displayOptions;
  bool enabled;
  ConnectInstallationOptions installationOptions;
  IntegrationExtension extension;
  String name;
  num order;
  List<ReviewModel> reviews = [];
  num timesInstalled;
  String updatedAt;
  List<dynamic> versions = [];
  String id;
  ConnectIntegration.toMap(dynamic obj) {
    createdAt = obj[GlobalUtils.DB_CONNECT_CREATED_AT];
    updatedAt = obj[GlobalUtils.DB_CONNECT_UPDATED_AT];
    category = obj[GlobalUtils.DB_CONNECT_CATEGORY];
    enabled = obj[GlobalUtils.DB_CONNECT_ENABLED];
    name = obj[GlobalUtils.DB_CONNECT_NAME];
    order = obj[GlobalUtils.DB_CONNECT_ORDER];
    timesInstalled = obj[GlobalUtils.DB_CONNECT_TIMES_INSTALLED];
    id = obj[GlobalUtils.DB_CONNECT_ID];

    List<dynamic> allowedBusinessesObj = obj[GlobalUtils.DB_CONNECT_ALLOWED_BUSINESSES];
    if (allowedBusinessesObj != null) {
      allowedBusinessesObj.forEach((element) {
        allowedBusinesses.add(element);
      });
    }

    List<dynamic> versionsObj = obj[GlobalUtils.DB_CONNECT_VERSIONS];
    if (versionsObj != null) {
      versionsObj.forEach((element) {
        versions.add(element);
      });
    }

    List<dynamic> reviewsObj = obj[GlobalUtils.DB_CONNECT_REVIEWS];
    if (reviewsObj != null) {
      reviewsObj.forEach((element) {
        reviews.add(ReviewModel.toMap(element));
      });
    }

    dynamic connectObj = obj[GlobalUtils.DB_CONNECT];
    if (connectObj != null) {
      connect = IntegrationExtension.fromMap(connectObj);
    }

    dynamic displayOptionsObj = obj[GlobalUtils.DB_CONNECT_DISPLAY_OPTIONS];
    if (displayOptionsObj != null) {
      displayOptions = ConnectDisplayOptions.toMap(displayOptionsObj);
    }

    dynamic installationOptionsObj = obj[GlobalUtils.DB_CONNECT_INSTALLATION_OPTIONS];
    if (installationOptionsObj != null) {
      installationOptions = ConnectInstallationOptions.toMap(installationOptionsObj);
    }
    dynamic extensionObj = obj['extension'];
    if (extensionObj is Map) {
      extension = IntegrationExtension.fromMap(extensionObj);
    }
  }
}

class IntegrationExtension {
  FormAction formAction;
  String url;

  IntegrationExtension.fromMap(dynamic obj) {
    dynamic formActionObj = obj['formAction'];
    if (formActionObj is Map) {
      formAction = FormAction.fromMap(formActionObj);
    }
    url = obj['url'];
  }

}

class FormAction {
  String endpoint;
  String method;

  FormAction.fromMap(dynamic obj) {
    endpoint = obj['endpoint'];
    method = obj['method'];
  }
}

class ConnectDisplayOptions {
  String icon;
  String title;
  String id;

  ConnectDisplayOptions.toMap(dynamic obj) {
    icon = obj[GlobalUtils.DB_CONNECT_ICON];
    title = obj[GlobalUtils.DB_CONNECT_TITLE];
    id = obj[GlobalUtils.DB_CONNECT_ID];
  }
}

class ConnectInstallationOptions {
  String appSupport;
  String category;
  List<String> countryList = [];
  String description;
  String developer;
  String languages;
  List<LinkModel> links = [];
  String optionIcon;
  String price;
  String pricingLink;
  String website;
  String id;

  ConnectInstallationOptions.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_CONNECT_ID];
    appSupport = obj[GlobalUtils.DB_CONNECT_APP_SUPPORT];
    category = obj[GlobalUtils.DB_CONNECT_CATEGORY];
    description = obj[GlobalUtils.DB_CONNECT_DESCRIPTION];
    developer = obj[GlobalUtils.DB_CONNECT_DEVELOPER];
    languages = obj[GlobalUtils.DB_CONNECT_LANGUAGES];
    optionIcon = obj[GlobalUtils.DB_CONNECT_OPTION_ICON];
    price = obj[GlobalUtils.DB_CONNECT_PRICE];
    pricingLink = obj[GlobalUtils.DB_CONNECT_PRICE_LINK];
    website = obj[GlobalUtils.DB_CONNECT_WEBSITE];

    List countryListObj = obj[GlobalUtils.DB_CONNECT_COUNTRY_LIST];
    if (countryListObj != null) {
      countryListObj.forEach((element) {
        countryList.add(element.toString());
      });
    }

    List linksObj = obj[GlobalUtils.DB_CONNECT_LINKS];
    if (linksObj != null) {
      linksObj.forEach((element) {
        links.add(LinkModel.toMap(element));
      });
    }

  }
}

class ReviewModel {
  num rating;
  String reviewDate;
  String text;
  String title;
  String userFullName;
  String userId;
  String id;

  ReviewModel.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_CONNECT_ID];
    rating = obj[GlobalUtils.DB_CONNECT_RATING];
    reviewDate = obj[GlobalUtils.DB_CONNECT_REVIEW_DATE];
    text = obj[GlobalUtils.DB_CONNECT_TEXT];
    title = obj[GlobalUtils.DB_CONNECT_TITLE];
    userFullName = obj[GlobalUtils.DB_CONNECT_USER_FULL_NAME];
    userId = obj[GlobalUtils.DB_CONNECT_USER_ID];
  }
}

class LinkModel {
  String type;
  String url;
  String id;

  LinkModel.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_CONNECT_ID];
    type = obj[GlobalUtils.DB_CONNECT_TYPE];
    url = obj[GlobalUtils.DB_CONNECT_URL];
  }

}

@JsonSerializable()
class CheckoutPaymentOption {
  @JsonKey(name: 'accept_fee')
  bool acceptFee = false;
  @JsonKey(name: 'contract_length')
  num contractLength;
  @JsonKey(name: 'description_fee')
  String descriptionFee;
  @JsonKey(name: 'description_offer')
  String descriptionOffer;
  @JsonKey(name: 'fixed_fee')
  num fixedFee;
  @JsonKey(name: 'id')
  num id;
  @JsonKey(name: 'image_primary_filename')
  String imagePrimaryFilename;
  @JsonKey(name: 'image_secondary_filename')
  String imageSecondaryFilename;
  @JsonKey(name: 'instruction_text')
  String instructionText;
  @JsonKey(name: 'max')
  num max;
  @JsonKey(name: 'merchant_allowed_countries')
  dynamic merchantAllowedCountries;
  @JsonKey(name: 'min')
  num min;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'options')
  CurrencyOption options;
  @JsonKey(name: 'payment_method')
  String paymentMethod;
  @JsonKey(name: 'related_country')
  String relatedCountry;
  @JsonKey(name: 'related_country_name')
  String relatedCountryName;
  @JsonKey(name: 'settings')
  dynamic settings;
  @JsonKey(name: 'slug')
  String slug;
  @JsonKey(name: 'status')
  String status;
  @JsonKey(name: 'thumbnail1')
  String thumbnail1;
  @JsonKey(name: 'thumbnail2')
  String thumbnail2;
  @JsonKey(name: 'variable_fee')
  num variableFee;
  @JsonKey(name: 'variants')
  List<Variant> variants = [];

  bool isCheckedAds = false;

  CheckoutPaymentOption();
  factory CheckoutPaymentOption.fromJson(Map<String, dynamic> json) => _$CheckoutPaymentOptionFromJson(json);
  Map<String, dynamic> toJson() => _$CheckoutPaymentOptionToJson(this);

}

@JsonSerializable()
class CurrencyOption {
  @JsonKey(name: 'countries')
  List<String> countries = [];
  @JsonKey(name: 'currencies')
  List<String> currencies = [];

  CurrencyOption();

  factory CurrencyOption.fromJson(Map<String, dynamic> json) => _$CurrencyOptionFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyOptionToJson(this);
}

class PaymentVariant {
  MissingSteps missingSteps;
  List<Variant> variants = [];

  PaymentVariant.fromMap(dynamic obj) {
    if (obj['missing_steps'] != null) {
      missingSteps = MissingSteps.fromMap(obj['missing_steps']);
    }
    if (obj['variants'] != null) {
      List listObj = obj['variants'];
      listObj.forEach((element) {
        variants.add(Variant.fromJson(element));
      });
    }
  }
}

@JsonSerializable()
class Variant {
  @JsonKey(name: 'accept_fee')
  bool acceptFee;
  @JsonKey(name: 'completed')
  bool completed;
  @JsonKey(name: 'credentials')
  dynamic credentials;
  @JsonKey(name: 'credentials_valid')
  bool credentialsValid;
  @JsonKey(name: 'default')
  bool isDefault;
  @JsonKey(name: 'fixed_fee')
  num fixedFee;
  @JsonKey(name: 'general_status')
  String generalStatus;
  @JsonKey(name: 'id')
  num id;
  @JsonKey(name: 'max')
  num max;
  @JsonKey(name: 'min')
  num min;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'options')
  dynamic options;
  @JsonKey(name: 'payment_method')
  String paymentMethod;
  @JsonKey(name: 'payment_option_id')
  num paymentOptionId;
  @JsonKey(name: 'shop_redirect_enabled')
  bool shopRedirectEnabled;
  @JsonKey(name: 'status')
  String status;
  @JsonKey(name: 'uuid')
  String uuid;
  @JsonKey(name: 'variable_fee')
  num variableFee;

  Variant();

  factory Variant.fromJson(Map<String, dynamic> json) => _$VariantFromJson(json);

  Map<String, dynamic> toJson() => _$VariantToJson(this);
}

class MissingStep {
  String errorMessage;
  bool filled = false;
  String message;
  bool openDialog = false;
  String type;
  String url;

  MissingStep.fromMap(dynamic obj) {
    errorMessage = obj['error_message'];
    filled = obj['filled'];
    message = obj['message'];
    openDialog = obj['open_dialog'];
    type = obj['type'];
    url = obj['url'];
  }
}

class MissingSteps {
  num id;
  List<MissingStep> missingSteps = [];
  String successMessage;

  MissingSteps.fromMap(dynamic obj) {
    id = obj['id'];
    if (obj['missing_steps'] != null) {
      List listObj = obj['missing_steps'];
      listObj.forEach((element) {
        missingSteps.add(MissingStep.fromMap(element));
      });
    }
    successMessage = obj['success_message'];
  }
}

class InformationData {
  String title;
  String detail;

  InformationData({
    this.title,
    this.detail,
  });
}