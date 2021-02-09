import 'package:flutter/cupertino.dart';
import 'package:payever/commons/models/version.dart';

class LoginScreenState {
  final bool isLoading;
  final bool isLogIn;
  final String email;
  final String password;

  LoginScreenState({
    this.isLoading = false,
    this.isLogIn = false,
    this.email,
    this.password,
  });

  List<Object> get props => [
    this.isLoading,
    this.isLogIn,
    this.email,
    this.password,
  ];

  LoginScreenState copyWith({
    bool isLoading,
    bool isLogIn,
    String email,
    String password,
  }) {
    return LoginScreenState(
      isLoading: isLoading ?? this.isLoading,
      isLogIn: isLogIn ?? this.isLogIn,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class LoadedCredentialsState extends LoginScreenState {
  final String username;
  final String password;
  LoadedCredentialsState({
    this.username,
    this.password,
  });
}

class LoginScreenSuccess extends LoginScreenState {}

class LoginScreenFailure extends LoginScreenState {
  final String error;

  LoginScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'LoginScreenFailure { error $error }';
  }
}

class LoginScreenVersionFailed extends LoginScreenState {
  final Version version;
  LoginScreenVersionFailed({this.version});
}
