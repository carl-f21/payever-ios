import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/contacts/models/model.dart';

import 'contact.dart';

class ContactScreenBloc extends Bloc<ContactScreenEvent, ContactScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;

  ContactScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ContactScreenState get initialState => ContactScreenState();

  @override
  Stream<ContactScreenState> mapEventToState(ContactScreenEvent event) async* {
    if (event is ContactScreenInitEvent) {
      yield state.copyWith(business: event.business);
      yield* getContacts(event.business);
    } else if (event is SelectContactEvent) {
      yield* selectContact(event.contact);
    } else if (event is SelectAllContactsEvent) {
      yield* selectAllContacts();
    } else if (event is DeselectAllContactsEvent) {
      yield* deSelectAllContacts();
    } else if (event is DeleteContactEvent) {
      yield* deleteContact(event.contact);
    } else if (event is DeleteSelectedContactsEvent) {
      yield* deleteSelectedContacts();
    } else if (event is ContactsRefreshEvent) {
      yield* reloadContacts(state.business);
    }
  }

  Stream<ContactScreenState> fetchContactInstallations(String business) async* {
    dynamic response = await api.getProductsPopularMonthRandom(business, token);
  }

  Stream<ContactScreenState> getField(String businessId) async* {
    yield state.copyWith(isLoading: true);
    Map<String, dynamic> body = {
      'operationName': null,
      'query': '{\n  fields(filter: {or: [{businessId: {isNull: true}}]}) {\n    nodes {\n      id\n      businessId\n      name\n      type\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': businessId
      },
    };
    dynamic response = await api.getGraphql(token, body);
  }

  Stream<ContactScreenState> getFieldData(String businessId) async* {
    yield state.copyWith(isLoading: true);
    Map<String, dynamic> body = {
      'operationName': null,
      'query': 'query (\$businessId: UUID!) {\n  fields(filter: {or: [{businessId: {equalTo: \$businessId}}]}) {\n    nodes {\n      id\n      businessId\n      name\n      type\n      defaultValues\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': businessId
      },
    };
    dynamic response = await api.getGraphql(token, body);
  }

  Stream<ContactScreenState> getContacts(String businessId) async* {
    yield state.copyWith(isLoading: true);
    Contacts contacts;
    Map<String, dynamic> body = {
      'operationName': null,
      'query': 'query (\$businessId: UUID!, \$offset: Int!, \$itemCount: Int!) {\n  contacts(orderBy: CREATED_AT_DESC, first: \$itemCount, offset: \$offset, condition: {businessId: \$businessId}) {\n    nodes {\n      id\n      businessId\n      type\n      contactFields {\n        nodes {\n          id\n          value\n          fieldId\n          field {\n            id\n            name\n            __typename\n          }\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    totalCount\n    pageInfo {\n      hasNextPage\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': businessId,
        'itemCount': 20,
        'offset': 0
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic contactsObj = data['contacts'];
        if (contactsObj != null) {
          contacts = Contacts.fromMap(contactsObj);
        }
      }
    }
    List<Contact> contactList = [];
    List<ContactModel> contactModels = [];
    contacts.nodes.forEach((element) {
      contactList.add(element);
      contactModels.add(ContactModel(contact: element, isChecked: false));
    });

    yield state.copyWith(isLoading: false, contacts: contacts, contactNodes: contactList, contactLists: contactModels);
  }

  Stream<ContactScreenState> reloadContacts(String businessId) async* {
    Contacts contacts;
    Map<String, dynamic> body = {
      'operationName': null,
      'query': 'query (\$businessId: UUID!, \$offset: Int!, \$itemCount: Int!) {\n  contacts(orderBy: CREATED_AT_DESC, first: \$itemCount, offset: \$offset, condition: {businessId: \$businessId}) {\n    nodes {\n      id\n      businessId\n      type\n      contactFields {\n        nodes {\n          id\n          value\n          fieldId\n          field {\n            id\n            name\n            __typename\n          }\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    totalCount\n    pageInfo {\n      hasNextPage\n      __typename\n    }\n    __typename\n  }\n}\n',
      'variables': {
        'businessId': businessId,
        'itemCount': 20,
        'offset': 0
      },
    };
    dynamic response = await api.getGraphql(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data is Map) {
        dynamic contactsObj = data['contacts'];
        if (contactsObj != null) {
          contacts = Contacts.fromMap(contactsObj);
        }
      }
    }
    List<Contact> contactList = [];
    List<ContactModel> contactModels = [];
    contacts.nodes.forEach((element) {
      contactList.add(element);
      contactModels.add(ContactModel(contact: element, isChecked: false));
    });

    yield state.copyWith(isLoading: false, contacts: contacts, contactNodes: contactList, contactLists: contactModels);
  }

  Stream<ContactScreenState> selectContact(ContactModel contact) async* {
    List<ContactModel> contacts = [];
    contacts.addAll(state.contactLists);

    int index = contacts.indexOf(contact);
    ContactModel contactModel = contact;
    contactModel.isChecked = !contact.isChecked;
    contacts[index] = contactModel;

    yield state.copyWith(contactLists: contacts);
  }

  Stream<ContactScreenState> selectAllContacts() async* {
    List<ContactModel> contacts = [];
    state.contactLists.forEach((element) {
      element.isChecked = true;
      contacts.add(element);
    });

    yield state.copyWith(contactLists: contacts);
  }

  Stream<ContactScreenState> deSelectAllContacts() async* {
    List<ContactModel> contacts = [];
    state.contactLists.forEach((element) {
      element.isChecked = false;
      contacts.add(element);
    });

    yield state.copyWith(contactLists: contacts);
  }

  Stream<ContactScreenState> deleteContact(ContactModel contact) async* {
  }

  Stream<ContactScreenState> deleteSelectedContacts() async* {

  }

}