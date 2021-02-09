import 'package:equatable/equatable.dart';

abstract class BusinessEvent extends Equatable {
  BusinessEvent();

  @override
  List<Object> get props => [];
}

class CreateBusiness extends BusinessEvent {
  final String email;
  final String password;

  CreateBusiness({this.email, this.password,});

  @override
  List<Object> get props => [
    this.email,
    this.password,
  ];

}

class BusinessFormEvent extends BusinessEvent{
  final bool isRegister;

  BusinessFormEvent({this.isRegister = false,});

  @override
  List<Object> get props => [
    this.isRegister,
  ];
}

class ClearSuggestionEvent extends BusinessEvent{}

class GetIndustrySuggestionEvent extends BusinessEvent{
  final String search;
  GetIndustrySuggestionEvent({this.search});
}

class RegisterBusinessEvent extends BusinessEvent {
  final Map<String, dynamic> body;
  RegisterBusinessEvent({this.body});
}