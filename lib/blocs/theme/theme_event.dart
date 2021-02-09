import 'package:equatable/equatable.dart';

abstract class ChangeThemeEvent {}

class DecideTheme extends ChangeThemeEvent {}

class LightTheme extends ChangeThemeEvent {
  @override
  String toString() => 'Light Theme';
}

class DefaultTheme extends ChangeThemeEvent {
  @override
  String toString() => 'Default Theme';
}

class DarkTheme extends ChangeThemeEvent {
  @override
  String toString() => 'Dark Theme';
}
