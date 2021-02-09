
import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/contacts/models/model.dart';

class ContactScreenState {
  final bool isLoading;
  final String business;
  final Contacts contacts;
  final List<Contact> contactNodes;
  final List<ContactModel> contactLists;
  ContactScreenState({
    this.isLoading = false,
    this.business,
    this.contacts,
    this.contactNodes = const [],
    this.contactLists = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
    this.contacts,
    this.contactNodes,
    this.contactLists,
  ];

  ContactScreenState copyWith({
    bool isLoading,
    String business,
    Contacts contacts,
    List<Contact> contactNodes,
    List<ContactModel> contactLists,
  }) {
    return ContactScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
      contacts: contacts ?? this.contacts,
      contactNodes: contactNodes ?? this.contactNodes,
      contactLists: contactLists ?? this.contactLists,
    );
  }
}

class ContactScreenStateSuccess extends ContactScreenState {}

class ContactScreenStateFailure extends ContactScreenState {
  final String error;

  ContactScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ContactScreenStateFailure { error $error }';
  }
}
