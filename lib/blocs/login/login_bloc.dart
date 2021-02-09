import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/login/login.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc();
  ApiService api = ApiService();
  SharedPreferences preferences;

  @override
  LoginScreenState get initialState => LoginScreenState();

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event) async* {
    preferences = await SharedPreferences.getInstance();
    if (event is FetchEnvEvent) {
      yield* getEnv();
    } else if (event is LoginEvent) {
      yield* login(event.email, event.password);
    } else if (event is FetchLoginCredentialsEvent) {
      String email = preferences.getString(GlobalUtils.EMAIL) ?? '';
      String password = preferences.getString(GlobalUtils.PASSWORD) ?? '';
      yield state.copyWith(email: email, password: password);
      yield LoadedCredentialsState(username: email, password: password);
    }
  }

  Stream<LoginScreenState> getEnv() async* {
    if (Env.cdnIcon == null || Env.cdnIcon.isEmpty) {
      yield state.copyWith(isLoading: true);
      try {
        var obj = await api.getEnv();
        Env.map(obj);
        yield state.copyWith(isLoading: false,);
      } catch (error){
        print(onError.toString());
        yield state.copyWith(isLoading: false,);
        yield LoginScreenFailure(error: error.toString());
      }
    }
  }

  Stream<LoginScreenState> login(String email, String password) async* {
    yield state.copyWith(isLogIn: true);
    try {
      var obj = await api.getEnv();
      Env.map(obj);

      print('email => $email');
      print('password => $password');
      dynamic loginObj = await api.login(email, password);
      Token tokenData = Token.map(loginObj);
      preferences.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
      GlobalUtils.setCredentials(email: email, password: password, tokenData: tokenData);
      yield state.copyWith(isLogIn: false);
      yield LoginScreenSuccess();
    } catch (error){
      print(onError.toString());
      yield state.copyWith(isLogIn: false,);
      yield LoginScreenFailure(error: error.toString());
    }
  }

}