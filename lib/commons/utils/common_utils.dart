import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/models/token.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils.dart';

//class Styles {
//  static TextStyle noAvatarPhone = TextStyle(
//    color: Colors.white.withOpacity(0.7),
//    fontSize: Measurements.height * 0.035,
//    fontWeight: FontWeight.w500,
//  );
//  static TextStyle noAvatarTablet = TextStyle(
//    color: Colors.white.withOpacity(0.7),
//    fontSize: Measurements.height * 0.025,
//    fontWeight: FontWeight.w500,
//  );
//}

class Measurements {
  static double height;
  static double width;
  static dynamic iconsRoutes;

  static void loadImages(context) {
    DefaultAssetBundle.of(context)
        .loadString('assets/images/images_routes.json', cache: false)
        .then((value) {
      iconsRoutes = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
  }

  static String iconRoute(String name) => iconsRoutes[name] ?? '';

  static String currency(String currency) {
    switch (currency.toUpperCase()) {
      case 'EUR':
        return '€';
      case 'USD':
        return 'US\$';
      case 'NOK':
        return 'NOK';
      case 'SEK':
        return 'SEK';
      case 'GBP':
        return '£';
      case 'DKK':
        return 'DKK';
      case 'CHF':
        return 'CHF';
        break;
      default:
        return '€';
    }
  }

  static String channelIcon(String channel) {
    return iconRoute(channel);
  }

  static String channel(String channel) {
    return Language.getTransactionStrings('channels.' + channel);
  }

  static String paymentType(String type) {
    return iconRoute(type);
  }

  static String actions(
      String action, dynamic _event, TransactionDetails _transaction) {
    const String statusChange = '{{ payment_status }}';
    const String amount = '{{ amount }}';
    const String reference = '{{ reference }}';
    const String upload = '{{ upload_type }}';

    var f = new NumberFormat('###,###,###.00', 'en_US');
    switch (action) {
      case 'refund':
        return Language.getTransactionStrings(
                'details.history.action.refund.amount')
            .replaceFirst('$amount',
                '${Measurements.currency(_transaction.transaction.currency)}${f.format(_event.amount ?? 0)}');
        break;
      case 'statuschanged':
        return Language.getTransactionStrings(
                'details.history.action.statuschanged')
            .replaceFirst(
                '$statusChange',
                Language.getTransactionStatusStrings(
                    'transactions_specific_statuses.' +
                        _transaction.status.general));
        break;
      case 'change_amount':
        return Language.getTransactionStrings(
                'details.history.action.change_amount')
            .replaceFirst('$amount', _event.amount ?? 0);
        break;
      case 'upload':
        return Language.getTransactionStrings('details.history.action.upload')
            .replaceFirst('$upload', _event.upload ?? '');
        break;
      case 'capture_with_amount':
        return Language.getTransactionStrings(
                'details.history.action.capture_with_amount')
            .replaceFirst('$amount', _event.amount ?? 0);
        break;
      case 'capture_with_amount':
        return Language.getTransactionStrings(
                'details.history.action.change_amount')
            .replaceFirst('$amount', _event.amount ?? 0);
        break;
      case 'change_reference':
        return Language.getTransactionStrings(
                'details.history.action.change_reference')
            .replaceFirst('$reference', _event.reference ?? '');
        break;
      default:
        return Language.getTransactionStrings('details.history.action.$action');
    }
  }

  static String historyStatus(String status) {
    return Language.getTransactionStrings('filters.status.' + status);
  }

  static String paymentTypeName(String type) {
    if (type.isNotEmpty)
      return Language.getTransactionStrings('filters.type.' + type);
    else
      return '';
  }

  static Widget statusWidget(String status) {
    switch (status) {
      case 'STATUS_IN_PROCESS':
        return AutoSizeText(
          Language.getTransactionStrings(status),
          minFontSize: 10,
          maxLines: 2,
          style: TextStyle(
            color: Colors.orange,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      case 'STATUS_ACCEPTED':
        return AutoSizeText(
          Language.getTransactionStrings(status),
          minFontSize: 10,
          maxLines: 2,
          style: TextStyle(
            color: Colors.lightGreen,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      case 'STATUS_NEW':
        return AutoSizeText(
          Language.getTransactionStrings(status),
          minFontSize: 10,
          maxLines: 2,
          style: TextStyle(
            color: Colors.orange,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      case 'STATUS_REFUNDED':
        return AutoSizeText(
          Language.getTransactionStrings(status),
          minFontSize: 10,
          maxLines: 2,
          style: TextStyle(
            color: Colors.orange,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      case 'STATUS_FAILED':
        return AutoSizeText(
          Language.getTransactionStrings(status),
          minFontSize: 10,
          maxLines: 2,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      case 'STATUS_PAID':
        return AutoSizeText(
          Language.getTransactionStrings(status),
          minFontSize: 10,
          maxLines: 2,
          style: TextStyle(
            color: Colors.lightGreen,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      case 'STATUS_DECLINED':
        return AutoSizeText(
          Language.getTransactionStrings(status),
          minFontSize: 10,
          maxLines: 2,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      case 'STATUS_CANCELLED':
        return AutoSizeText(
          Language.getTransactionStrings(status),
          minFontSize: 10,
          maxLines: 2,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      default:
        return AutoSizeText(
          Language.getTransactionStrings(status),
          minFontSize: 10,
          maxLines: 2,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
    }
  }

  static String salutation(String salutation) {
    return Language.getTransactionStrings('salutation.$salutation');
  }

  static paymentTypeIcon(String type, bool isTablet) {
    double size = Measurements.width * (isTablet ? 0.03 : 0.055);
    print(size);
    return SvgPicture.asset(
      Measurements.paymentType(type),
      height: AppStyle.iconDashboardCardSize(isTablet),
      color: iconColor(),
    );
  }

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static String initials(String name) {
    String displayName;
    if (name.contains(' ')) {
      displayName = name.substring(0, 1);
      displayName = displayName + name.split(' ')[1].substring(0, 1);
    } else {
      displayName = name.substring(0, 1) + name.substring(name.length - 1);
    }
    return displayName = displayName.toUpperCase();
  }
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 9), radix: 16) + 0xFF000000);
}

enum Appearance {
  Light,
  Dark,
  Default
}

class GlobalUtils {
  static Token activeToken;
  static BuildContext currentContext;
  static bool isLoaded = false;
  static var isDashboardLoaded = false;
  static String fingerprint = '';
  static String theme = changeThemeBloc.state.theme;
  static bool isConnected = true;
  static bool isBusinessMode = true;
  static Appearance appearance = Appearance.Default;
  // Global Params
  // static User user;
  // static Business currentBusiness;
  // static String wallpaper;
  //
  // static List<Terminal> terminals;
  // static Terminal activeTerminal;
  //
  // static List<ChannelSet> channelSets;
  // static Checkout defaultCheckout;
  //
  // static List<ProductsModel> products;
  // static List<CollectionModel> collections;
  //URLS
  //static String  pass= 'P@ssword123';//test 1
  // static String  pass= 'Test1234!';//staging 1
  static String  pass= '';//live 0
  //static String pass = 'Payever2019!'; //live 1
  //static String  pass = 'Payever123!';//test 2
  //static String  pass= '12345678';//staging 2

  //static String  mail= 'payever.automation@gmail.com';//test 1
  // static String  mail= 'rob@top.com';//staging 1
  static String  mail= '';//live 0
  //static String mail = 'abiantgmbh@payever.de'; //live 1
  //static String  mail = 'testcases@payever.de';//test 2
  //static String  mail= 'service@payever.de';//staging 2

  //static const String COMMERCE_OS_URL = 'https://commerceos.test.devpayever.com';//test
  // static const String COMMERCE_OS_URL = 'https://commerceos.staging.devpayever.com';//staging
  static const String COMMERCE_OS_URL = 'https://commerceos.payever.org'; //live

  static const String POS_URL = 'https://getpayever.com/pos';

  static const String FORGOT_PASS = COMMERCE_OS_URL + '/password/forgot';

  //static const String SIGN_UP = COMMERCE_OS_URL+'/entry/registration/business';
  static const String SIGN_UP = 'https://getpayever.com/business/trial';

  static const String termsLink = 'https://getpayever.com/agb?_ga=2.220255708.595830855.1600031280-238550036.1593180292';
  static const String privacyLink = 'https://getpayever.com/about/privacy?_ga=2.155685503.595830855.1600031280-238550036.1593180292';

  static const String googleMapAPIKey = 'AIzaSyDB-7kzuFYxb8resf60yF21TKUkTbGhljc';
  //Preferences Keys
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String USER_ID = 'user_id';
  static const String DEVICE_ID = 'id';
  static const String FINGERPRINT = 'fingerPrint';
  static const String WALLPAPER = 'wallpaper';
  static const String BUSINESS = 'businessid';
  static const String TOKEN = 'TOKEN';
  static const String REFRESH_TOKEN = 'REFRESHTOKEN';
  static const String REFRESH_DATE = 'REFRESHDATE';
  static const String LAST_OPEN = 'lastOpen';
  static const String EVENTS_KEY = 'fetch_events';
  static const String LANGUAGE = 'language';
  // token__

  static const String DB_TOKEN_ACC = 'accessToken';
  static const String DB_TOKEN_RFS = 'refreshToken';

  // user__
  static const String DB_USER_ID = '_id';
  static const String DB_USER_FIRST_NAME = 'firstName';
  static const String DB_USER_LAST_NAME = 'lastName';
  static const String DB_USER_EMAIL = 'email';
  static const String DB_USER_LANGUAGE = 'language';
  static const String DB_USER_CREATED_AT = 'createdAt';
  static const String DB_USER_UPDATED_AT = 'updatedAt';
  static const String DB_USER_BIRTHDAY = 'birthday';
  static const String DB_USER_SALUTATION = 'salutation';
  static const String DB_USER_PHONE = 'phone';
  static const String DB_USER_LOGO = 'logo';

  // business__
  static const String DB_BUSINESS_ID = '_id';
  static const String DB_BUSINESS_CREATE_AT = 'createAt';
  static const String DB_BUSINESS_UPDATED_AT = 'updatedAt';
  static const String DB_BUSINESS_CURRENCY = 'currency';
  static const String DB_BUSINESS_EMAIL = 'email';
  static const String DB_BUSINESS_HIDDEN = 'hidden';
  static const String DB_BUSINESS_LOGO = 'logo';
  static const String DB_BUSINESS_NAME = 'name';
  static const String DB_BUSINESS_ACTIVE = 'active';

  static const String DB_BUSINESS_COMPANY_ADDRESS = 'companyAddress';

  static const String DB_BUSINESS_CA_CITY = 'city';
  static const String DB_BUSINESS_CA_COUNTRY = 'country';
  static const String DB_BUSINESS_CA_CREATED_AT = 'createdAt';
  static const String DB_BUSINESS_CA_UPDATED_AT = 'updatedAt';
  static const String DB_BUSINESS_CA_STREET = 'street';
  static const String DB_BUSINESS_CA_ZIP_CODE = 'zipCode';
  static const String DB_BUSINESS_CA_ID = '_id';

  static const String DB_BUSINESS_CONTACT_DETAILS = 'contactDetails';

  static const String DB_BUSINESS_CNDT_CREATED_AT = 'createdAT';
  static const String DB_BUSINESS_CNDT_FIRST_NAME = 'firstName';
  static const String DB_BUSINESS_CNDT_LAST_NAME = 'lastName';
  static const String DB_BUSINESS_CNDT_UPDATED_AT = 'updatedAt';
  static const String DB_BUSINESS_CNDT_ID = '_id';

  static const String DB_BUSINESS_COMPANY_DETAILS = 'companyDetails';

  static const String DB_BUSINESS_CMDT_CREATED_AT = 'createdAt';
  static const String DB_BUSINESS_CMDT_UPDATED_AT = 'updatedAt';
  static const String DB_BUSINESS_CMDT_FOUNDATION_YEAR = 'foundationYear';
  static const String DB_BUSINESS_CMDT_INDUSTRY = 'industry';
  static const String DB_BUSINESS_CMDT_PRODUCT = 'product';
  static const String DB_BUSINESS_CMDT_ID = '_id';

  static const String DB_BUSINESS_CMDT_EMPLOYEES_RANGE = 'employeesRange';

  static const String DB_BUSINESS_CMDT_EMP_RANGE_MIN = 'min';
  static const String DB_BUSINESS_CMDT_EMP_RANGE_MAX = 'max';
  static const String DB_BUSINESS_CMDT_EMP_RANGE_ID = 'id';

  static const String DB_BUSINESS_CMDT_SALES_RANGE = 'salesRange';

  static const String DB_BUSINESS_CMDT_SALES_RANGE_MIN = 'min';
  static const String DB_BUSINESS_CMDT_SALES_RANGE_MAX = 'max';
  static const String DB_BUSINESS_CMDT_SALES_RANGE_ID = '_id';


  static const String DB_PROD_BUSINESS = 'business';
  static const String DB_PROD_ID = 'id';
  static const String DB_PROD_LAST_SELL = 'lastSell';
  static const String DB_PROD_NAME = 'name';
  static const String DB_PROD_QUANTITY = 'quantity';
  static const String DB_PROD_THUMBNAIL = 'thumbnail';
  static const String DB_PROD_UUID = 'uuid';
  static const String DB_PROD__V = '__v';
  static const String DB_PROD__ID = '__id';

  static const String DB_PROD_MODEL_UUID = 'uuid';
  static const String DB_PROD_MODEL_BARCODE = 'barcode';
  static const String DB_PROD_MODEL_CATEGORIES = 'categories';
  static const String DB_PROD_MODEL_CURRENCY = 'currency';
  static const String DB_PROD_MODEL_VAT_RATE = 'vatRate';
  static const String DB_PROD_MODEL_DESCRIPTION = 'description';
  static const String DB_PROD_MODEL_ENABLE = 'enable';
  static const String DB_PROD_MODEL_HIDDEN = 'hidden';
  static const String DB_PROD_MODEL_ACTIVE = 'active';
  static const String DB_PROD_MODEL_IMAGES = 'images';
  static const String DB_PROD_MODEL_PRICE = 'price';
  static const String DB_PROD_MODEL_SALE_PRICE = 'salePrice';
  static const String DB_PROD_MODEL_SKU = 'sku';
  static const String DB_PROD_MODEL_TITLE = 'title';
  static const String DB_PROD_MODEL_TYPE = 'type';
  static const String DB_PROD_MODEL_SALES = 'onSales';
  static const String DB_PROD_MODEL_VARIANTS = 'variants';
  static const String DB_PROD_MODEL_SHIPPING = 'shipping';
  static const String DB_PROD_MODEL_CHANNEL_SET = 'channelSets';

  static const String DB_PROD_MODEL_SHIP_FREE = 'free';
  static const String DB_PROD_MODEL_SHIP_GENERAL = 'general';
  static const String DB_PROD_MODEL_SHIP_HEIGHT = 'height';
  static const String DB_PROD_MODEL_SHIP_LENGTH = 'length';
  static const String DB_PROD_MODEL_SHIP_WIDTH = 'width';
  static const String DB_PROD_MODEL_SHIP_WEIGHT = 'weight';

  static const String DB_PROD_MODEL_VAR_BARCODE = 'barcode';
  static const String DB_PROD_MODEL_VAR_DESCRIPTION = 'description';
  static const String DB_PROD_MODEL_VAR_HIDDEN = 'hidden';
  static const String DB_PROD_MODEL_VAR_ID = 'id';
  static const String DB_PROD_MODEL_VAR_IMAGES = 'images';
  static const String DB_PROD_MODEL_VAR_PRICE = 'price';
  static const String DB_PROD_MODEL_VAR_SALE_PRICE = 'salePrice';
  static const String DB_PROD_MODEL_VAR_SKU = 'sku';
  static const String DB_PROD_MODEL_VAR_TITLE = 'title';

  static const String DB_PROD_MODEL_CATEGORIES_TITLE = 'title';
  static const String DB_PROD_MODEL_CATEGORIES_SLUG = 'slug';
  static const String DB_PROD_MODEL_CATEGORIES__ID = '_id';
  static const String DB_PROD_MODEL_CATEGORIES_BUSINESS_UUID = 'businessUuid';

  static const String DB_INV_MODEL_BARCODE = 'barcode';
  static const String DB_INV_MODEL_BUSINESS = 'business';
  static const String DB_INV_MODEL_IS_NEGATIVE_ALLOW = 'isNegativeStockAllowed';
  static const String DB_INV_MODEL_CREATED_AT = 'createdAt';
  static const String DB_INV_MODEL_IS_TRACKABLE = 'isTrackable';
  static const String DB_INV_MODEL_SKU = 'sku';
  static const String DB_INV_MODEL_UPDATE_AT = 'updatedAt';
  static const String DB_INV_MODEL_STOCK = 'stock';
  static const String DB_INV_MODEL_RESERVED = 'reserved';
  static const String DB_INV_MODEL_V = '__v';
  static const String DB_INV_MODEL_ID = '_id';

  static const String DB_PROD_INFO = 'info';
  static const String DB_PROD_INFO_PAGINATION = 'pagination';
  static const String DB_PROD_INFO_ITEM_COUNT = 'item_count';
  static const String DB_PROD_INFO_ITEM_PAGE = 'page';
  static const String DB_PROD_INFO_ITEM_PAGE_COUNT = 'page_count';
  static const String DB_PROD_INFO_ITEM_PER_PAGE = 'per_page';

  static const String DB_TUTORIAL_INIT = '\$init';
  static const String DB_TUTORIAL_ICON = 'icon';
  static const String DB_TUTORIAL_ORDER = 'order';
  static const String DB_TUTORIAL_TITLE = 'title';
  static const String DB_TUTORIAL_TYPE = 'type';
  static const String DB_TUTORIAL_URL = 'url';
  static const String DB_TUTORIAL_WATCHED = 'watched';
  static const String DB_TUTORIAL_ID = '_id';

  static const String DB_VERSION_APPLE_STORE = 'appleStoreUrl';
  static const String DB_VERSION_CURRENT_VERSION = 'currentVersion';
  static const String DB_VERSION_MIN_VERSION = 'minVersion';
  static const String DB_VERSION_PLAY_STORE = 'playStoreUrl';

  static const String DB_SETTINGS_WALLPAPER_INDUSTRIES    ='industries';
  static const String DB_SETTINGS_WALLPAPER_CODE          ='code';
  static const String DB_SETTINGS_WALLPAPER_WALLPAPERS    ='wallpapers';

  // env__
  static const String ENV_CUSTOM = 'custom';
  static const String ENV_BACKEND = 'backend';
  static const String ENV_PHP = 'php';
  static const String ENV_AUTH = 'auth';
  static const String ENV_USER = 'users';
  static const String ENV_BUSINESS = 'business';
  static const String ENV_STORAGE = 'storage';
  static const String ENV_WALLPAPER = 'wallpapers';
  static const String ENV_WIDGET = 'widgets';
  static const String ENV_BUILDER = 'builder';
  static const String ENV_BUILDER_CLIENT = 'builderClient';
  static const String ENV_BUILDER_SHOP = 'builderShop';
  static const String ENV_COMMERCE_OS = 'commerceos';
  static const String ENV_COMMON = 'common';
  static const String ENV_FRONTEND = 'frontend';
  static const String ENV_TRANSACTIONS = 'transactions';
  static const String ENV_POS = 'pos';
  static const String ENV_CONNECT = 'connect';
  static const String ENV_CHECKOUT = 'checkout';
  static const String ENV_CHECKOUT_PHP = 'payments';
  static const String ENV_MEDIA = 'media';
  static const String ENV_PRODUCTS = 'products';
  static const String ENV_INVENTORY = 'inventory';
  static const String ENV_SHOP = 'shop';
  static const String ENV_SHOPS = 'shops';
  static const String ENV_WRAPPER = 'checkoutWrapper';
  static const String ENV_EMPLOYEES = 'employees';
  static const String ENV_APP_REGISTRY = 'appRegistry';
  static const String ENV_CONNECT_QR = 'qr';
  static const String ENV_CUSTOM_CDN = 'cdn';
  static const String ENV_BACKEND_DEVICE_PAYMENT = 'devicePayments';
  static const String ENV_THIRD_PARTY = 'thirdParty';
  static const String ENV_THIRD_PARTY_COMMUNICATIONS = 'communications';
  static const String ENV_THIRD_PARTY_PAYMENT = 'payments';
  static const String ENV_PAYMENT = 'payments';
  static const String ENV_PAYMENT_STRIPE = 'stripe';
  static const String ENV_PAYMENT_INSTANT_PAYMENT = 'instantPayment';
  static const String ENV_PAYMENT_SANTANDERNL = 'santanderNl';
  static const String ENV_NOTIFICATIONS = 'notifications';
  static const String ENV_CONTACTS = 'contacts';
  static const String ENV_FINANCE_EXPRESS = 'financeExpress';
  static const String ENV_BACKEND_PLUGINS = 'plugins';

  // dashboard_
  static const String CURRENT_WALLPAPER = 'currentWallpaper';

  // Connect
  static const String DB_CONNECT_INTEGRATION = 'integration';
  static const String DB_CONNECT_CREATED_AT = 'createdAt';
  static const String DB_CONNECT_UPDATED_AT = 'updatedAt';
  static const String DB_CONNECT_INSTALLED = 'installed';
  static const String DB_CONNECT_V = '__v';
  static const String DB_CONNECT_ID = '_id';
  static const String DB_CONNECT_CATEGORY = 'category';
  static const String DB_CONNECT_ENABLED = 'enabled';
  static const String DB_CONNECT_NAME = 'name';
  static const String DB_CONNECT_ORDER = 'order';
  static const String DB_CONNECT = 'connect';
  static const String DB_CONNECT_TIMES_INSTALLED = 'timesInstalled';
  static const String DB_CONNECT_ALLOWED_BUSINESSES = 'allowedBusinesses';
  static const String DB_CONNECT_VERSIONS = 'versions';
  static const String DB_CONNECT_REVIEWS = 'reviews';
  static const String DB_CONNECT_DISPLAY_OPTIONS = 'displayOptions';
  static const String DB_CONNECT_INSTALLATION_OPTIONS = 'installationOptions';
  static const String DB_CONNECT_ICON = 'icon';
  static const String DB_CONNECT_TITLE = 'title';
  static const String DB_CONNECT_APP_SUPPORT = 'appSupport';
  static const String DB_CONNECT_COUNTRY_LIST = 'countryList';
  static const String DB_CONNECT_DESCRIPTION = 'description';
  static const String DB_CONNECT_DEVELOPER = 'developer';
  static const String DB_CONNECT_LANGUAGES = 'languages';
  static const String DB_CONNECT_LINKS = 'links';
  static const String DB_CONNECT_OPTION_ICON = 'optionIcon';
  static const String DB_CONNECT_PRICE = 'price';
  static const String DB_CONNECT_PRICE_LINK = 'pricingLink';
  static const String DB_CONNECT_WEBSITE = 'website';
  static const String DB_CONNECT_RATING = 'rating';
  static const String DB_CONNECT_REVIEW_DATE = 'reviewDate';
  static const String DB_CONNECT_TEXT = 'text';
  static const String DB_CONNECT_USER_FULL_NAME = 'userFullName';
  static const String DB_CONNECT_USER_ID = 'userId';
  static const String DB_CONNECT_TYPE = 'type';
  static const String DB_CONNECT_URL = 'url';


  num rating;
  String reviewDate;
  String text;
  String title;
  String userFullName;
  String userId;

  // fetch wallpaper
  static const String DB_BUSINESS_WALLPAPER_ID = '_id';
  static const String DB_BUSINESS_WALLPAPER_BUSINESS = 'business';
  static const String DB_BUSINESS_WALLPAPER_V = '__v';
  static const String DB_BUSINESS_WALLPAPER_CREATED_AT = 'createdAt';
  static const String DB_BUSINESS_WALLPAPER_INDUSTRY = 'industry';
  static const String DB_BUSINESS_WALLPAPER_PRODUCT = 'product';
  static const String DB_BUSINESS_WALLPAPER_TYPE = 'type';
  static const String DB_BUSINESS_WALLPAPER_UPDATED_AT = 'updatedAt';
  // fetch wallpaper current
  static const String DB_BUSINESS_CURRENT_WALLPAPER = 'currentWallpaper';
  static const String DB_BUSINESS_CURRENT_WALLPAPER_THEME = 'theme';
  static const String DB_BUSINESS_CURRENT_WALLPAPER_ID = '_id';
  static const String DB_BUSINESS_CURRENT_WALLPAPER_WALLPAPER = 'wallpaper';

  // AppWidget_
  static const String APP_WID = 'widgets';
  static const String APP_WID_ID = '_id';
  static const String APP_WID_DEFAULT = 'default';
  static const String APP_WID_ICON = 'icon';
  static const String APP_WID_INSTALLED = 'installed';
  static const String APP_WID_ORDER = 'order';
  static const String APP_WID_TITLE = 'title';
  static const String APP_WID_TYPE = 'type';
  static const String APP_WID_HELP = 'helpUrl';

  static const String APP_WID_LAST_CURRENCY = 'currency';
  static const String APP_WID_LAST_DATE = 'date';
  static const String APP_WID_LAST_AMOUNT = 'amount';

  static const String PAYMENT_CASH = 'cash';
  static const String PAYMENT_PAYPAL = 'paypal';
  static const String PAYMENT_STRIPE = 'stripe';
  static const String PAYMENT_STRIPE_DIRECT = 'stripe_directdebit';
  static const String PAYMENT_INSTANT = 'instant_payment';
  static const String PAYMENT_SANTANDER_POS_INSTALLMENT = 'santander_pos_installment';
  static const String PAYMENT_SANTANDER_FACTORING = 'santander_pos_factoring';
  static const String PAYMENT_SANTANDER_INVOICE = 'santander_invoice';
  static const String PAYMENT_SANTANDER_POS_INVOICE = 'santander_pos_invoice';
  static const String PAYMENT_SANTANDER_INSTALLMENT = 'santander_installment';
  static const String PAYMENT_SANTANDER_CCP_INSTALLMANT = 'santander_ccp_installment';
  static const String PAYMENT_PAYEX_FAKTURA = 'payex_faktura';

  static void setCredentials({String email, String password, Token tokenData}) async {
    GlobalUtils.activeToken = tokenData;
    SharedPreferences.getInstance().then((p) {
      if (email != null && email.isNotEmpty)
        p.setString(GlobalUtils.EMAIL, email);

      if (password != null && password.isNotEmpty)
        p.setString(GlobalUtils.PASSWORD, password);

      p.setString(GlobalUtils.TOKEN, tokenData.accessToken);
      p.setString(GlobalUtils.REFRESH_TOKEN, tokenData.refreshToken);
    });
    print('REFRESH TOKEN = ${tokenData.refreshToken}');
  }

  static void clearCredentials() async {
    SharedPreferences.getInstance().then((p) {
      p.setString(GlobalUtils.BUSINESS, '');
      p.setString(GlobalUtils.WALLPAPER, '');
      p.setString(GlobalUtils.EMAIL, '');
      p.setString(GlobalUtils.PASSWORD, '');
      p.setString(GlobalUtils.DEVICE_ID, '');
      p.setString(GlobalUtils.DB_TOKEN_ACC, '');
      p.setString(GlobalUtils.DB_TOKEN_RFS, '');
    });
  }

  static List<String> positionsListOptions() {
    List<String> positions = List<String>();
    positions.add('Cashier');
    positions.add('Sales');
    positions.add('Marketing');
    positions.add('Staff');
    positions.add('Admin');
    positions.add('Others');
    return positions;
  }

  static bool isPortrait(BuildContext context) {
    bool _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    return _isPortrait;
  }

  static bool isTablet(BuildContext context) {
    bool _isPortrait = GlobalUtils.isPortrait(context);
    bool isTablet;

    if (_isPortrait)
      isTablet = MediaQuery.of(context).size.width > 600;
    else
      isTablet = MediaQuery.of(context).size.height > 600;
    if (mainWidth == 0) {
      mainWidth = isTablet ? Measurements.width * 0.7 : Measurements.width;
    }
    return isTablet;
  }
  static double mainWidth = 0;
}

String imageBase = Env.storage + '/images/';
String wallpaperBase = Env.storage + '/wallpapers/';


Future<List<Country>> prepareDefaultCountries() async {
  List<Country> countries;
  try {
    countries = await IsoCountries.iso_countries;
  } on PlatformException {
    countries = null;
  }
  return countries;
}

Future<Country> getCountryForCodeWithIdentifier(
    String code, String localeIdentifier) async {
  Country _country;
  try {
    _country = await IsoCountries.iso_country_for_code_for_locale(code,
        locale_identifier: localeIdentifier);
  } on PlatformException {
    _country = null;
  }
  return _country;
}

String getCountryCode(String countryName, List<Country> countryList) {
  return countryList.where((element) => element.name == countryName).toList().first.countryCode;
}

Color authScreenBgColor() {
  return GlobalUtils.theme == 'light'
      ? Colors.white
      : Colors.black.withOpacity(0.7);
}

BoxDecoration authBtnDecoration() {
  return BoxDecoration(
    shape: BoxShape.rectangle,
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(31, 31, 31, 1),
        Color.fromRGBO(15, 15, 15, 1)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(8.0),
    ),
  );
}

class MenuItem {
  final String title;
  final Color textColor;
  final Widget icon;
  final Function onTap;

  MenuItem({
    this.title,
    this.icon,
    this.textColor = Colors.black,
    this.onTap,
  });
}

List<MenuItem> gridListPopUpActions(Function onTapGrid) {
  return [
    MenuItem(
      title: 'List',
      icon: SvgPicture.asset(
        'assets/images/list.svg',
        color: iconColor(),
      ),
      onTap:() {onTapGrid(false);}
    ),
    MenuItem(
      title: 'Grid',
      icon: SvgPicture.asset(
        'assets/images/grid.svg',
        color: iconColor(),
      ),
      onTap: () {onTapGrid(true);},
    ),
  ];
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

// TextField Attributes
TextStyle textFieldStyle = TextStyle(fontSize: 13,fontWeight: FontWeight.w500,);

TextStyle errorTextFieldColor = TextStyle(color: Colors.redAccent);

InputDecoration textFieldDecoration(String label, {Widget prefixIcon}) {
  if (prefixIcon != null) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      contentPadding:
      EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorStyle: errorTextFieldColor,
    );
  }
  return InputDecoration(
    contentPadding:
    EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    labelText: label,
    labelStyle: TextStyle(
      color: Colors.grey,
      fontSize: 12,
    ),
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorStyle: errorTextFieldColor,
  );
}

final formatter = new NumberFormat('###,###,###.00', 'en_US');

String getDisplayName(String name) {
  String displayName;
  if (name.contains(' ')) {
    displayName = name.substring(0, 1);
    displayName = displayName + name.split(' ')[1].substring(0, 1);
  } else {
    displayName = name.substring(0, 1) + name.substring(name.length - 1);
    displayName = displayName.toUpperCase();
  }
  return displayName;
}