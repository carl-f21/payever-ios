import 'package:flutter/cupertino.dart';
import 'package:payever/commons/models/user.dart';
import 'package:payever/commons/models/version.dart';

class RegisterScreenState {
  final bool isLoading;
  final bool isRegister;
  final bool isRegistered;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final User user;

  RegisterScreenState({
    this.isLoading = false,
    this.isRegister = false,
    this.isRegistered = false,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.user,
  });

  List<Object> get props => [
    this.isLoading,
    this.isRegister,
    this.isRegistered,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.user,
  ];

  RegisterScreenState copyWith({
    bool isLoading,
    bool isRegister,
    bool isRegistered,
    String firstName,
    String lastName,
    String email,
    String password,
    User user,
  }) {
    return RegisterScreenState(
      isLoading: isLoading ?? this.isLoading,
      isRegister: isRegister ?? this.isRegister,
      isRegistered: isRegistered ?? this.isRegistered,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      user: user ?? this.user,
    );
  }
}

class LoadedRegisterCredentialsState extends RegisterScreenState {
  final String username;
  final String password;
  LoadedRegisterCredentialsState({
    this.username,
    this.password,
  });
}

class RegisterScreenSuccess extends RegisterScreenState {}

class RegisterScreenFailure extends RegisterScreenState {
  final String error;

  RegisterScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'LoginScreenFailure { error $error }';
  }
}

class RegisterScreenVersionFailed extends RegisterScreenState {
  final Version version;
  RegisterScreenVersionFailed({this.version});
}
