import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';

class TransactionDetailScreenState {
  final bool isLoading;
  final TransactionDetails data;

  TransactionDetailScreenState({
    this.isLoading = true,
    this.data,
  });

  List<Object> get props => [
    this.isLoading,
    this.data,
  ];

  TransactionDetailScreenState copyWith({
    bool isLoading,
    TransactionDetails data,
  }) {
    return TransactionDetailScreenState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}

class TransactionDetailScreenSuccess extends TransactionDetailScreenState {}

class TransactionDetailScreenFailure extends TransactionDetailScreenState {
  final String error;

  TransactionDetailScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'Transactions Screen Failure { error $error }';
  }
}