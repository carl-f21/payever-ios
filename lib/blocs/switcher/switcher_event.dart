import 'package:equatable/equatable.dart';
import 'package:payever/commons/models/business.dart';

abstract class SwitcherScreenEvent extends Equatable {
  SwitcherScreenEvent();

  @override
  List<Object> get props => [];
}

class SwitcherScreenInitialEvent extends SwitcherScreenEvent {

  SwitcherScreenInitialEvent();

  @override
  List<Object> get props => [
  ];
}

class SwitcherSetBusinessEvent extends SwitcherScreenEvent {
  final Business business;

  SwitcherSetBusinessEvent({this.business,});

  @override
  List<Object> get props => [
    this.business,
  ];
}