
import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/contacts/models/model.dart';

abstract class ContactScreenEvent extends Equatable {
  ContactScreenEvent();

  @override
  List<Object> get props => [];
}

class ContactScreenInitEvent extends ContactScreenEvent {
  final String business;

  ContactScreenInitEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];
}

class SelectContactEvent extends ContactScreenEvent {
  final ContactModel contact;
  SelectContactEvent({this.contact});
}

class SelectAllContactsEvent extends ContactScreenEvent {}

class DeselectAllContactsEvent extends ContactScreenEvent {}

class DeleteContactEvent extends ContactScreenEvent {
  final ContactModel contact;
  DeleteContactEvent({this.contact});
}

class DeleteSelectedContactsEvent extends ContactScreenEvent {}

class ContactsRefreshEvent extends ContactScreenEvent{}