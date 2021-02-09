import 'package:equatable/equatable.dart';

abstract class RegisterScreenEvent extends Equatable {
  RegisterScreenEvent();

  @override
  List<Object> get props => [];
}

class RegisterEvent extends RegisterScreenEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  RegisterEvent({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  });

  @override
  List<Object> get props => [
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  ];

}

// class FetchEnvEvent extends RegisterScreenEvent {}
//
// class FetchLoginCredentialsEvent extends RegisterScreenEvent {}