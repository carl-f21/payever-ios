class Contact {
  Contact();
  String businessId = '';
  ContactFields contactFields = new ContactFields();
  String id = '';
  String type = '';
  String typename = '';

  Contact.fromMap(dynamic obj) {
    businessId = obj['businessId'];
    id = obj['id'];
    type = obj['type'];
    typename = obj['__typename'];
    if (obj['contactFields'] != null) {
      contactFields = ContactFields.fromMap(obj['contactFields']);
    }
  }

}

class ContactFields {
  ContactFields();
  List<ContactField> nodes = [];
  String typename = '';

  ContactFields.fromMap(dynamic obj) {
    typename = obj['__typename'];
    if (obj['nodes'] is List) {
      List list = obj['nodes'];
      list.forEach((element) {
        nodes.add(ContactField.fromMap(element));
      });
    }
  }
}

class ContactField {
  Field field = Field();
  String fieldId = '';
  String id = '';
  String value = '';
  String typename = '';

  ContactField.fromMap(dynamic obj) {
    fieldId = obj['fieldId'];
    id = obj['id'];
    value = obj['value'];
    typename = obj['__typename'];
    if (obj['field'] != null) {
      field = Field.fromMap(obj['field']);
    }
  }
}

class Field {
  Field();
  String id= '';
  String name = '';
  String typename = '';
  String businessId = '';
  String type = '';

  Field.fromMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
    typename = obj['__typename'];
    businessId = obj['businessId'];
    type = obj['type'];
  }
}

class Contacts {
  Contacts();
  List<Contact> nodes = [];
  ContactPageInfo pageInfo = ContactPageInfo();
  num totalCount = 0;
  String typename = '';

  Contacts.fromMap(dynamic obj) {
    typename = obj['__typename'];
    totalCount = obj['totalCount'];
    if (obj['nodes'] is List){
      List list = obj['nodes'];
      list.forEach((element) {
        nodes.add(Contact.fromMap(element));
      });
    }
    if (obj['pageInfo'] != null) {
      pageInfo = ContactPageInfo.fromMap(obj['pageInfo']);
    }
  }
}

class ContactPageInfo {
  ContactPageInfo();
  bool hasNextPage = false;
  String typename = '';

  ContactPageInfo.fromMap(dynamic obj) {
    typename = obj['__typename'];
    hasNextPage = obj['hasNextPage'];
  }
}

class ContactModel {
  bool isChecked = false;
  Contact contact = Contact();

  ContactModel({this.contact, this.isChecked});
}


class ContactFilterItem {
  String type;
  String condition;
  String value;
  String disPlayName;
  bool isOpened;

  ContactFilterItem({
    this.type = 'Text',
    this.condition,
    this.value = '',
    this.disPlayName = '',
    this.isOpened = false,
  });
}

class ContactUserModel {
  ContactUserModel();

  String type;
  String firstName;
  String lastName;
  String email;
  String mobilePhone;
  String street;
  String homePage;
  String city;
  String states;
  String country;
  String zip;
  String imageUrl = '';


}