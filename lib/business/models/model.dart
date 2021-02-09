import 'package:payever/settings/models/models.dart';

class BusinessFormData {
  List<String> businessStatuses = [];
  List<BusinessProduct> products = [];
  List<String> statuses = [];

  BusinessFormData.fromMap(dynamic obj) {
    dynamic businessStatusesObj = obj['businessStatuses'];
    if (businessStatusesObj is List) {
      businessStatusesObj.forEach((element) {
        businessStatuses.add(element.toString());
      });
    }
    dynamic productsObj = obj['products'];
    if (productsObj is List) {
      productsObj.forEach((element) {
        products.add(BusinessProduct.fromMap(element));
      });
    }
    dynamic statusesObj = obj['statuses'];
    if (statusesObj is List) {
      statusesObj.forEach((element) {
        statuses.add(element.toString());
      });
    }
  }
}

Map<String, String> businessStatusMap = {
  'REGISTERED_BUSINESS': 'Registered Business',
  'SOLO_ENTREPRENEUR': 'Solo Entrepreneur',
};

Map<String, String> statusesMap = {
  'BUSINESS_STATUS_JUST_LOOKING': 'Just looking around',
  'BUSINESS_STATUS_HAVE_IDEA': 'I have an idea want to get started',
  'BUSINESS_STATUS_TURN_EXISTING': 'Turing an existing into a business',
  'BUSINESS_STATUS_GROWING_BUSINESS': 'Growing an existing business',
  'BUSINESS_STATUS_REPLACE_BUSINESS': 'Replace my business with payever',
};