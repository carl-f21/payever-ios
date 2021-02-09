
import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class ConnectScreenEvent extends Equatable {
  ConnectScreenEvent();

  @override
  List<Object> get props => [];
}

class ConnectScreenInitEvent extends ConnectScreenEvent {
  final String business;

  ConnectScreenInitEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];
}

class ConnectCategorySelected extends ConnectScreenEvent {
  final String category;

  ConnectCategorySelected({
    this.category,
  });

  @override
  List<Object> get props => [
    this.category,
  ];
}

class InstallConnectAppEvent extends ConnectScreenEvent {
  final ConnectModel model;

  InstallConnectAppEvent({
    this.model,
  });

  @override
  List<Object> get props => [
    this.model,
  ];
}

class UninstallConnectAppEvent extends ConnectScreenEvent {
  final ConnectModel model;

  UninstallConnectAppEvent({
    this.model,
  });

  @override
  List<Object> get props => [
    this.model,
  ];
}

class ClearInstallEvent extends ConnectScreenEvent {}