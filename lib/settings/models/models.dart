import 'package:flutter/material.dart';
import 'package:iso_countries/country.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/libraries/flutter_tagging.dart';

class SettingItem {
  final String name;
  final String image;

  const SettingItem({@required this.name, @required this.image});
}

List<String> detailTitles = [
  'Currency',
  'Company',
  'Contact',
  'Address',
  'Bank',
  'Taxes'
];

class WallpaperCategory {
  String code;
  List<WallpaperIndustry> industries = [];

  WallpaperCategory.fromMap(dynamic obj) {
    code = obj['code'];
    dynamic industriesObj = obj['industries'];
    if (industriesObj is List) {
      industriesObj.forEach((element) {
        industries.add(WallpaperIndustry.fromMap(element));
      });
    }
  }
}

class WallpaperIndustry {
  String code;
  List<Wallpaper> wallpapers = [];

  WallpaperIndustry.fromMap(dynamic obj) {
    code = obj['code'];
    dynamic wallPapersObj = obj['wallpapers'];
    wallPapersObj.forEach((wallpaper) {
      wallpapers.add(Wallpaper.fromMap(wallpaper, code));
    });
  }
}

class Wallpaper {
  Wallpaper();

  String theme;
  String wallpaper;
  String industry;

  Wallpaper.fromMap(dynamic obj, String _industry) {
    theme = obj['theme'];
    wallpaper = obj['wallpaper'];
    industry = _industry;
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    if (theme != null)        map['theme'] = theme;
    if (wallpaper != null)    map['wallpaper'] = wallpaper;
    if (industry != null)     map['industry'] = industry;
    return map;
  }
}

class MyWallpaper {
  String business;
  String user;
  String createdAt;
  Wallpaper currentWallpaper;
  String industry;
  List<Wallpaper> myWallpapers = [];
  String product;
  String type;
  String updatedAt;
  String id;

  MyWallpaper.fromMap(dynamic obj) {
    business = obj['business'];
    user = obj['user'];
    createdAt = obj['createdAt'];
    industry = obj['industry'];
    product = obj['product'];
    type = obj['type'];
    updatedAt = obj['updatedAt'];
    id = obj['_id'];

    dynamic wallpaperObj = obj['currentWallpaper'];
    if (wallpaperObj is Map) {
      currentWallpaper = Wallpaper.fromMap(wallpaperObj, industry);
    }

    dynamic myWallpapersObj = obj['myWallpapers'];
    if (myWallpapersObj is List) {
      myWallpapersObj.forEach((element) {
        myWallpapers.add(Wallpaper.fromMap(element, 'Own'));
      });
    }

  }
}

class IndustryModel {
  String code;
  String industry;
  String logo;
  String slug;
  String wallpaper;
  String id;

  IndustryModel.fromMap(dynamic obj) {
    code = obj['code'];
    industry = obj['industry'];
    logo = obj['logo'];
    slug = obj['slug'];
    wallpaper = obj['wallpaper'];
    id = obj['_id'];
  }
}

class BusinessProduct {
  String code;
  List<IndustryModel> industries = [];
  num order;
  String id;

  BusinessProduct.fromMap(dynamic obj) {
    code = obj['code'];
    order = obj['order'];
    id = obj['_id'];
    dynamic industryObj = obj['industries'];
    if (industryObj is List) {
      industryObj.forEach((element) {
        industries.add(IndustryModel.fromMap(element));
      });
    }
  }

}


List<String> legalForms = [
  'LEGAL_FORM_AG',
  'LEGAL_FORM_EG',
  'LEGAL_FORM_EINZELUNTERN',
//  "assets.legal_form.LEGAL_FORM_EINZELUNTERNAHMER",
  'LEGAL_FORM_EK',
  'LEGAL_FORM_EV',
  'LEGAL_FORM_GBR',
  'LEGAL_FORM_GMBH',
  'LEGAL_FORM_KG',
  'LEGAL_FORM_OHG',
  'LEGAL_FORM_SONSTIGES',
  'LEGAL_FORM_UG'
];

List<String> employeeRange = [
  'RANGE_1',
  'RANGE_2',
  'RANGE_3',
  'RANGE_4',
  'RANGE_5',
  'RANGE_6'
];

List<String> salesRange = [
  'RANGE_1',
  'RANGE_2',
  'RANGE_3',
  'RANGE_4',
  'RANGE_5',
  'RANGE_6'
];

class Employee {
  String businessId;
  String email;
  String firstName;
  String lastName;
  String fullName;
  List<Group> groups = [];
  String positionType;
  List<Role> roles = [];
  int status;
  String id;
  Employee({this.id});

  Employee.fromMap(dynamic obj) {
    businessId = obj['businessId'];
    email = obj['email'];
    firstName = obj['first_name'];
    lastName = obj['last_name'];
    fullName = obj['fullName'];
    positionType = obj['positionType'];
    status = obj['status'];
    id = obj['_id'];

    dynamic groupsObj = obj['groups'];
    if (groupsObj is List) {
      groupsObj.forEach((element)=> groups.add(Group.fromMap(element)));
    }

    dynamic rolesObj = obj['roles'];
    if (rolesObj is List) {
      rolesObj.forEach((element)=> roles.add(Role.fromMap(element)));
    }
  }
}

class EmployeeListModel {
  bool isChecked;
  Employee employee;

  EmployeeListModel({this.employee, this.isChecked});
}

class GroupListModel {
  bool isChecked;
  Group group;

  GroupListModel({this.group, this.isChecked});
}

class Group {
  String id;
  String name;
  String businessId;
  List<Employee> employees = [];
  List<Acl> acls = [];

  Group.fromMap(dynamic obj) {
    name = obj['name'];
    id = obj['_id'];
    businessId = obj['businessId'];
    dynamic employeesObj = obj['employees'];
    if (employeesObj is List) {
      employeesObj.forEach((element) {
        if (element is String) {
          employees.add(Employee(id: element));
        } else if (element is Map){
          employees.add(Employee.fromMap(element));
        }
      });
    }
    dynamic aclsObj = obj['acls'];
    if (aclsObj is List) {
      aclsObj.forEach((element) {
        acls.add(Acl.fromMap(element));
      });
    }
  }
}

class Role {
  List<Permission> permissions = [];
  String name;
  String type;
  List<dynamic> tags = [];
  Role.fromMap(dynamic obj) {
    name = obj['name'];
    type = obj['type'];
    dynamic permissionsObj = obj['permissions'];
    if (permissionsObj is List) {
      permissionsObj.forEach((element)=> permissions.add(Permission.fromMap(element)));
    }
    dynamic tagsObj = obj['tags'];
    if (tagsObj is List) {
      tagsObj.forEach((element)=> tags.add(element));
    }
  }
}

class Permission {
  List<Acl> acls = [];
  String businessId;
  Permission.fromMap(dynamic obj) {
    businessId = obj['businessId'];
    dynamic aclsObj = obj['acls'];
    if (aclsObj is List) {
      aclsObj.forEach((element)=> acls.add(Acl.fromMap(element)));
    }
  }
}

class Acl {
  String microService;
  bool create;
  bool read;
  bool update;
  bool delete;

  Acl.fromMap(dynamic obj) {
    microService = obj['microservice'];
    create = obj['create'];
    read = obj['read'];
    update = obj['update'];
    delete = obj['delete'];
  }

  Map<String, bool> toMap() {
    Map<String, bool> map = {};
    if (create != null) {
      map['create'] = create;
    }
    if (read != null) {
      map['read'] = read;
    }
    if (update != null) {
      map['update'] = update;
    }
    if (delete != null) {
      map['delete'] = delete;
    }

    return map;
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    if (create != null) {
      map['create'] = create;
    }
    if (read != null) {
      map['read'] = read;
    }
    if (update != null) {
      map['update'] = update;
    }
    if (delete != null) {
      map['delete'] = delete;
    }
    if (microService != null) {
      map['microservice'] = microService;
    }

    return map;
  }

  updateDict(Map<String, bool> map) {
    if (map.containsKey('create')) {
      create = map['create'];
    }
    if (map.containsKey('read')) {
      read = map['read'];
    }
    if (map.containsKey('update')) {
      update = map['update'];
    }
    if (map.containsKey('delete')) {
      delete = map['delete'];
    }
  }

  setAll(bool b) {
    if (create != null) {
      create = b;
    }
    if (read != null) {
      read = b;
    }
    if (update != null) {
      update = b;
    }
    if (delete != null) {
      delete = b;
    }
  }

  int isFullAccess() {
    if ((create == null || create)
        && (read == null || read)
        && (update == null || update)
        && (delete == null || delete)) {
      return 2;
    } else if ((create == null || create)
        || (read == null || read)
        || (update == null || update)
        || (delete == null || delete)){
      return 1;
    } else {
      return 0;
    }
  }
}

class MyTheme {
  Brightness brightness;
  MaterialColor primarySwatch;

  MyTheme(
      {this.brightness,
        this.primarySwatch,
      });
}

class AppTheme {
  String name;
  MyTheme theme;
  AppTheme(this.name, this.theme);
}

List<AppTheme> myThemes = [
  AppTheme(
    'default',
    MyTheme(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
    ),
  ),
  AppTheme(
    'light',
    MyTheme(
      brightness: Brightness.light,
      primarySwatch: Colors.white,
    ),
  ),
  AppTheme(
    'dark',
    MyTheme(
      brightness: Brightness.dark,
      primarySwatch: Colors.black,
    ),
  ),
];

class GroupTag extends Taggable {
  final String name;

  final Group category;
  final int position;

  GroupTag({
    this.name,
    this.category,
    this.position,
  });

  @override
  List<Object> get props => [name];

  String toJson() => '''  {
    "name": $name,\n
    "position": $position\n
  }''';
}

Map<String, String> filterEmployeeLabels = {
  'name': 'Name',
  'position': 'Position',
  'email': 'E-mail',
  'status': 'Status',
};

Map<String, String> filterGroupLabels = {
  'name': 'Name',
};

Map<String, String> filterEmployeeConditions = {
  'is': 'Is',
  'isNot': 'Is not',
  'startsWith': 'Starts with',
  'endsWith': 'Ends with',
  'contains': 'Contains',
  'doesNotContain': 'Does not contain',
};

Map<String, String> getFilterWithLabel(String label) {
  switch (label){
    case 'name':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain',
      };
    case 'position':
      return {
        'is': 'Is',
        'isNot': 'Is not',
      };
    case 'email':
      return {
        'is': 'Is',
        'isNot': 'Is not',
        'startsWith': 'Starts with',
        'endsWith': 'Ends with',
        'contains': 'Contains',
        'doesNotContain': 'Does not contain',
      };
    case 'status':
      return {
        'is': 'Is',
        'isNot': 'Is not',
      };
  }
  return {};
}

Map<String, String> policiesScreenTitles = {
  'legal': 'Legal',
  'disclaimer': 'Disclaimer',
  'refund_policy': 'Refund policy',
  'shipping_policy': 'Shipping policy',
  'privacy': 'Privacy',
};

class LegalDocument {
  Business business;
  String content;
  String createdAt;
  String type;
  String updatedAt;
  num v;
  String id;

  LegalDocument.fromMap(dynamic obj) {
    if (obj['business'] is String) {
      business = Business(id: obj['business']);
    } else if (obj['business'] is Map) {
      business = Business.map(obj['business']);
    }
    content = obj['content'];
    createdAt = obj['createdAt'];
    type = obj['type'];
    updatedAt = obj['updatedAt'];
    v = obj['__v'];
    id = obj['_id'];
  }
}

Map<String, String> generalScreenTitles = {
  'language': 'Language',
  'color_and_style': 'Color and style',
  'personal_information': 'Personal information',
  'shipping_address': 'Shipping address',
  'password': 'Password',
};

class ShippingAddress {
  String apartment;
  String city;
  String country;
  String street;
  String zipCode;
  String id;

  ShippingAddress();

  ShippingAddress.fromMap(dynamic obj) {
    apartment = obj['apartment'];
    city = obj['city'];
    country = obj['country'];
    street = obj['street'];
    zipCode = obj['zipCode'];
    id = obj['_id'];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['apartment'] = apartment ?? '';
    map['city'] = city ?? '';
    map['country'] = country ?? '';
    map['street'] = street ?? '';
    map['zipCode'] = zipCode ?? '';
    return map;
  }

  String getAddressLine(List<Country> countries) {
    String addressLine = '';
    if (street != null && street != '') {
      addressLine = street;
    }
    if (apartment != null && apartment != '') {
      if (addressLine == '') {
        addressLine = apartment;
      } else {
        addressLine = '$addressLine, $apartment';
      }
    }
    if (zipCode != null && zipCode != '') {
      if (addressLine == '') {
        addressLine = zipCode;
      } else {
        addressLine = '$addressLine, $zipCode';
      }
    }
    if (city != null && city != '') {
      if (addressLine == '') {
        addressLine = city;
      } else {
        addressLine = '$addressLine, $city';
      }
    }
    if (country != null && country != '') {
      String countryString = country;
      List<Country> matchCountries = countries.where((element) => element.countryCode == country).toList();
      if (matchCountries.length > 0) {
        countryString = matchCountries.first.name;
      }
      if (addressLine == '') {
        addressLine = countryString;
      } else {
        addressLine = '$addressLine, $countryString';
      }
    }
    return addressLine;
  }
}