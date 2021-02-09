import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/models/business_apps.dart';
import 'package:payever/commons/models/user.dart';


class StandardData {
  static List<BusinessApps> businessWidgets = [];
  static List<AppWidget> currentWidgets = [];
  static Business activeBusiness;
  static List<Business> businesses = [];
  static User user;

  StandardData(context) {
    DefaultAssetBundle.of(context)
        .loadString("assets/json/app_widgets_template.json", cache: true)
        .then((value) {
      dynamic map = JsonDecoder().convert(value);
      businessWidgets.clear();
      map.forEach((item) {
        businessWidgets.add(BusinessApps.fromMap(item));
      });
    }).catchError((onError) {
      print(onError);
    });

    DefaultAssetBundle.of(context)
        .loadString("assets/json/business_apps_template.json", cache: true)
        .then((value) {
      dynamic map = JsonDecoder().convert(value);
      currentWidgets.clear();
      map.forEach((item) {
        currentWidgets.add(AppWidget.map(item));
      });
    }).catchError((onError) {
      print(onError);
    });

    DefaultAssetBundle.of(context)
        .loadString("assets/json/user_template.json", cache: true)
        .then((value) {
      dynamic map = JsonDecoder().convert(value);
      user = User.map(map);
    }).catchError((onError) {
      print(onError);
    });

    DefaultAssetBundle.of(context)
        .loadString("assets/json/businesses_template.json", cache: true)
        .then((value) {
      dynamic map = JsonDecoder().convert(value);
      businesses.clear();
      map.forEach((item) {
        Business business = Business.map(item);
        if (business.active) {
          activeBusiness = business;
        }
        businesses.add(business);
      });
    }).catchError((onError) {
      print(onError);
    });


  }
}
