
import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class ConnectDetailScreenState {
  final bool isLoading;
  final bool installing;
  final String business;
  final String selectedCategory;
  final List<ConnectModel> categoryConnects;
  final ConnectIntegration editConnect;
  final bool isReview;
  final bool installed;
  final String installingConnect;
  final String installedNewConnect;
  final String uninstalledNewConnect;

  ConnectDetailScreenState({
    this.isLoading = false,
    this.installing = false,
    this.business,
    this.categoryConnects = const [],
    this.selectedCategory,
    this.editConnect,
    this.isReview = false,
    this.installed = false,
    this.installingConnect,
    this.installedNewConnect,
    this.uninstalledNewConnect,
  });

  List<Object> get props => [
    this.isLoading,
    this.installing,
    this.business,
    this.categoryConnects,
    this.selectedCategory,
    this.editConnect,
    this.isReview,
    this.installed,
    this.installingConnect,
    this.installedNewConnect,
    this.uninstalledNewConnect,
  ];

  ConnectDetailScreenState copyWith({
    bool isLoading,
    bool installing,
    String business,
    List<ConnectModel> categoryConnects,
    String selectedCategory,
    ConnectIntegration editConnect,
    bool isReview,
    bool installed,
    String installingConnect,
    String installedNewConnect,
    String uninstalledNewConnect,
  }) {
    return ConnectDetailScreenState(
      isLoading: isLoading ?? this.isLoading,
      installing: installing ?? this.installing,
      business: business ?? this.business,
      categoryConnects: categoryConnects ?? this.categoryConnects,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      editConnect: editConnect ?? this.editConnect,
      isReview: isReview ?? this.isReview,
      installed: installed ?? this.installed,
      installingConnect: installingConnect ?? this.installingConnect,
      installedNewConnect: installedNewConnect ?? this.installedNewConnect,
      uninstalledNewConnect: uninstalledNewConnect ?? this.uninstalledNewConnect,
    );
  }
}

class ConnectDetailScreenStateSuccess extends ConnectDetailScreenState {}

class ConnectDetailScreenStateFailure extends ConnectDetailScreenState {
  final String error;

  ConnectDetailScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ConnectDetailScreenStateFailure { error $error }';
  }
}
