
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

class WelcomeScreenState {
  final bool isLoading;
  final Map<String, List<NotificationModel>> notifications;

  WelcomeScreenState({
    this.isLoading = false,
    this.notifications = const {},
  });

  List<Object> get props => [
    this.isLoading,
    this.notifications,
  ];

  WelcomeScreenState copyWith({
    bool isLoading,
    Map<String, List<NotificationModel>> notifications,
  }){
    return WelcomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
    );
  }
}

class WelcomeScreenStateSuccess extends WelcomeScreenState {}
class WelcomeScreenStateFailure extends WelcomeScreenState {
  final String error;

  WelcomeScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'WelcomeScreenStateFailure { error $error }';
  }
}
