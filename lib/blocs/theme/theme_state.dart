import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/theme.dart';

class ChangeThemeState {
  final ThemeData themeData;
  final String theme;

  ChangeThemeState({@required this.themeData, this.theme});

  factory ChangeThemeState.lightTheme() {
    GlobalUtils.theme = 'light';
    return ChangeThemeState(themeData: lightTheme, theme: 'light');
  }

  factory ChangeThemeState.defaultTheme() {
    GlobalUtils.theme = 'default';
    return ChangeThemeState(themeData: defaultTheme, theme: 'default');
  }

  factory ChangeThemeState.darkTheme() {
    GlobalUtils.theme = 'dark';
    return ChangeThemeState(themeData: darkTheme, theme: 'dark');
  }
}
