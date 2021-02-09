
import 'package:flutter/material.dart';
import 'package:payever/contacts/models/model.dart';

class ContactDetailScreenState {
  final bool isLoading;
  final bool uploadPhoto;
  final String business;
  final String blobName;
  final List<Field> formFields;
  final List<Field> customFields;
  final List<Field> additionalFields;
  final Contact contact;
  final ContactUserModel contactUserModel;

  ContactDetailScreenState({
    this.isLoading = false,
    this.uploadPhoto = false,
    this.business,
    this.blobName = '',
    this.formFields = const [],
    this.customFields = const [],
    this.additionalFields = const [],
    this.contact,
    this.contactUserModel,
  });

  List<Object> get props => [
    this.isLoading,
    this.uploadPhoto,
    this.business,
    this.blobName,
    this.formFields,
    this.customFields,
    this.additionalFields,
    this.contact,
    this.contactUserModel,
  ];

  ContactDetailScreenState copyWith({
    bool isLoading,
    bool uploadPhoto,
    String business,
    String blobName,
    List<Field> formFields,
    List<Field> customFields,
    List<Field> additionalFields,
    Contact contact,
    ContactUserModel contactUserModel,
  }) {
    return ContactDetailScreenState(
      isLoading: isLoading ?? this.isLoading,
      uploadPhoto: uploadPhoto ?? this.uploadPhoto,
      business: business ?? this.business,
      blobName: blobName ?? this.blobName,
      formFields: formFields ?? this.formFields,
      customFields: customFields ?? this.customFields,
      additionalFields: additionalFields ?? this.additionalFields,
      contact: contact ?? this.contact,
      contactUserModel: contactUserModel ?? this.contactUserModel,
    );
  }
}

class ContactDetailScreenStateSuccess extends ContactDetailScreenState {}

class ContactDetailScreenStateFailure extends ContactDetailScreenState {
  final String error;

  ContactDetailScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ContactDetailScreenStateFailure { error $error }';
  }
}
