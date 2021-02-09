import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class SearchScreenEvent extends Equatable {
  SearchScreenEvent();

  @override
  List<Object> get props => [];
}

class SearchEvent extends SearchScreenEvent {
  final String key;
  final String businessId;

  SearchEvent({this.key, this.businessId,});

  @override
  List<Object> get props => [
    this.key,
    this.businessId,
  ];
}

class SetBusinessEvent extends SearchScreenEvent {
  final Business business;

  SetBusinessEvent({this.business,});

  @override
  List<Object> get props => [
    this.business,
  ];
}