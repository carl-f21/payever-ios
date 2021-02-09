export 'app_style.dart';
export 'common_utils.dart';
export 'device.dart';
export 'env.dart';
export 'translations.dart';
export 'validators.dart';

String getKind(String key) {
  switch(key) {
    case 'marketing':
      return 'mail';
    case 'settings':
      return 'settings';
    case 'shipping':
      return 'shipping';
    case 'pos':
      return 'pos';
    case 'products':
      return 'products';
    case 'contacts':
      return 'contacts';
    case 'checkout':
      return 'checkout';
    case 'theme':
      return 'theme';
    case 'connect':
      return 'connect';
    case 'transactions':
      return 'transactions';
    case 'shops':
      return 'shop';
  }
  return key;
}

String getIconsOfKind(String key) {
  switch(key) {
    case 'shop':
      return 'store';
  }
  return key;
}