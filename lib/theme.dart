import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

const Color primaryColor = Color(0xFF000000);
const Color secondaryColor = Color(0xFFFFFFFF);

final ThemeData lightTheme = _buildLightTheme();
final ThemeData defaultTheme = _buildDefaultTheme();
final ThemeData darkTheme = _buildDarkTheme();
ThemeData _buildLightTheme() {
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final Color overlayColor = Color.fromRGBO(245, 245, 245, 0.6);
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    brightness: Brightness.light,
    accentColorBrightness: Brightness.dark,
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    splashColor: Colors.transparent,
    accentColor: const Color(0xFF444444),
    cursorColor: const Color(0xFF000000),
    accentIconTheme: new IconThemeData(color: const Color(0xFF000000)),
    errorColor: const Color(0xFFB00020),
    textTheme: base.textTheme.copyWith().apply(
      fontFamily: 'Helvetica Neue',
      bodyColor: const Color(0xFF000000),
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}

ThemeData _buildDefaultTheme() {
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final Color overlayColor = Color.fromRGBO(0, 0, 0, 0.75);
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    brightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    primaryColor: primaryColor,
    cardColor: Color(0xFF121A26),
    primaryColorDark: const Color(0xFF0050a0),
    primaryColorLight: secondaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    splashColor: Colors.transparent,
    accentColor: const Color(0xFFFFFFFF),
    cursorColor: const Color(0xFFFFFFFF),
    accentIconTheme: new IconThemeData(color: const Color(0xFFFFFFFF)),
    textTheme: base.textTheme.copyWith().apply(
      fontFamily: 'Helvetica Neue',
      bodyColor: const Color(0xFFFFFFFF),
    ),
    toggleableActiveColor: secondaryColor,
    canvasColor: const Color(0xFF000000),
    scaffoldBackgroundColor: const Color(0xFF000000),
    backgroundColor: const Color(0xFF000000),
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}

ThemeData _buildDarkTheme() {
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final Color overlayColor = Color.fromRGBO(0, 0, 0, 0.75);
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    brightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    primaryColor: primaryColor,
    cardColor: Color(0xFF121A26),
    primaryColorDark: const Color(0xFF0050a0),
    primaryColorLight: secondaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    splashColor: Colors.transparent,
    accentColor: const Color(0xFFBBBBBB),
    cursorColor: const Color(0xFFFFFFFF),
    accentIconTheme: new IconThemeData(color: const Color(0xFFFFFFFF)),
    textTheme: base.textTheme.copyWith().apply(
      fontFamily: 'Helvetica Neue',
      bodyColor: const Color(0xFFFFFFFF),
    ),
    toggleableActiveColor: secondaryColor,
    canvasColor: const Color(0xFF000000),
    scaffoldBackgroundColor: const Color(0xFF000000),
    backgroundColor: const Color(0xFF000000),
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
Color overlayColor() {
  if (GlobalUtils.theme == 'dark') {
    return Color.fromRGBO(0, 0, 0, 0.75);
//    return colorConvert('#1f1f1f');
  } else if (GlobalUtils.theme == 'light') {
    return Color.fromRGBO(240, 240, 240, 0.6);
  } else {
    return Color.fromRGBO(0, 0, 0, 0.2);
  }
}

Color iconColor() {
  if (GlobalUtils.theme == 'dark') {
    return Color.fromRGBO(255, 255, 255, 1);
  } else if (GlobalUtils.theme == 'light') {
    return Color.fromRGBO(0, 0, 0, 1);
  } else {
    return Color.fromRGBO(255, 255, 255, 1);
  }
}

Color overlayBackground() {
  if (GlobalUtils.theme == 'dark') {
    return Color.fromRGBO(0, 0, 0, 0.3);
  } else if (GlobalUtils.theme == 'light') {
    return Color.fromRGBO(245, 245, 245, 0.6);
  } else {
    return Color.fromRGBO(0, 0, 0, 0.2);
  }
}

Color overlaySecondAppBar() {
  if (GlobalUtils.theme == 'dark') {
    return Color(0xFF212122);
  } else if (GlobalUtils.theme == 'light') {
    return Color(0xFF212122);
  } else {
    return Color(0xFF212122);
  }
}

Color overlayButtonBackground() {
  if (GlobalUtils.theme == 'dark') {
    return Color.fromRGBO(255, 255, 255, 0.1);
  } else if (GlobalUtils.theme == 'light') {
    return Color.fromRGBO(227, 227, 227, 1);
  } else {
    return Color.fromRGBO(0, 0, 0, 0.2);
  }
}

Color overlaySwitcherBackground() {
  return Color.fromRGBO(227, 227, 227, 1);
}

Color overlayFilterViewBackground() {
  if (GlobalUtils.theme == 'dark') {
    return Color.fromRGBO(30, 30, 30, 1);
  } else if (GlobalUtils.theme == 'light') {
    return Color.fromRGBO(227, 227, 227, 1);
  } else {
    return Color.fromRGBO(40, 40, 40, 1);
  }
}

Color overlayDashboardAppsBackground() {
  if (GlobalUtils.theme == 'dark') {
    return Color.fromRGBO(0, 0, 0, 0.3);
  } else if (GlobalUtils.theme == 'light') {
    return Color.fromRGBO(29, 29, 32, 1);
  } else {
    return Color.fromRGBO(0, 0, 0, 0.2);
  }
}

Color overlayDashboardButtonsBackground() {
  if (GlobalUtils.theme == 'dark') {
    return Color.fromRGBO(255, 255, 255, 0.1);
  } else if (GlobalUtils.theme == 'light') {
    return Color.fromRGBO(29, 29, 32, 1);
  } else {
    return Color.fromRGBO(0, 0, 0, 0.2);
  }
}

Color overlayDashboardNotificationBtnBgColor() {
  if (GlobalUtils.theme == 'dark') {
    return Color.fromRGBO(255, 255, 255, 0.2);
  } else if (GlobalUtils.theme == 'light') {
    return Color.fromRGBO(95, 95, 95, 1);
  } else {
    return Color.fromRGBO(0, 0, 0, 0.2);
  }
}


Color overlaySection() {
  if (GlobalUtils.theme == 'dark') {
    return Color.fromRGBO(0, 0, 0, 0.75);
  } else if (GlobalUtils.theme == 'light') {
    return Color.fromRGBO(245, 245, 245, 0.6);
  } else {
    return Color.fromRGBO(0, 0, 0, 0.2);
  }
}

Color overlayRow() {
  if (GlobalUtils.theme == 'dark') {
    return overlayBackground().withOpacity(0.01);
  } else if (GlobalUtils.theme == 'light') {
    return overlayBackground().withOpacity(0.01);
  } else {
    return overlayBackground().withOpacity(0.01);
  }
}


String iconString() {
  return '${Env.cdnIcon}icons-apps-${GlobalUtils.theme == 'light' ? 'black' : 'white'}/icon-apps-${GlobalUtils.theme == 'light' ? 'black' : 'white'}-';
}

Color colorConvert(String color, {bool emptyColor = false}) {
  if (color == null)
    return Colors.white;

  color = color.replaceAll("#", "");
  if (color.length == 6) {
    return Color(int.parse("0xFF"+color));
  } else if (color.length == 8) {
//    return Color(int.parse("0x"+color));
    return Color(int.parse("0xFF"+color.substring(0, 6)));
  } else {
    return emptyColor ? Colors.transparent :Colors.white;
  }
}