import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';

class Products {
  String _business;
  String _id;
  String _lastSale;
  String _name;
  num _quantity;
  num _price;
  num _salePrice;
  String _thumbnail;
  String _uuid;
  num __v;
  String __id;

  Products.toMap(dynamic obj) {
    _business = obj[GlobalUtils.DB_PROD_BUSINESS];
    _id = obj[GlobalUtils.DB_PROD_ID];
    _lastSale = obj[GlobalUtils.DB_PROD_LAST_SELL];
    _name = obj[GlobalUtils.DB_PROD_NAME];
    _quantity = obj[GlobalUtils.DB_PROD_QUANTITY];
    _price = obj[GlobalUtils.DB_PROD_MODEL_PRICE];
    _salePrice = obj[GlobalUtils.DB_PROD_MODEL_SALE_PRICE];
    _thumbnail = obj[GlobalUtils.DB_PROD_THUMBNAIL];
    _uuid = obj[GlobalUtils.DB_PROD_UUID];

    __id = obj[GlobalUtils.DB_PROD__ID];
    __v = obj[GlobalUtils.DB_PROD__V];
  }

  String get lastSaleDays {
    DateTime time = DateTime.parse(_lastSale);
    DateTime now = DateTime.now();
    if (now.difference(time).inDays < 1) {
      if (now.difference(time).inHours < 1) {
        return "${now.difference(time).inMinutes} minutes ago";
      } else {
        return "${now.difference(time).inHours} hrs ago";
      }
    } else {
      if (now.difference(time).inDays < 8) {
        return "${now.difference(time).inDays} days ago";
      } else {
        return "${DateFormat.d("en_US").add_M().add_y().format(time).replaceAll(" ", ".")}";
      }
    }
  }

  String get business => _business;

  String get id => _id;

  String get lastSale => _lastSale;

  String get name => _name;

  num get quantity => _quantity;

  num get price => _price;

  num get salePrice => _salePrice;

  String get thumbnail => _thumbnail;

  String get uuid => _uuid;

  num get v => __v;

  String get customId => __id;
}

class ProductsModel {
  ProductsModel({this.id});

  List<String> images = List();
  String uuid = '';
  String title = '';
  String description = '';
  String id = '';
  bool hidden = false;
  bool active = true;
  num price = 0;
  num salePrice = 0;
  String sku = '';
  String barcode = '';
  String currency = 'EUR';
  String type = 'physical';
  bool onSales = false;
  num vatRate = 0;
  String businessUuid = '';
  List<Categories> categories = List();
  List<ChannelSet> channels = List();
  List<CollectionModel> collections = List();
  List<Variants> variants = List();
  Shipping shipping = Shipping();

  ProductsModel.toMap(dynamic obj) {
    uuid = obj[GlobalUtils.DB_PROD_MODEL_UUID] ?? "";
    id = obj[GlobalUtils.DB_PROD_ID] ?? "";
    title = obj[GlobalUtils.DB_PROD_MODEL_TITLE];
    description = obj[GlobalUtils.DB_PROD_MODEL_DESCRIPTION];
    hidden = obj[GlobalUtils.DB_PROD_MODEL_HIDDEN];
    active = obj[GlobalUtils.DB_PROD_MODEL_ACTIVE];
    price = obj[GlobalUtils.DB_PROD_MODEL_PRICE];
    salePrice = obj[GlobalUtils.DB_PROD_MODEL_SALE_PRICE];
    sku = obj[GlobalUtils.DB_PROD_MODEL_SKU];
    barcode = obj[GlobalUtils.DB_PROD_MODEL_BARCODE];
    currency = obj[GlobalUtils.DB_PROD_MODEL_CURRENCY];
    vatRate = obj[GlobalUtils.DB_PROD_MODEL_VAT_RATE];
    type = obj[GlobalUtils.DB_PROD_MODEL_TYPE];
    onSales = obj[GlobalUtils.DB_PROD_MODEL_SALES];
    businessUuid = obj['businessUuid'];

    if (obj[GlobalUtils.DB_PROD_MODEL_IMAGES] != null)
      obj[GlobalUtils.DB_PROD_MODEL_IMAGES].forEach((img) {
        images.add(img);
      });
    if (obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES] != null)
      obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES].forEach((categ) {
        if (categ != null) categories.add(Categories.toMap(categ));
      });
    if (obj[GlobalUtils.DB_PROD_MODEL_CHANNEL_SET] != null)
      obj[GlobalUtils.DB_PROD_MODEL_CHANNEL_SET].forEach((ch) {
        channels.add(ChannelSet.fromJson(ch));
      });
    if (obj[GlobalUtils.DB_PROD_MODEL_VARIANTS] != null)
      obj[GlobalUtils.DB_PROD_MODEL_VARIANTS].forEach((variant) {
        variants.add(Variants.toMap(variant));
      });
    if (obj['collections'] != null)
      obj['collections'].forEach((col) {
        collections.add(CollectionModel.toMap(col));
      });
    if (obj[GlobalUtils.DB_PROD_MODEL_SHIPPING] != null)
      shipping = Shipping.toMap(obj[GlobalUtils.DB_PROD_MODEL_SHIPPING]);
  }
  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['active'] = active;
    map['barcode'] = barcode;
    map['onSales'] = onSales;
    map['price'] = price;
    map['salePrice'] = salePrice;
    map['description'] = description;
    map['vatRate'] = vatRate;
    map['sku'] = sku;
    map['title'] = title;
    map['type'] = type;
    map['businessUuid'] = businessUuid;

    if (categories.length > 0) {
      List categoryMapArr = [];
      categories.forEach((element) {
        categoryMapArr.add(element.toDictionary());
      });
      map['categories'] = categoryMapArr;
    } else {
      map['categories'] = [];
    }

    if (channels.length > 0) {
      List channelArr = [];
      channels.forEach((element) {
        channelArr.add(element.toDictionary());
      });
      map['channelSets'] = channelArr;
    } else {
      map['channelSets'] = [];
    }
    map['images'] = images;

    if (shipping != null) {
      map['shipping'] = shipping.toDictionary();
    } else {
      map['shipping'] = {};
    }

    if (variants.length > 0) {
      List variantsArr = [];
      variants.forEach((element) {
        variantsArr.add(element.toDictionary());
      });
      map['variants'] = variantsArr;
    } else {
      map['variants'] = [];
    }
    return map;
  }
}

class Categories {
  String title;
  String businessUuid;
  String slug;
  String id;

  Categories.toMap(dynamic obj) {
    title = obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES_TITLE];
    slug = obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES_SLUG];
    id = obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES__ID];
    businessUuid = obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES_BUSINESS_UUID];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['title'] = title;
    map['slug'] = slug;
    map['id'] = id;
    map['businessUuid'] = businessUuid;
    return map;
  }
}

class Variants {
  Variants();

  String id = '';
  List<String> images = [];
  String title = '';
  String description = '';
  bool hidden = false;
  bool onSales = false;
  num price = 0;
  num salePrice;
  String sku = '';
  String barcode = '';
  List<VariantOption> options = [];

  Variants.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_PROD_MODEL_VAR_ID];
    title = obj[GlobalUtils.DB_PROD_MODEL_VAR_TITLE];
    description = obj[GlobalUtils.DB_PROD_MODEL_VAR_DESCRIPTION];
    hidden = obj[GlobalUtils.DB_PROD_MODEL_VAR_HIDDEN];
    price = obj[GlobalUtils.DB_PROD_MODEL_VAR_PRICE];
    salePrice = obj[GlobalUtils.DB_PROD_MODEL_VAR_SALE_PRICE];
    sku = obj[GlobalUtils.DB_PROD_MODEL_VAR_SKU];
    onSales = obj[GlobalUtils.DB_PROD_MODEL_SALES];
    barcode = obj[GlobalUtils.DB_PROD_MODEL_VAR_BARCODE];
    obj[GlobalUtils.DB_PROD_MODEL_VAR_IMAGES].forEach((img) {
      images.add(img);
    });
    if (obj['options'] != null) {
      obj['options'].forEach((op) {
        options.add(VariantOption.toMap(op));
      });
    }
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['description'] = description;
    map['price'] = price;
    map['salePrice'] = salePrice;
    map['sku'] = sku;
    map['barcode'] = barcode;
    map['images'] = images;
    map['onSales'] = onSales;

    if (options.length > 0) {
      List optionsArr = [];
      options.forEach((element) {
        optionsArr.add(element.toDictionary());
      });
      map['options'] = optionsArr;
    }

    return map;
  }
}

class Shipping {
  Shipping();

  bool free = false;
  bool general = false;
  num weight = 0;
  num width = 0;
  num length = 0;
  num height = 0;

  Shipping.toMap(dynamic obj) {
    free = obj[GlobalUtils.DB_PROD_MODEL_SHIP_FREE];
    general = obj[GlobalUtils.DB_PROD_MODEL_SHIP_GENERAL];
    weight = obj[GlobalUtils.DB_PROD_MODEL_SHIP_WEIGHT];
    width = obj[GlobalUtils.DB_PROD_MODEL_SHIP_WIDTH];
    length = obj[GlobalUtils.DB_PROD_MODEL_SHIP_LENGTH];
    height = obj[GlobalUtils.DB_PROD_MODEL_SHIP_HEIGHT];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['weight'] = weight;
    map['width'] = width;
    map['length'] = length;
    map['height'] = height;
    return map;
  }
}

class Info {
  Info();
  num page = 0;
  num pageCount = 0;
  num perPage = 0;
  num itemCount = 0;

  Info.toMap(dynamic obj) {
    page = obj['page'];
    if (obj['pageCount'] != null) {
      pageCount = obj['pageCount'];
    } else if (obj['page_count'] != null) {
      pageCount = obj['page_count'];
    }
    if (obj['pageCount'] != null) {
      perPage = obj['perPage'];
    } else if (obj['per_page'] != null) {
      perPage = obj['per_page'];
    }
    if (obj['pageCount'] != null) {
      itemCount = obj['itemCount'];
    } else if (obj['item_count'] != null) {
      itemCount = obj['item_count'];
    }
  }
}

class InventoryModel {
  InventoryModel();

  String barcode = '';
  String business = '';
  String createdAt = '';
  bool isNegativeStockAllowed = false;
  bool isTrackable = false;
  String sku = '';
  num stock = 0;
  num reserved = 0;
  String updatedAt = '';
  num v;
  String id = '';

  InventoryModel.toMap(dynamic obj) {
    barcode = obj[GlobalUtils.DB_INV_MODEL_BARCODE] ?? '';
    business = obj[GlobalUtils.DB_INV_MODEL_BUSINESS] ?? '';
    createdAt = obj[GlobalUtils.DB_INV_MODEL_CREATED_AT] ?? '';
    isNegativeStockAllowed = obj[GlobalUtils.DB_INV_MODEL_IS_NEGATIVE_ALLOW] ?? false;
    isTrackable = obj[GlobalUtils.DB_INV_MODEL_IS_TRACKABLE] ?? false ;
    sku = obj[GlobalUtils.DB_INV_MODEL_SKU] ?? '';
    stock = obj[GlobalUtils.DB_INV_MODEL_STOCK] ?? 0;
    reserved = obj[GlobalUtils.DB_INV_MODEL_RESERVED] ?? 0;
    updatedAt = obj[GlobalUtils.DB_INV_MODEL_UPDATE_AT] ?? '';
    v = obj[GlobalUtils.DB_INV_MODEL_V] ?? '';
    id = obj[GlobalUtils.DB_INV_MODEL_ID] ?? '';
  }

}

class VariantsRef {
  VariantsRef();

  String id;
  List<String> images = List();
  String title;
  String description;
  bool hidden;
  num price;
  num salePrice;
  String sku;
  String barcode;
  List<VariantType> type = List();

  VariantsRef.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_PROD_MODEL_VAR_ID];
    title = obj[GlobalUtils.DB_PROD_MODEL_VAR_TITLE];
    description = obj[GlobalUtils.DB_PROD_MODEL_VAR_DESCRIPTION];
    hidden = obj[GlobalUtils.DB_PROD_MODEL_VAR_HIDDEN];
    price = obj[GlobalUtils.DB_PROD_MODEL_VAR_PRICE];
    salePrice = obj[GlobalUtils.DB_PROD_MODEL_VAR_SALE_PRICE];
    sku = obj[GlobalUtils.DB_PROD_MODEL_VAR_SKU];
    barcode = obj[GlobalUtils.DB_PROD_MODEL_VAR_BARCODE];
    obj[GlobalUtils.DB_PROD_MODEL_VAR_IMAGES].forEach((img) {
      images.add(img);
    });
  }
}

class VariantType {
  String type;
  String value;

  VariantType.toMap(dynamic obj) {
    type = obj['type'];
    value = obj['value'];
  }
}

class VariantOption {

  VariantOption({this.name = '', this.value = ''});
  String name;
  String value;

  VariantOption.toMap(dynamic obj) {
    name = obj['name'];
    value = obj['value'];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['name'] = name;
    map['value'] = value;
    return map;
  }
}

class CollectionModel {

  CollectionModel();

  String activeSince = '';
  String business = '';
  List<ChannelSet> channelSets = [];
  String createdAt = '';
  String description = '';
  String name = '';
  String image = '';
  String slug = '';
  String updatedAt = '';
  num v = 0;
  String id = '';
  FillCondition automaticFillConditions = FillCondition();
  CollectionModel.toMap(dynamic obj) {
    activeSince = obj['activeSince'];
    business = obj['business'];
    createdAt = obj['createdAt'];
    description = obj['description'];
    name = obj['name'];
    image = obj['image'];
    slug = obj['slug'];
    updatedAt = obj['updatedAt'];
    v = obj['__v'];
    id = obj['_id'];
    List channelObj = obj['channelSets'];
    if (channelObj != null) {
      channelObj.forEach((element) {
        channelSets.add(ChannelSet.fromJson(element));
      });
    }
    if (obj['automaticFillConditions'] != null) {
      automaticFillConditions = FillCondition.toMap(obj['automaticFillConditions']);
    }
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['description'] = description;

    return map;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    String dateString = DateFormat("yyyy-MM-dd'T'hh:mm:ss").format(DateTime.now());
    map['name'] = name;
    map['activeSince'] = dateString;
    map['slug'] = slug;
    map['description'] = description;
    if (image != null) {
      map['image'] = image;
    }
    List channelSetsArr = [];
    channelSets.forEach((element) {
      channelSetsArr.add(element.toDictionary());
    });
    map['channelSets'] = channelSetsArr;
    if (automaticFillConditions != null) {
      map['automaticFillConditions'] = automaticFillConditions.toDictionary();
    }

    return map;
  }
}

class FillCondition {
  FillCondition();

  List<Filter> filters = [];
  List<String> manualProductsList = [];
  bool strict = false;
  String id;

  FillCondition.toMap(dynamic obj) {
    List productsObj = obj['manualProductsList'];
    if (productsObj != null) {
      productsObj.forEach((element) {
        manualProductsList.add(element);
      });
    }
    List filtersObj = obj['filters'];
    if (filtersObj != null) {
      filtersObj.forEach((element) {
        filters.add(Filter.toMap(element));
      });
    }
    strict = obj['strict'];
    id = obj['_id'];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['strict'] = strict;
    List filtersObj = [];
    filters.forEach((element) {
      filtersObj.add(element.toDictionary());
    });
    map['filters'] = filtersObj;
    return map;
  }
}

class Filter {

  Filter({this.field, this.fieldCondition, this.fieldType, this.value});
  String field;
  String fieldCondition;
  String fieldType;
  List<Filter> filters = [];
  String value;
  String id;

  Filter.toMap(dynamic obj) {
    value = obj['value'];
    id = obj['_id'];
    field = obj['field'];
    fieldCondition = obj['fieldCondition'];
    fieldType = obj['fieldType'];
    List filtersObj = obj['filters'];
    if (filtersObj != null) {
      filtersObj.forEach((element) {
        filters.add(Filter.toMap(element));
      });
    }
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['field'] = field;
    map['fieldCondition'] = fieldCondition;
    map['fieldType'] = fieldType;
    map['value'] = value;
    return map;
  }
}

class ProductListModel {
  bool isChecked;
  ProductsModel productsModel;

  ProductListModel({this.productsModel, this.isChecked});
}

class CollectionListModel {
  bool isChecked;
  CollectionModel collectionModel;

  CollectionListModel({this.collectionModel, this.isChecked});
}

class Tax {
  String country;
  String description;
  String id;
  num rate;

  Tax.toMap(dynamic obj) {
    country = obj['country'];
    description = obj['description'];
    id = obj['id'];
    rate = obj['rate'];
  }
}

class SkuDetail {
  String barcode;
  String business;
  String createdAt;
  bool isNegativeStockAllowed = false;
  bool isTrackable = false;
  String sku;
  num stock;
  String updatedAt;
  num __v;
  String _id;

  SkuDetail.toMap(dynamic obj) {
    barcode = obj['barcode'];
    business = obj['business'];
    createdAt = obj['createdAt'];
    isNegativeStockAllowed = obj['isNegativeStockAllowed'];
    isTrackable = obj['isTrackable'];
    sku = obj['sku'];
    stock = obj['stock'];
    updatedAt = obj['updatedAt'];
    __v = obj['__v'];
    _id = obj['_id'];
  }
}