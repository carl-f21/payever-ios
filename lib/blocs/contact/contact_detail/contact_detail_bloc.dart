
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/contacts/models/model.dart';
import 'package:uuid/uuid.dart';

import 'contact_detail.dart';

class ContactDetailScreenBloc extends Bloc<ContactDetailScreenEvent, ContactDetailScreenState> {
  final ContactScreenBloc contactScreenBloc;
  ContactDetailScreenBloc({this.contactScreenBloc});
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ContactDetailScreenState get initialState => ContactDetailScreenState();

  @override
  Stream<ContactDetailScreenState> mapEventToState(ContactDetailScreenEvent event) async* {
    if (event is ContactDetailScreenInitEvent) {
      yield state.copyWith(business: event.business, contact: new Contact(), contactUserModel: ContactUserModel());
      yield* getField(event.business);
    } else if (event is GetContactDetail) {
      yield state.copyWith(contact: event.contact, business: event.business);
      yield* getField(event.business);
    } else if (event is AddContactPhotoEvent) {
      yield* uploadContactPhoto(event.file, state.business);
    } else if (event is CreateNewFieldEvent) {
      yield* createNewField(event.field);
    } else if (event is GetCustomField) {
      yield* getCustomField(event.business);
    } else if (event is LoadTemplateEvent) {
      yield* createNewContactField(event.field);
    } else if (event is UpdateContactUserModel) {
      yield* updateContactDetail(event.userModel);
    } else if (event is CreateNewContact) {
      yield* createContact(state.contactUserModel.type);
    } else if (event is CreateNewContactField) {
      yield* createContactField(event.contactId, event.fieldId, event.value);
    } else if (event is RemoveAdditionalField) {
      yield* removeAdditionalField(event.field);
    }
  }

  Stream<ContactDetailScreenState> getField(String businessId) async* {
    yield state.copyWith(isLoading: true);
    Contact contact = state.contact;
    ContactUserModel contactUserModel = new ContactUserModel();

      contactUserModel.type = state.contact.type;
      if (state.blobName != '') {
        contactUserModel.imageUrl = state.blobName;
      } else {
        List<ContactField> imageFields = state.contact.contactFields.nodes.where((element) {
          return element.field.name == 'imageUrl';
        }).toList();
        if (imageFields.length > 0) {
          contactUserModel.imageUrl = imageFields.first.value;
        }
      }
      List<ContactField> emailFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'email';
      }).toList();
      if (emailFields.length > 0) {
        contactUserModel.email = emailFields.first.value;
      }

      List<ContactField> firstNameFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'firstName';
      }).toList();
      if (firstNameFields.length > 0) {
        contactUserModel.firstName = firstNameFields.first.value;
      }

      List<ContactField> lastNameFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'lastName';
      }).toList();
      if (lastNameFields.length > 0) {
        contactUserModel.lastName = lastNameFields.first.value;
      }

      List<ContactField> phoneFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'mobilePhone';
      }).toList();
      if (phoneFields.length > 0) {
        contactUserModel.mobilePhone = phoneFields.first.value;
      }

      List<ContactField> homePageFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'homepage';
      }).toList();
      if (homePageFields.length > 0) {
        contactUserModel.homePage = homePageFields.first.value;
      }

      List<ContactField> streetFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'street';
      }).toList();
      if (streetFields.length > 0) {
        contactUserModel.street = streetFields.first.value;
      }

      List<ContactField> cityFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'city';
      }).toList();
      if (cityFields.length > 0) {
        contactUserModel.city = cityFields.first.value;
      }

      List<ContactField> stateFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'state';
      }).toList();
      if (stateFields.length > 0) {
        contactUserModel.states = stateFields.first.value;
      }

      List<ContactField> zipFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'zip';
      }).toList();
      if (zipFields.length > 0) {
        contactUserModel.zip = zipFields.first.value;
      }

      List<ContactField> coungryFields = state.contact.contactFields.nodes.where((element) {
        return element.field.name == 'country';
      }).toList();
      if (coungryFields.length > 0) {
        contactUserModel.country = coungryFields.first.value;
      }

    List<Field> fields = [];
    Map<String, dynamic> body = {
      'operationName': null,
      'query': '{\n  fields(filter: {or: [{businessId: {isNull: true}}]}) {\n    nodes {\n      id\n      businessId\n      name\n      type\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': businessId
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic field = data['fields'];
        if (field is Map) {
          dynamic nodes = field['nodes'];
          if (nodes is List) {
            nodes.forEach((element) {
              fields.add(Field.fromMap(element));
            });
          }
        }
      }
    }

    yield state.copyWith(isLoading: false, formFields: fields, contactUserModel: contactUserModel);
    add(GetCustomField(business: businessId));
  }

  Stream<ContactDetailScreenState> getCustomField(String businessId) async* {
    yield state.copyWith(isLoading: true);
    Map<String, dynamic> body = {
      'operationName': null,
      'query': 'query (\$businessId: UUID!) {\n  fields(filter: {or: [{businessId: {equalTo: \$businessId}}]}) {\n    nodes {\n      id\n      businessId\n      name\n      type\n      defaultValues\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': businessId
      },
    };
    List<Field> fieldDatas = [];
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic fields = data['fields'];
        if (fields is Map) {
          dynamic nodes = fields['nodes'];
          if (nodes is List) {
            nodes.forEach((element) {
              fieldDatas.add(Field.fromMap(element));
            });
          }
        }
      }
    }
    yield state.copyWith(isLoading: false, customFields: fieldDatas);
  }

  Stream<ContactDetailScreenState> uploadContactPhoto(File file, String businessId) async* {
    yield state.copyWith(uploadPhoto: true, blobName: '');
    dynamic response = await api.postImageToBusiness(file, businessId, token);
    String blob = '';
    if (response != null) {
      blob = response['blobName'];
    }
    ContactUserModel contactUserModel = state.contactUserModel;
    contactUserModel.imageUrl = '${Env.storage}/images/$blob';
    yield state.copyWith(uploadPhoto: false, blobName: '${Env.storage}/images/$blob', contactUserModel: contactUserModel);
  }

  Stream<ContactDetailScreenState> updateContactDetail(ContactUserModel contactUserModel) async* {
    yield state.copyWith(contactUserModel: contactUserModel);
  }


  Stream<ContactDetailScreenState> getContact(String id) async* {
    Contact contact;
    Map<String, dynamic> body = {
      'operationName': 'contact',
      'query': 'query contact(\$id: UUID!) {\n  contact(id: \$id) {\n    id\n    businessId\n    type\n    contactFields {\n      nodes {\n        id\n        value\n        fieldId\n        field {\n          id\n          name\n          defaultValues\n          type\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'id': id
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic contactData = data['contact'];
        if (contactData is Map) {
          contact = Contact.fromMap(contactData);
        }
      }
    }
    yield state.copyWith(isLoading: false, contact: contact);
  }

  Stream<ContactDetailScreenState> createContact(String type) async* {
    yield state.copyWith(isLoading: true,);
    Contact contact;
    String id = Uuid().v4();
    Map<String, dynamic> body = {
      'operationName': null,
      'query': 'mutation (\$id: UUID!, \$businessId: UUID!, \$type: String!) {\n  createContact(input: {contact: {id: \$id, businessId: \$businessId, type: \$type}}) {\n    contact {\n      id\n      businessId\n      type\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': state.business,
        'id': id,
        'type': type,
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic contactData = data['createContact'];
        if (contactData is Map) {
          contact = Contact.fromMap(contactData['contact']);
        }
      }
    }
    ContactUserModel contactUserModel = state.contactUserModel;
    if (contactUserModel.imageUrl != null && contactUserModel.imageUrl != '') {
      List<Field> imageFields = state.formFields.where((element) {
        return element.name == 'imageUrl';
      }).toList();
      if (imageFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': imageFields.first.id,
            'id': uuid,
            'value': contactUserModel.imageUrl,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    } else if (state.blobName != '') {
      List<Field> imageFields = state.formFields.where((element) {
        return element.name == 'imageUrl';
      }).toList();
      if (imageFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': imageFields.first.id,
            'id': uuid,
            'value': state.blobName,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.firstName != null) {
      List<Field> firstNameFields = state.formFields.where((element) {
        return element.name == 'firstName';
      }).toList();
      if (firstNameFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': firstNameFields.first.id,
            'id': uuid,
            'value': contactUserModel.firstName,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.lastName != null) {
      List<Field> lastNameFields = state.formFields.where((element) {
        return element.name == 'lastName';
      }).toList();
      if (lastNameFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': lastNameFields.first.id,
            'id': uuid,
            'value': contactUserModel.lastName,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.mobilePhone != null) {
      List<Field> phoneFields = state.formFields.where((element) {
        return element.name == 'mobilePhone';
      }).toList();
      if (phoneFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': phoneFields.first.id,
            'id': uuid,
            'value': contactUserModel.mobilePhone,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.email != null) {
      List<Field> emailFields = state.formFields.where((element) {
        return element.name == 'email';
      }).toList();
      if (emailFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': emailFields.first.id,
            'id': uuid,
            'value': contactUserModel.email,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.homePage != null) {
      List<Field> homepageFields = state.formFields.where((element) {
        return element.name == 'homepage';
      }).toList();
      if (homepageFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': homepageFields.first.id,
            'id': uuid,
            'value': contactUserModel.homePage,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.street != null) {
      List<Field> streetFields = state.formFields.where((element) {
        return element.name == 'street';
      }).toList();
      if (streetFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': streetFields.first.id,
            'id': uuid,
            'value': contactUserModel.street,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.city != null) {
      List<Field> cityFields = state.formFields.where((element) {
        return element.name == 'city';
      }).toList();
      if (cityFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': cityFields.first.id,
            'id': uuid,
            'value': contactUserModel.city,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.states != null) {
      List<Field> stateFields = state.formFields.where((element) {
        return element.name == 'state';
      }).toList();
      if (stateFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': stateFields.first.id,
            'id': uuid,
            'value': contactUserModel.states,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.zip != null) {
      List<Field> zipFields = state.formFields.where((element) {
        return element.name == 'zip';
      }).toList();
      if (zipFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': zipFields.first.id,
            'id': uuid,
            'value': contactUserModel.zip,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    if (contactUserModel.country != null) {
      List<Field> countryFields = state.formFields.where((element) {
        return element.name == 'country';
      }).toList();
      if (countryFields.length > 0) {
        String uuid = Uuid().v4();
        Map<String, dynamic> body = {
          'operationName': 'createContactField',
          'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
          'variables': {
            'businessId': state.business,
            'contactId': contact.id,
            'fieldId': countryFields.first.id,
            'id': uuid,
            'value': contactUserModel.country,
          },
        };
        dynamic response = await api.getGraphql(token, body);
      }
    }
    yield state.copyWith(isLoading: false);
    yield ContactDetailScreenStateSuccess();
  }

  Stream<ContactDetailScreenState> createContactField(String contactId, String fieldId, String value) async* {
    ContactField contactField;
    String id = Uuid().v4();
    Map<String, dynamic> body = {
      'operationName': 'createContactField',
      'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': state.business,
        'contactId': contactId,
        'fieldId': fieldId,
        'id': id,
        'value': value,
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic createContactField = data['createContactField'];
        if (createContactField is Map) {
          contactField = ContactField.fromMap(createContactField['contactField']);
        }
      }
    }
    yield state.copyWith(isLoading: false);
  }

  Stream<ContactDetailScreenState> createNewField(Field field) async* {
    String id = Uuid().v4();
    Map<String, dynamic> body = {
      'operationName': 'createField',
      'query': 'mutation createField(\$id: UUID!, \$businessId: UUID!, \$name: String!, \$type: String!, \$defaultValues: JSON) {\n  createField(input: {field: {id: \$id, defaultValues: \$defaultValues, businessId: \$businessId, name: \$name, type: \$type}}) {\n    field {\n      id\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': state.business,
        'defaultValues': null,
        'id': id,
        'name': field.name,
        'type': field.type,
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
      }
    }
    yield state.copyWith(isLoading: false);
  }

  Stream<ContactDetailScreenState> createNewContactField(Field field) async* {
    String id = Uuid().v4();
    Map<String, dynamic> body = {
      'operationName': 'createContactField',
      'query': 'mutation createContactField(\$id: UUID!, \$businessId: UUID!, \$contactId: UUID!, \$fieldId: UUID!, \$value: String!) {\n  createContactField(input: {contactField: {id: \$id, businessId: \$businessId, contactId: \$contactId, fieldId: \$fieldId, value: \$value}}) {\n    contactField {\n      id\n      value\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': state.business,
        'fieldId': field.id,
        'id': id,
        'value': '',
        'contactId': state.contact.id,
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
      }
    }
    List<Field> additional = [];
    additional.addAll(state.additionalFields);
    additional.add(field);
    yield state.copyWith(additionalFields: additional);
  }

  Stream<ContactDetailScreenState> addAdditionalField(Field field) async* {

  }

  Stream<ContactDetailScreenState> removeAdditionalField(Field field) async* {
    List<Field> additional = [];
    additional.addAll(state.additionalFields);
    List<Field> a = additional.where((element) {
      return element.id == field.id;
    }).toList();
    if (a.length > 0) {
      Field ad = a.first;
      additional.remove(ad);
    }
    yield state.copyWith(additionalFields: additional);
  }
}