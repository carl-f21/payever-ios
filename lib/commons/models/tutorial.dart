import '../utils/utils.dart';

class Tutorial {
  bool init;
  String icon;
  num order;
  String title;
  String type;
  String url;
  bool watched;
  String id;
  List<Urls> urls = [];

  Tutorial.map(dynamic obj) {
    init = obj[GlobalUtils.DB_TUTORIAL_INIT];
    icon = obj[GlobalUtils.DB_TUTORIAL_ICON];
    order = obj[GlobalUtils.DB_TUTORIAL_ORDER];
    title = obj[GlobalUtils.DB_TUTORIAL_TITLE];
    type = obj[GlobalUtils.DB_TUTORIAL_TYPE];
    url = obj[GlobalUtils.DB_TUTORIAL_URL];
    watched = obj[GlobalUtils.DB_TUTORIAL_WATCHED];
    id = obj[GlobalUtils.DB_TUTORIAL_ID];
    dynamic urlsObj = obj['urls'];
    if (urlsObj is List) {
      urlsObj.forEach((element) {
        urls.add(Urls.fromMap(element));
      });
    }
  }
}

class Urls {
  String language;
  String url;

  Urls.fromMap(dynamic obj) {
    language = obj['language'];
    url = obj['url'];
  }
}