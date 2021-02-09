import 'utils.dart';

class Env {
  static String storage;
  static String users;
  static String business;
  static String auth;
  static String widgets;
  static String wallpapers;
  static String commerceOs;
  static String common;
  static String commerceOsBack;
  static String transactions;
  static String pos;
  static String connect;
  static String checkout;
  static String checkoutPhp;
  static String media;
  static String builder;
  static String products;
  static String inventory;
  static String shops;
  static String plugins;
  static String wrapper;
  static String employees;
  static String appRegistry;
  static String qr;
  static String devicePayments;
  static String cdn;
  static String cdnImage;
  static String cdnIcon;
  static String thirdParty;
  static String thirdPartyCommunication;
  static String thirdPartyPayment;
  static String paymentStripe;
  static String paymentInstantPayment;
  static String paymentSantanderNl;
  static String backendBuilder;
  static String builderShop;
  static String notifications;
  static String shop;
  static String contacts;
  static String financeExpressPhp;
  static String financeExpress;

  Env.map(dynamic obj) {
    Env.users = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_USER];
    Env.business = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_BUSINESS];
    Env.auth = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_AUTH];
    Env.storage = obj[GlobalUtils.ENV_CUSTOM][GlobalUtils.ENV_STORAGE];
    Env.widgets = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_WIDGET];
    Env.transactions =
        obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_TRANSACTIONS];
    Env.wallpapers = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_WALLPAPER];
    Env.commerceOs = obj[GlobalUtils.ENV_FRONTEND][GlobalUtils.ENV_COMMERCE_OS];
    Env.common = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_COMMON];
    Env.commerceOsBack =
        obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_COMMERCE_OS];
    Env.pos = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_POS];
    Env.plugins = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_BACKEND_PLUGINS];
    Env.connect = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_CONNECT];
    Env.checkout = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_CHECKOUT];
    Env.checkoutPhp = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_CHECKOUT_PHP];
    Env.media = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_MEDIA];
    Env.products = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_PRODUCTS];
    Env.inventory = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_INVENTORY];
    Env.shops = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_SHOPS];
    Env.shop = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_SHOP];
    Env.builder = obj[GlobalUtils.ENV_FRONTEND][GlobalUtils.ENV_BUILDER_CLIENT];
    Env.wrapper = obj[GlobalUtils.ENV_FRONTEND][GlobalUtils.ENV_WRAPPER];
    Env.employees = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_EMPLOYEES];
    Env.appRegistry = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_APP_REGISTRY];
    Env.qr = obj[GlobalUtils.ENV_CONNECT][GlobalUtils.ENV_CONNECT_QR];
    Env.devicePayments = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_BACKEND_DEVICE_PAYMENT];
    Env.cdn = obj[GlobalUtils.ENV_CUSTOM][GlobalUtils.ENV_CUSTOM_CDN];
    Env.thirdParty = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_THIRD_PARTY];
    Env.thirdPartyCommunication = obj[GlobalUtils.ENV_THIRD_PARTY][GlobalUtils.ENV_THIRD_PARTY_COMMUNICATIONS];
    Env.thirdPartyPayment = obj[GlobalUtils.ENV_THIRD_PARTY][GlobalUtils.ENV_THIRD_PARTY_PAYMENT];
    Env.paymentStripe = obj[GlobalUtils.ENV_PAYMENT][GlobalUtils.ENV_PAYMENT_STRIPE];
    Env.paymentInstantPayment = obj[GlobalUtils.ENV_PAYMENT][GlobalUtils.ENV_PAYMENT_INSTANT_PAYMENT];
    Env.paymentSantanderNl = obj[GlobalUtils.ENV_PAYMENT][GlobalUtils.ENV_PAYMENT_SANTANDERNL];

    Env.backendBuilder = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_BUILDER];
    Env.builderShop = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_BUILDER_SHOP];
    Env.notifications = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_NOTIFICATIONS];

    Env.contacts = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_CONTACTS];

    Env.financeExpressPhp = obj[GlobalUtils.ENV_PHP][GlobalUtils.ENV_FINANCE_EXPRESS];

    Env.cdnImage = '${obj[GlobalUtils.ENV_CUSTOM][GlobalUtils.ENV_CUSTOM_CDN]}/images/';
    Env.cdnIcon = '${obj[GlobalUtils.ENV_CUSTOM][GlobalUtils.ENV_CUSTOM_CDN]}/icons-png/';
  }
}
