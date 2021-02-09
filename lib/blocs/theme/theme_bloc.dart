import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/theme/theme_event.dart';
import 'package:payever/blocs/theme/theme_state.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {
  void onLightThemeChange() => LightTheme();
  void onDarkThemeChange() => DarkTheme();
  void onDefaultThemeChange() => DefaultTheme();
  void onDecideThemeChange() => DecideTheme();
  @override
  ChangeThemeState get initialState => ChangeThemeState.lightTheme();

  @override
  Stream<ChangeThemeState> mapEventToState(ChangeThemeEvent event) async* {
    print('inside Theme data');
    if (event is DecideTheme) {
      print('inside Theme decision body');
      final int optionValue = await getOption();
      if (optionValue == 0) {
        yield ChangeThemeState.lightTheme();
      } else if (optionValue == 1) {
        yield ChangeThemeState.darkTheme();
      } else {
        yield ChangeThemeState.defaultTheme();
      }
    } else if (event is DarkTheme) {
      print('inside darktheme body');

      GlobalUtils.theme = 'dark';
      yield ChangeThemeState.darkTheme();
      try {
        _saveOptionValue(1);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    } else if (event is LightTheme) {
      print('inside LightTheme body');

      GlobalUtils.theme = 'light';
      yield ChangeThemeState.lightTheme();
      try {
        _saveOptionValue(0);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    } else if (event is DefaultTheme) {
      print('inside DefaultTheme body');

      GlobalUtils.theme = 'default';
      yield ChangeThemeState.defaultTheme();
      try {
        _saveOptionValue(2);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    } else {
      GlobalUtils.theme = 'default';
      yield ChangeThemeState.defaultTheme();
    }
  }

  Future<Null> _saveOptionValue(int optionValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('theme_option', optionValue);
    print('Saving option value as $optionValue successfully');
  }

  Future<int> getOption() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int option = preferences.get('theme_option') ?? 0;
    return option;
  }
}

final ChangeThemeBloc changeThemeBloc = ChangeThemeBloc()
  ..onDecideThemeChange();
