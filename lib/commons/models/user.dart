import 'package:payever/settings/models/models.dart';

import '../utils/utils.dart';

class User {

  String createdAt;
  String birthday;
  String email;
  String firstName;
  bool hasUnfinishedBusinessRegistration;
  String language;
  String lastName;
  String fullName = '';
  String logo;
  String phone;
  String salutation;
  String updatedAt;
  String id;
  List<ShippingAddress> shippingAddresses = [];

  User(
      this.createdAt,
      this.birthday,
      this.email,
      this.firstName,
      this.hasUnfinishedBusinessRegistration,
      this.language,
      this.lastName,
      this.logo,
      this.phone,
      this.salutation,
      this.updatedAt,
      this.id,
      this.shippingAddresses,
      );

  User.map(dynamic obj) {
    this.id = obj[GlobalUtils.DB_USER_ID];
    this.firstName = obj[GlobalUtils.DB_USER_FIRST_NAME];
    this.lastName = obj[GlobalUtils.DB_USER_LAST_NAME];
    this.language = obj[GlobalUtils.DB_USER_LANGUAGE];
    this.updatedAt = obj[GlobalUtils.DB_USER_UPDATED_AT];
    this.createdAt = obj[GlobalUtils.DB_USER_CREATED_AT];
    this.email = obj[GlobalUtils.DB_USER_EMAIL];

    this.salutation = obj[GlobalUtils.DB_USER_SALUTATION];
    this.phone = obj[GlobalUtils.DB_USER_PHONE];
    this.logo = obj[GlobalUtils.DB_USER_LOGO];
    this.birthday = obj[GlobalUtils.DB_USER_BIRTHDAY];
    this.hasUnfinishedBusinessRegistration = obj['hasUnfinishedBusinessRegistration'];
    if (this.firstName != null && this.firstName.isNotEmpty) {
      this.fullName = this.firstName;
    }
    if (this.lastName != null && this.lastName.isNotEmpty) {
      if (this.fullName.isNotEmpty) {
        this.fullName = this.fullName + ' ' + this.lastName;
      } else {
        this.fullName = this.lastName;
      }
    }
    dynamic shippingAddressesObj = obj['shippingAddresses'];
    if (shippingAddressesObj is List) {
      for (var value in shippingAddressesObj) {
        shippingAddresses.add(ShippingAddress.fromMap(value));
      }
    }
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[GlobalUtils.DB_USER_ID] = id;
    map[GlobalUtils.DB_USER_FIRST_NAME] = firstName;
    map[GlobalUtils.DB_USER_LAST_NAME] = lastName;
    map[GlobalUtils.DB_USER_LANGUAGE] = language;
    map[GlobalUtils.DB_USER_UPDATED_AT] = updatedAt;
    map[GlobalUtils.DB_USER_CREATED_AT] = createdAt;
    map[GlobalUtils.DB_USER_EMAIL] = email;
    map[GlobalUtils.DB_USER_SALUTATION] = salutation;
    map[GlobalUtils.DB_USER_PHONE] = phone;
    map[GlobalUtils.DB_USER_BIRTHDAY] = birthday;
    map[GlobalUtils.DB_USER_LOGO] = logo;
    map['hasUnfinishedBusinessRegistration'] = hasUnfinishedBusinessRegistration;
    map['shippingAddresses'] = shippingAddresses;
    return map;
  }
}

class AuthUser {
  String createdAt;
  String email;
  String firstName;
  String id;
  String lastName;
  String resetPasswordExpires;
  String resetPasswordToken;
  List<Role> roles = [];
  bool secondFactorRequired = false;
  String updatedAt;
  num v;
  String uid;

  AuthUser.fromMap(dynamic obj) {
    createdAt = obj['createdAt'];
    email = obj['email'];
    firstName = obj['first_name'];
    id = obj['id'];
    lastName = obj['last_name'];
    resetPasswordExpires = obj['resetPasswordExpires'];
    resetPasswordToken = obj['resetPasswordToken'];
    secondFactorRequired = obj['secondFactorRequired'] ?? false;
    updatedAt = obj['updatedAt'];
    v = obj['__v'];
    uid = obj['_id'];
    dynamic rolesObj = obj['roles'];
    if (rolesObj is List) {
      rolesObj.forEach((element) {
        roles.add(Role.fromMap(element));
      });
    }
  }
}