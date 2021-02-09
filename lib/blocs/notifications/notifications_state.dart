
import 'package:flutter/material.dart';

class NotificationsScreenState {
  final bool isLoading;

  NotificationsScreenState({
    this.isLoading = false,
  });

  List<Object> get props => [
    this.isLoading,
  ];

  NotificationsScreenState copyWith({
    bool isLoading,
  }){
    return NotificationsScreenState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class NotificationsScreenStateSuccess extends NotificationsScreenState {}
class NotificationsScreenStateFailure extends NotificationsScreenState {
  final String error;

  NotificationsScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'NotificationsScreenStateFailure { error $error }';
  }
}
