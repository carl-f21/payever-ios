import 'package:payever/commons/models/fetchwallpaper.dart';
import '../utils/utils.dart';

class Business {
  String id;
  bool active;
  bool hidden;
  String createdAt;
  String updatedAt;
  String currency;
  String email;
  String logo;
  String name;
  String userId;
  num v;
  String defaultLanguage;
  CompanyAddress companyAddress;
  CompanyDetails companyDetails;
  ContactDetails contactDetails;
  BankAccount bankAccount;
  List<String> contactEmails = [];
  List<String> cspAllowedHosts = [];
  CurrentWallpaper currentWallpaper;
  Documents documents;
  ThemeSetting themeSettings;
  Taxes taxes;

  Business({this.id});

  Business.map(dynamic obj) {
    this.id = obj[GlobalUtils.DB_BUSINESS_ID];
    this.updatedAt = obj[GlobalUtils.DB_BUSINESS_UPDATED_AT];
    this.createdAt = obj[GlobalUtils.DB_BUSINESS_CREATE_AT];
    this.email = obj[GlobalUtils.DB_BUSINESS_EMAIL];
    this.logo = obj[GlobalUtils.DB_BUSINESS_LOGO];
    this.active = obj[GlobalUtils.DB_BUSINESS_ACTIVE];
    this.hidden = obj[GlobalUtils.DB_BUSINESS_HIDDEN];
    this.currency = obj[GlobalUtils.DB_BUSINESS_CURRENCY];
    this.name = obj[GlobalUtils.DB_BUSINESS_NAME];

    this.v = obj['v'];
    this.userId = obj['userId'];
    this.defaultLanguage = obj['defaultLanguage'];

    if (obj[GlobalUtils.DB_BUSINESS_COMPANY_ADDRESS] != null) {
      this.companyAddress =
          CompanyAddress.map(obj[GlobalUtils.DB_BUSINESS_COMPANY_ADDRESS]);
    }
    if (obj[GlobalUtils.DB_BUSINESS_COMPANY_DETAILS] != null) {
      this.companyDetails =
          CompanyDetails.map(obj[GlobalUtils.DB_BUSINESS_COMPANY_DETAILS]);
    }
    if (obj[GlobalUtils.DB_BUSINESS_CONTACT_DETAILS] != null) {
      this.contactDetails =
          ContactDetails.map(obj[GlobalUtils.DB_BUSINESS_CONTACT_DETAILS]);
    }
    if (obj['bankAccount'] != null) {
      this.bankAccount =
          BankAccount.fromMap(obj['bankAccount']);
    }
    if (obj['contactEmails'] != null) {
      List list = obj['contactEmails'];
      if (list != null) {
        list.forEach((element) {
          this.contactEmails.add(element.toString());
        });
      }
    }
    if (obj['cspAllowedHosts'] != null) {
      List list = obj['cspAllowedHosts'];
      if (list != null) {
        list.forEach((element) {
          cspAllowedHosts.add(element.toString());
        });
      }
    }
    if (obj['currentWallpaper'] != null) {
      this.currentWallpaper =
          CurrentWallpaper.map(obj['currentWallpaper']);
    }
    if (obj['documents'] != null) {
      this.documents =
          Documents.fromMap(obj['documents']);
    }
    if (obj['themeSettings'] != null) {
      this.themeSettings =
          ThemeSetting.fromMap(obj['themeSettings']);
    }
    if (obj['taxes'] != null) {
      this.taxes =
          Taxes.fromMap(obj['taxes']);
    } else {
      this.taxes = Taxes();
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map[GlobalUtils.DB_BUSINESS_ID] = id;
    map[GlobalUtils.DB_BUSINESS_UPDATED_AT] = updatedAt;
    map[GlobalUtils.DB_BUSINESS_CREATE_AT] = createdAt;
    map[GlobalUtils.DB_BUSINESS_EMAIL] = email;
    map[GlobalUtils.DB_BUSINESS_LOGO] = logo;
    map[GlobalUtils.DB_BUSINESS_ACTIVE] = active;
    map[GlobalUtils.DB_BUSINESS_HIDDEN] = hidden;
    map[GlobalUtils.DB_BUSINESS_CURRENCY] = currency;
    map[GlobalUtils.DB_BUSINESS_NAME] = name;

    return map;
  }
}

class CompanyAddress {
  String city;
  String country;
  String createdAt;
  String updatedAt;
  String street;
  String zipCode;
  String id;
  String googleAutocomplete;

  CompanyAddress.map(dynamic obj) {
    this.city = obj[GlobalUtils.DB_BUSINESS_CA_CITY];
    this.country = obj[GlobalUtils.DB_BUSINESS_CA_COUNTRY];
    this.createdAt = obj[GlobalUtils.DB_BUSINESS_CA_CREATED_AT];
    this.updatedAt = obj[GlobalUtils.DB_BUSINESS_CA_UPDATED_AT];
    this.street = obj[GlobalUtils.DB_BUSINESS_CA_STREET];
    this.zipCode = obj[GlobalUtils.DB_BUSINESS_CA_ZIP_CODE];
    this.id = obj[GlobalUtils.DB_BUSINESS_CA_ID];
    this.googleAutocomplete = obj['googleAutocomplete'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['city'] = city;
    map['country'] = country;
    map['googleAutocomplete'] = googleAutocomplete;
    map['street'] = street;
    map['zipCode'] = zipCode;

    return map;
  }
}

class CompanyDetails {
  String createdAt;
  String foundationYear;
  String industry;
  String product;
  String updatedAt;
  String legalForm;
  String urlWebsite;
  String id;
  SalesRange salesRange;
  EmployeesRange employeesRange;

  CompanyDetails.map(dynamic obj) {
    this.createdAt = obj[GlobalUtils.DB_BUSINESS_CMDT_CREATED_AT];
    this.foundationYear = obj[GlobalUtils.DB_BUSINESS_CMDT_FOUNDATION_YEAR];
    this.industry = obj[GlobalUtils.DB_BUSINESS_CMDT_INDUSTRY];
    this.product = obj[GlobalUtils.DB_BUSINESS_CMDT_PRODUCT];
    this.updatedAt = obj[GlobalUtils.DB_BUSINESS_CMDT_UPDATED_AT];
    this.id = obj[GlobalUtils.DB_BUSINESS_CMDT_ID];
    this.legalForm = obj['legalForm'];
    this.urlWebsite = obj['urlWebsite'];

    if (obj[GlobalUtils.DB_BUSINESS_CMDT_SALES_RANGE] != null) {
      this.salesRange =
          SalesRange.map(obj[GlobalUtils.DB_BUSINESS_CMDT_SALES_RANGE]);
    }
    if (obj[GlobalUtils.DB_BUSINESS_CMDT_EMPLOYEES_RANGE] != null) {
      this.employeesRange =
          EmployeesRange.map(obj[GlobalUtils.DB_BUSINESS_CMDT_EMPLOYEES_RANGE]);
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['foundationYear'] = foundationYear;
    map['industry'] = industry;
    map['legalForm'] = legalForm;
    map['product'] = product;
    map['urlWebsite'] = urlWebsite;
    return map;
  }
}

class EmployeesRange {
  int max;
  int min;
  String id;

  EmployeesRange.map(dynamic obj) {
    this.min = obj[GlobalUtils.DB_BUSINESS_CMDT_EMP_RANGE_MIN];
    this.max = obj[GlobalUtils.DB_BUSINESS_CMDT_EMP_RANGE_MAX];
    this.id = obj[GlobalUtils.DB_BUSINESS_CMDT_EMP_RANGE_ID];
  }
}

class SalesRange {
  int max;
  int min;
  String id;

  SalesRange.map(dynamic obj) {
    this.min = obj[GlobalUtils.DB_BUSINESS_CMDT_SALES_RANGE_MIN];
    this.max = obj[GlobalUtils.DB_BUSINESS_CMDT_SALES_RANGE_MAX];
    this.id = obj[GlobalUtils.DB_BUSINESS_CMDT_SALES_RANGE_ID];
  }
}

class ContactDetails {
  String additionalPhone;
  String createdAt;
  String fax;
  String firstName;
  String lastName;
  String phone;
  String salutation;
  String updatedAt;
  String id;

  ContactDetails.map(dynamic obj) {
    this.createdAt = obj[GlobalUtils.DB_BUSINESS_CNDT_CREATED_AT];
    this.firstName = obj[GlobalUtils.DB_BUSINESS_CNDT_FIRST_NAME];
    this.lastName = obj[GlobalUtils.DB_BUSINESS_CNDT_LAST_NAME];
    this.updatedAt = obj[GlobalUtils.DB_BUSINESS_CNDT_UPDATED_AT];
    this.id = obj[GlobalUtils.DB_BUSINESS_CNDT_ID];
    this.additionalPhone = obj['additionalPhone'];
    this.fax = obj['fax'];
    this.phone = obj['phone'];
    this.salutation = obj['salutation'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['additionalPhone'] = additionalPhone;
    map['fax'] = fax;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['phone'] = phone;
    map['salutation'] = salutation;
    return map;
  }
}

class BankAccount {
  String bankName;
  String bic;
  String city;
  String country;
  String createdAt;
  String iban;
  String owner;
  String updatedAt;
  String id;

  BankAccount.fromMap(dynamic obj) {
    bankName = obj['bankName'];
    bic = obj['bic'];
    city = obj['city'];
    country = obj['country'];
    createdAt = obj['createdAt'];
    iban = obj['iban'];
    owner = obj['owner'];
    updatedAt = obj['updatedAt'];
    id = obj['_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['bankName'] = bankName;
    map['bic'] = bic;
    map['city'] = city;
    map['country'] = country;
    map['iban'] = iban;
    map['owner'] = owner;
    return map;
  }
}

class Documents {
  String commercialRegisterExcerptFilename;
  String createdAt;
  String updatedAt;
  String id;

  Documents.fromMap(dynamic obj) {
    commercialRegisterExcerptFilename = obj['commercialRegisterExcerptFilename'];
    createdAt = obj['createdAt'];
    updatedAt = obj['updatedAt'];
    id = obj['_id'];
  }
}

class ThemeSetting {
  String createdAt;
  String theme;
  String updatedAt;
  String id;
  String primaryColor;
  String secondaryColor;

  ThemeSetting.fromMap(dynamic obj) {
    theme = obj['theme'];
    createdAt = obj['createdAt'];
    updatedAt = obj['updatedAt'];
    secondaryColor = obj['secondaryColor'];
    primaryColor = obj['primaryColor'];
    id = obj['_id'];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map;
    map['_id'] = id;
    map['primaryColor'] = primaryColor;
    map['secondaryColor'] = secondaryColor;

    return map;
  }
}

class Taxes {
  String companyRegisterNumber;
  String createdAt;
  String taxId;
  String taxNumber;
  bool turnoverTaxAct;
  String updatedAt;
  String id;

  Taxes();

  Taxes.fromMap(dynamic obj) {
    companyRegisterNumber = obj['companyRegisterNumber'];
    createdAt = obj['createdAt'];
    taxId = obj['taxId'];
    taxNumber = obj['taxNumber'];
    turnoverTaxAct = obj['turnoverTaxAct'];
    updatedAt = obj['updatedAt'];
    id = obj['_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['companyRegisterNumber'] = companyRegisterNumber;
    map['taxId'] = taxId;
    map['taxNumber'] = taxNumber;
    map['turnoverTaxAct'] = turnoverTaxAct;
    return map;
  }
}