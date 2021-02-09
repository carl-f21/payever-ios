import 'package:equatable/equatable.dart';

abstract class TransactionDetailScreenEvent extends Equatable {
  TransactionDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class TransactionDetailScreenInitEvent extends TransactionDetailScreenEvent {
  final String businessId;
  final String transactionId;

  TransactionDetailScreenInitEvent({
    this.businessId,
    this.transactionId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.transactionId,
  ];
}

