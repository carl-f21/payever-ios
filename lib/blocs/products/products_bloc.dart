import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/shop/models/models.dart';

import 'products.dart';

class ProductsScreenBloc extends Bloc<ProductsScreenEvent, ProductsScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  ProductsScreenBloc({this.dashboardScreenBloc});
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;
  @override
  ProductsScreenState get initialState => ProductsScreenState();

  @override
  Stream<ProductsScreenState> mapEventToState(ProductsScreenEvent event) async* {
    if (event is ProductsScreenInitEvent) {
      yield state.copyWith(
        businessId: event.currentBusinessId,
        isLoading: true,
        updateSuccess: false,
        isUpdating: false,
        isSearching: false,
      );
      yield* fetchProducts(event.currentBusinessId);
    } else if (event is CheckProductItem) {
      yield* selectProduct(event.model);
    } else if (event is CheckCollectionItem) {
      yield* selectCollection(event.model);
    } else if (event is ProductsReloadEvent) {
      yield* reloadProducts();
    } else if (event is ProductsLoadMoreEvent) {
      yield* loadMoreProducts();
    } else if (event is CollectionsReloadEvent) {
      yield* reloadCollections();
    } else if (event is CollectionsLoadMoreEvent) {
      yield* loadMoreCollections();
    } else if (event is SelectAllProductsEvent) {
      yield* selectAllProducts();
    } else if (event is UnSelectProductsEvent) {
      yield* unSelectProducts();
    } else if (event is DeleteProductsEvent) {
      yield* deleteProducts(event.models);
    } else if (event is SelectAllCollectionsEvent) {
      yield* selectAllCollections();
    } else if (event is UnSelectCollectionsEvent) {
      yield* unSelectCollections();
    } else if (event is DeleteCollectionProductsEvent) {
      yield* deleteCollections();
    } else if (event is GetProductDetails) {
      if (state.businessId == null || state.businessId == '') {
        yield state.copyWith(businessId: event.businessId);
      }
      if (event.productsModel != null) {
        yield state.copyWith(productDetail: event.productsModel, updatedInventories: [], increaseStock: 0);
        yield* getProductDetail(event.productsModel.id);
      } else {
        yield state.copyWith(productDetail: ProductsModel(), isLoading: true, updatedInventories: [], increaseStock: 0);
        yield* getProductCategories();
      }
    } else if (event is UpdateProductDetail) {
      if (event.productsModel != null) {
        yield state.copyWith(productDetail: event.productsModel,);
      }
      if (event.increaseStock != null) {
        yield state.copyWith(increaseStock: event.increaseStock,);
      }
      if (event.inventoryModel != null) {
        yield state.copyWith(inventory: event.inventoryModel,);
      }
      if (event.inventories != null) {
        yield state.copyWith(updatedInventories: event.inventories,);
      }
    } else if (event is SaveProductDetail) {
      yield* updateProduct(event.productsModel);
    } else if (event is CreateProductEvent) {
      yield* createProduct(event.productsModel);
    } else if (event is UploadImageToProduct) {
      yield* uploadImageToProducts(event.file);
    } else if (event is GetCollectionDetail) {
      if (event.collection != null) {
        yield state.copyWith(collectionDetail: event.collection, deleteList: [], collectionProducts: []);
        yield* getCollectionDetail(event.collection.id);
      } else {
        yield state.copyWith(collectionDetail: new CollectionModel(),collectionProducts: [], deleteList: []);
      }
    } else if (event is UpdateCollectionDetail) {
      if (event.collectionProducts != null) {
        yield state.copyWith(collectionDetail: event.collectionModel, collectionProducts: event.collectionProducts, deleteList: event.deleteList);
      } else {
        yield state.copyWith(collectionDetail: event.collectionModel);
      }
    } else if (event is SaveCollectionDetail) {
      yield* updateCollection(event.collectionModel, event.deleteList);
    } else if (event is CreateCollectionEvent) {
      yield* createCollection(event.collectionModel);
    } else if (event is UploadImageToCollection) {
      yield* uploadImageToCollection(event.file);
    } else if (event is UpdateProductSearchText) {
      yield state.copyWith(searchText: event.searchText);
      yield* searchProducts();
    } else if (event is UpdateProductFilterTypes) {
      yield state.copyWith(filterTypes: event.filterTypes);
      yield* searchProducts();
    } else if (event is UpdateProductSortType) {
      yield state.copyWith(sortType: event.sortType);
      yield* searchProducts();
    } else if (event is CancelProductEdit) {
      yield state.copyWith(
        isLoading: false,
        isUploading: false,
        isSearching: false,
        isUpdating: false,
        productDetail: ProductsModel(),
        collectionDetail: CollectionModel(),
        collectionProducts: [],
      );
    } else if (event is AddToCollectionEvent) {
      yield state.copyWith(addToCollection: true, isProductMode: false);
    } else if (event is CreateCategoryEvent) {
      yield* createCategory(event.title);
    } else if (event is SwitchProductCollectionMode) {
      yield state.copyWith(isProductMode: event.isProductMode);
    }
  }

  Stream<ProductsScreenState> fetchProducts(String activeBusinessId) async* {
    yield state.copyWith(
      isLoading: true,
      inventories: [],
      increaseStock: 0,
      inventory: InventoryModel(),
      productDetail: ProductsModel(),
      updatedInventories: [],
      searchText: '',
    );
    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query': '{\n  getProducts(businessUuid: \"$activeBusinessId\", paginationLimit: 20, pageNumber: 1, orderBy: \"createdAt\", orderDirection: \"desc\", filterById: [], search: \"\", filters: []) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };
    dynamic response = await api.getProducts(token, body);
    Info productInfo;
    List<ProductsModel> products = [];
    List<ProductListModel> productLists = [];
    Info collectionInfo;
    List<CollectionModel> collections = [];
    List<CollectionListModel> collectionLists = [];
    List<InventoryModel> inventories = [];
    if (response is Map) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic getProducts = data['getProducts'];
        if (getProducts != null) {
          dynamic infoObj = getProducts['info'];
          if (infoObj != null) {
            print('infoObj => $infoObj');
            dynamic pagination = infoObj['pagination'];
            if (pagination != null) {
              productInfo = Info.toMap(pagination);
            }
          }
          List productsObj = getProducts['products'];
          if (productsObj != null) {
            productsObj.forEach((element) {
              products.add(ProductsModel.toMap(element));
              productLists.add(ProductListModel(productsModel: ProductsModel.toMap(element), isChecked: false));
            });
          }
        }
      }
    }

    Map<String, String> queryParams = {
      'page': '1',
      'perPage': '20'
    };
    
    dynamic colResponse = await api.getCollections(token, activeBusinessId, queryParams);
    if (colResponse is Map) {
      dynamic infoObj = colResponse['info'];
      if (infoObj != null) {
        dynamic pagination = infoObj['pagination'];
        if (pagination != null) {
          collectionInfo = Info.toMap(pagination);
        }
      }
      List colList = colResponse['collections'];
      if (colList != null) {
        colList.forEach((element) {
          collections.add(CollectionModel.toMap(element));
          collectionLists.add(CollectionListModel(collectionModel: CollectionModel.toMap(element), isChecked: false));
        });
      }
    }

    dynamic inventoryResponse = await api.getInventories(token, activeBusinessId);
    if (inventoryResponse != null) {
      if (inventoryResponse is List) {
        inventoryResponse.forEach((element) {
          inventories.add(InventoryModel.toMap(element));
        });
      }
    }

    yield state.copyWith(
      isLoading: false,
      products: products,
      productsInfo: productInfo,
      collections: collections,
      collectionInfo: collectionInfo,
      productLists: productLists,
      collectionLists: collectionLists,
      inventories: inventories,
    );

  }

  Stream<ProductsScreenState> searchProducts() async* {
    yield state.copyWith(isSearching: true);
    String orderBy = 'default';
    String orderDirection = 'asc';
    if (state.sortType == 'default') {
      orderBy = 'default';
      orderDirection = 'asc';
    } else if (state.sortType == 'name') {
      orderBy = 'title';
      orderDirection = 'asc';
    } else if (state.sortType == 'price_low') {
      orderBy = 'price';
      orderDirection = 'asc';
    } else if (state.sortType == 'price_high') {
      orderBy = 'price';
      orderDirection = 'desc';
    } else if (state.sortType == 'name') {
      orderBy = 'createdAt';
      orderDirection = 'desc';
    } else {
      orderBy = 'createdAt';
      orderDirection = 'desc';
    }
    String filtersString = '';
    if (state.filterTypes.length > 0) {
      for (int i = 0; i < state.filterTypes.length; i++) {
        FilterItem item = state.filterTypes[i];
        String field = item.type;
        String filterCondition = item.condition;
        String filterValue = item.value;
        String type = field == 'price' ? 'number': 'string';
        String queryTemp = '{field: \"$field\", fieldType: \"$type\", fieldCondition: \"$filterCondition\", value: \"$filterValue\"}';
        filtersString = filtersString == '' ? queryTemp : '$filtersString, $queryTemp';
      }
    }

    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query': '{\n  getProducts(businessUuid: \"${state.businessId}\", paginationLimit: 20, pageNumber: 1, orderBy: \"$orderBy\", orderDirection: \"$orderDirection\", filterById: [], search: \"${state.searchText}\", filters: [$filtersString]) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };

    dynamic response = await api.getProducts(token, body);
    Info productInfo;
    List<ProductsModel> products = [];
    List<ProductListModel> productLists = [];
    if (response != null) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic getProducts = data['getProducts'];
        if (getProducts != null) {
          dynamic infoObj = getProducts['info'];
          if (infoObj != null) {
            print('infoObj => $infoObj');
            dynamic pagination = infoObj['pagination'];
            if (pagination != null) {
              productInfo = Info.toMap(pagination);
            }
          }
          List productsObj = getProducts['products'];
          if (productsObj != null) {
            productsObj.forEach((element) {
              products.add(ProductsModel.toMap(element));
              productLists.add(ProductListModel(productsModel: ProductsModel.toMap(element), isChecked: false));
            });
          }
        }
      }
    }

    yield state.copyWith(
      isLoading: false,
      isSearching: false,
      products: products,
      productLists: productLists,
      productsInfo: productInfo,
    );
  }

  Stream<ProductsScreenState> updateProduct(ProductsModel model) async* {
    yield state.copyWith(isLoading: true);
    String businessId = state.businessId;
    Map bodyObj = model.toDictionary();
    bodyObj['businessUuid'] = businessId;
    Map<String, dynamic> body = {
      'operationName': 'updateProduct',
      'variables': {
        'product': bodyObj,
      },
      'query': 'mutation updateProduct(\$product: ProductUpdateInput!) {\n  updateProduct(product: \$product) {\n    title\n    id\n  }\n}\n'
    };
    dynamic response = await api.getProducts(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic updateProduct = data['updateProduct'];
        if (updateProduct != null) {
          var id = updateProduct['id'];
          print('Updates success  => $id');
        }
      }
    }
    List<InventoryModel> inventories = state.inventories;
    List<InventoryModel> updated = state.updatedInventories;
    updated.forEach((update) async {
      InventoryModel inventoryModel = inventories.singleWhere((element) => element.sku == update.sku);
      if (inventoryModel != null) {
        Map<String, dynamic> body = {
          'barcode': update.barcode ?? '',
          'isTrackable': update.isTrackable ?? false,
          'sku': update.sku ?? ''
        };
        dynamic res = await api.updateInventory(token, state.businessId, inventoryModel.sku, body);
        print(res);
        dynamic inventoryResponse = await api.getInventory(
            token, state.businessId, inventoryModel.sku);
        InventoryModel inventory = InventoryModel.toMap(inventoryResponse);

        if (update.stock != inventory.stock) {
          int increase = update.stock - inventory.stock;
          print('increase stock => $increase');
          Map<String, dynamic> body1 = {
            'quantity': increase > 0 ? increase : -increase,
          };
          dynamic res1 = await api.addStockToInventory(token, state.businessId, inventoryModel.sku, body1, increase > 0 ? 'add': 'subtract');
          print(res1);

        }
      }
    });
    yield ProductsScreenState(businessId: businessId);
    yield state.copyWith(updateSuccess: true, businessId: businessId, inventories: updated);
    yield* fetchProducts(businessId);
  }

  Stream<ProductsScreenState> createProduct(ProductsModel model) async* {
    String businessId = state.businessId;
    Map bodyObj = model.toDictionary();
    bodyObj['businessUuid'] = businessId;
    if (bodyObj.containsKey('sku')) {
      bodyObj['sku'] = model.title;
    }
    bodyObj.remove('id');
    Map<String, dynamic> body = {
      'operationName': 'createProduct',
      'variables': {
        'product': bodyObj,
      },
      'query': 'mutation createProduct(\$product: ProductInput!) {\n  createProduct(product: \$product) {\n    title\n    id\n  }\n}\n'
    };
    dynamic response = await api.getProducts(token, body);
    if (response != null) {

    }
    if (response is Map) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic updateProduct = data['createProduct'];
        if (updateProduct != null) {
          var id = updateProduct['id'];
          print('create success  => $id');
        }
      }
    }

    yield ProductsScreenState(businessId: businessId);
    yield state.copyWith(updateSuccess: true, businessId: businessId);
    yield* fetchProducts(businessId);
  }


  Stream<ProductsScreenState> deleteProducts(List<ProductsModel> models) async* {
    String businessId = state.businessId;

    List<String> ids = [];
    models.forEach((element) {
      ids.add(element.id);
    });
    Map<String, dynamic> body = {
      'operationName': 'deleteProduct',
      'variables': {
        'ids': ids,
      },
      'query': 'mutation deleteProduct(\$ids: [String]) {\n  deleteProduct(ids: \$ids)\n}\n'
    };
    dynamic response = await api.getProducts(token, body);
    yield* fetchProducts(businessId);
  }

  Stream<ProductsScreenState> selectProduct(ProductListModel model) async* {
    List<ProductListModel> productLists = state.productLists;
    int index = productLists.indexOf(model);
    productLists[index].isChecked = !model.isChecked;
    yield state.copyWith(productLists: productLists);
  }

  Stream<ProductsScreenState> selectCollection(CollectionListModel model) async* {
    List<CollectionListModel> collectionList = state.collectionLists;
    int index = collectionList.indexOf(model);
    collectionList[index].isChecked = !model.isChecked;
    yield state.copyWith(collectionLists: collectionList);
  }

  Stream<ProductsScreenState> reloadProducts() async* {
    String orderBy = 'default';
    String orderDirection = 'asc';
    if (state.sortType == 'default') {
      orderBy = 'default';
      orderDirection = 'asc';
    } else if (state.sortType == 'name') {
      orderBy = 'title';
      orderDirection = 'desc';
    } else if (state.sortType == 'price_low') {
      orderBy = 'price';
      orderDirection = 'asc';
    } else if (state.sortType == 'price_high') {
      orderBy = 'price';
      orderDirection = 'desc';
    } else if (state.sortType == 'name') {
      orderBy = 'createdAt';
      orderDirection = 'desc';
    }
    String filtersString = '';
    if (state.filterTypes.length > 0) {
      for (int i = 0; i < state.filterTypes.length; i++) {
        FilterItem item = state.filterTypes[i];
        String field = item.type;
        String filterCondition = item.condition;
        String filterValue = item.value;
        String type = field == 'price' ? 'number': 'string';
        String queryTemp = '{field: \"$field\", fieldType: \"$type\", fieldCondition: \"$filterCondition\", value: \"$filterValue\"}';
        filtersString = filtersString == '' ? queryTemp : '$filtersString, $queryTemp';
      }
    }

    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query': '{\n  getProducts(businessUuid: \"${state.businessId}\", paginationLimit: 20, pageNumber: 1, orderBy: \"$orderBy\", orderDirection: \"$orderDirection\", filterById: [], search: \"${state.searchText}\", filters: [$filtersString]) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };

    dynamic response = await api.getProducts(token, body);
    Info productInfo;
    List<ProductsModel> products = [];
    List<ProductListModel> productLists = [];
    if (response != null) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic getProducts = data['getProducts'];
        if (getProducts != null) {
          dynamic infoObj = getProducts['info'];
          if (infoObj != null) {
            print('infoObj => $infoObj');
            dynamic pagination = infoObj['pagination'];
            if (pagination != null) {
              productInfo = Info.toMap(pagination);
            }
          }
          List productsObj = getProducts['products'];
          if (productsObj != null) {
            productsObj.forEach((element) {
              products.add(ProductsModel.toMap(element));
              productLists.add(ProductListModel(productsModel: ProductsModel.toMap(element), isChecked: false));
            });
          }
        }
      }
    }
    yield state.copyWith(
      productsInfo: productInfo,
      products: products,
      productLists: productLists,
    );
  }

  Stream<ProductsScreenState> loadMoreProducts() async* {
    String orderBy = 'default';
    String orderDirection = 'asc';
    if (state.sortType == 'default') {
      orderBy = 'default';
      orderDirection = 'asc';
    } else if (state.sortType == 'name') {
      orderBy = 'title';
      orderDirection = 'desc';
    } else if (state.sortType == 'price_low') {
      orderBy = 'price';
      orderDirection = 'asc';
    } else if (state.sortType == 'price_high') {
      orderBy = 'price';
      orderDirection = 'desc';
    } else if (state.sortType == 'name') {
      orderBy = 'createdAt';
      orderDirection = 'desc';
    }
    String filtersString = '';
    if (state.filterTypes.length > 0) {
      for (int i = 0; i < state.filterTypes.length; i++) {
        FilterItem item = state.filterTypes[i];
        String field = item.type;
        String filterCondition = item.condition;
        String filterValue = item.value;
        String type = field == 'price' ? 'number': 'string';
        String queryTemp = '{field: \"$field\", fieldType: \"$type\", fieldCondition: \"$filterCondition\", value: \"$filterValue\"}';
        filtersString = filtersString == '' ? queryTemp : '$filtersString, $queryTemp';
      }
    }

    int page = state.productsInfo.page + 1;
    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query': '{\n  getProducts(businessUuid: \"${state.businessId}\", paginationLimit: 20, pageNumber: $page, orderBy: \"$orderBy\", orderDirection: \"$orderDirection\", filterById: [], search: \"${state.searchText}\", filters: [$filtersString]) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };

    dynamic response = await api.getProducts(token, body);
    Info productInfo;
    List<ProductsModel> products = [];
    List<ProductListModel> productLists = [];
    productLists.addAll(state.productLists);
    if (response != null) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic getProducts = data['getProducts'];
        if (getProducts != null) {
          dynamic infoObj = getProducts['info'];
          if (infoObj != null) {
            print('infoObj => $infoObj');
            dynamic pagination = infoObj['pagination'];
            if (pagination != null) {
              productInfo = Info.toMap(pagination);
            }
          }
          List productsObj = getProducts['products'];
          if (productsObj != null) {
            productsObj.forEach((element) {
              products.add(ProductsModel.toMap(element));
            });
          }
        }
      }
    }
    if (products.length > 0 && productLists.length == (page - 1) * 20) {
      products.forEach((element) {
        productLists.add(ProductListModel(productsModel: element, isChecked: false));
      });
    }
    yield state.copyWith(
      productsInfo: productInfo,
      products: products,
      productLists: productLists,
    );
  }

  Stream<ProductsScreenState> reloadCollections() async* {
    Info collectionInfo;
    List<CollectionModel> collections = [];
    List<CollectionListModel> collectionLists = [];
    Map<String, String> queryParams = {
      'page': '1',
      'perPage': '20'
    };

    dynamic colResponse = await api.getCollections(token, state.businessId, queryParams);
    if (colResponse != null) {
      dynamic infoObj = colResponse['info'];
      if (infoObj != null) {
        dynamic pagination = infoObj['pagination'];
        if (pagination != null) {
          collectionInfo = Info.toMap(pagination);
        }
      }
      List colList = colResponse['collections'];
      if (colList != null) {
        colList.forEach((element) {
          collections.add(CollectionModel.toMap(element));
          collectionLists.add(CollectionListModel(collectionModel: CollectionModel.toMap(element), isChecked: false));
        });
      }
    }
    yield state.copyWith(
      collectionInfo: collectionInfo,
      collections: collections,
      collectionLists: collectionLists,
    );
 }

  Stream<ProductsScreenState> loadMoreCollections() async* {
    int page = state.collectionInfo.page + 1;
    Info collectionInfo;
    List<CollectionModel> collections = [];
    List<CollectionListModel> collectionLists = [];
    collectionLists.addAll(state.collectionLists);
    Map<String, String> queryParams = {
      'page': '$page',
      'perPage': '20'
    };

    dynamic colResponse = await api.getCollections(token, state.businessId, queryParams);
    if (colResponse != null) {
      dynamic infoObj = colResponse['info'];
      if (infoObj != null) {
        dynamic pagination = infoObj['pagination'];
        if (pagination != null) {
          collectionInfo = Info.toMap(pagination);
        }
      }
      List colList = colResponse['collections'];
      if (colList != null) {
        colList.forEach((element) {
          collections.add(CollectionModel.toMap(element));
        });
      }
    }
    if (collections.length > 0 && collectionLists.length == 20 * (page - 1)) {
      collections.forEach((element) {
        collectionLists.add(CollectionListModel(collectionModel: element, isChecked: false));
      });
    }
    yield state.copyWith(
      collectionInfo: collectionInfo,
      collections: collections,
      collectionLists: collectionLists,
    );
  }

  Stream<ProductsScreenState> selectAllProducts() async* {
    List<ProductListModel> productList = [];
    productList.addAll(state.productLists);
    productList.forEach((element) {
      element.isChecked = true;
    });
    yield state.copyWith(productLists: productList);
  }

  Stream<ProductsScreenState> unSelectProducts() async* {
    List<ProductListModel> productList = [];
    productList.addAll(state.productLists);
    productList.forEach((element) {
      element.isChecked = false;
    });
    yield state.copyWith(productLists: productList, addToCollection: false);
  }

  Stream<ProductsScreenState> addToCollectionProducts(String collectionId) async* {
    List<String> ids = [];
    state.collectionProducts.forEach((element) {
      ids.add(element.id);
    });
    Map<String, dynamic> body = {
      'ids': ids
    };

    dynamic response = await api.addToCollection(token, state.businessId, collectionId, body);
    yield* fetchProducts(state.businessId);
  }

  Stream<ProductsScreenState> selectAllCollections() async* {
    List<CollectionListModel> collectionList = [];
    collectionList.addAll(state.collectionLists);
    collectionList.forEach((element) {
      element.isChecked = true;
    });
    yield state.copyWith(collectionLists: collectionList);
  }

  Stream<ProductsScreenState> unSelectCollections() async* {
    List<CollectionListModel> collectionList = [];
    collectionList.addAll(state.collectionLists);
    collectionList.forEach((element) {
      element.isChecked = false;
    });
    yield state.copyWith(collectionLists: collectionList);
  }

  Stream<ProductsScreenState> getProductDetail(String id) async* {
    yield state.copyWith(
      increaseStock: 0,
      inventory: InventoryModel(),
      updatedInventories: [],
      isLoading: true,
    );
    Map<String, dynamic> body = {
      'operationName': 'getProducts',
      'variables': {
        'id': id,
      },
      'query': 'query getProducts(\$id: String!) {\n  product(id: \$id) {\n    businessUuid\n    images\n    currency\n    id\n    title\n    description\n    onSales\n    price\n    salePrice\n    vatRate\n    sku\n    barcode\n    type\n    active\n    collections {\n      _id\n      name\n      description\n    }\n    categories {\n      id\n      slug\n      title\n    }\n    channelSets {\n      id\n      type\n      name\n    }\n    variants {\n      id\n      images\n      options {\n        name\n        value\n      }\n      description\n      onSales\n      price\n      salePrice\n      sku\n      barcode\n    }\n    shipping {\n      weight\n      width\n      length\n      height\n    }\n  }\n}\n',
    };
    dynamic response = await api.getProducts(token, body);
    ProductsModel model;
    dynamic data = response['data'];
    if (data != null) {
      dynamic getProduct = data['product'];
      if (getProduct != null) {
        model = ProductsModel.toMap(getProduct);
      }
    }
    if (model == null) {
      yield state.copyWith(isLoading: false);
      yield ProductsNotExist(error: 'Product not exist');
    } else {
      yield state.copyWith(productDetail: model, increaseStock: 0, inventory: new InventoryModel());
      if (model.sku != null) {
        if (state.inventories.length == 0) {
          List<InventoryModel> inventories = [];
          dynamic inventoryResponse = await api.getInventories(token, state.businessId);
          if (inventoryResponse != null) {
            if (inventoryResponse is List) {
              inventoryResponse.forEach((element) {
                inventories.add(InventoryModel.toMap(element));
              });
            }
          }
          InventoryModel inventoryModel = inventories.singleWhere((element) => element.sku == model.sku);
          if (inventoryModel != null) {
            yield state.copyWith(inventory: inventoryModel, inventories: inventories);
          } else {
            yield state.copyWith(inventories: inventories);
          }
        } else {
          InventoryModel inventoryModel = state.inventories.singleWhere((element) => element.sku == model.sku);
          if (inventoryModel != null) {
            yield state.copyWith(inventory: inventoryModel);
          }
        }
      }
      yield* getProductCategories();
    }
  }

  Stream<ProductsScreenState> getInventory(String sku) async* {
    dynamic response = await api.getInventory(token, state.businessId, sku);
    if (response is Map) {
      InventoryModel inventoryModel = InventoryModel.toMap(response);
      print(inventoryModel);
      yield state.copyWith(inventory: inventoryModel);
    }
    yield* getProductCategories();
  }

  Stream<ProductsScreenState> getProductCategories() async* {
    Map<String, dynamic> body = {
      'operationName': 'getCategories',
      'variables': {
        'businessUuid': state.businessId,
        'page': 1,
        'perPage': 100,
        'titleChunk': '',
      },
      'query': 'query getCategories(\$businessUuid: String!, \$titleChunk: String, \$page: Int, \$perPage: Int) {\n  getCategories(businessUuid: \$businessUuid, title: \$titleChunk, pageNumber: \$page, paginationLimit: \$perPage) {\n    id\n    slug\n    title\n    businessUuid\n  }\n}\n',
    };
    List<Categories> categories = [];
    dynamic response = await api.getProducts(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data != null) {
        List getCategories = data['getCategories'];
        if (getCategories != null) {
          getCategories.forEach((element) {
            categories.add(Categories.toMap(element));
          });
        }
      }
    }
    yield state.copyWith(categories: categories);
    yield* getTaxes('DE');
  }

  Stream<ProductsScreenState> getTaxes(String country) async* {
    dynamic response = await api.getTaxes(token, country);
    List<Tax> taxes = [];
    if (response != null) {
      if (response is List) {
        response.forEach((element) {
          taxes.add(Tax.toMap(element));
        });
      }
    }
    yield state.copyWith(taxes: taxes);
    yield* getBusinessBillingSubscription(state.businessId);
  }

  Stream<ProductsScreenState> getBusinessBillingSubscription(String businessId) async* {
    dynamic response = await api.getBusinessBillingSubscription(token, state.businessId);
    if (response is Map) {
      if (response['installed'] != null) {
        if (response['installed'] == false) {
          yield* getBillingSubscriptions();
          return;
        }
      }
    }
    yield* getTerminals();
  }

  Stream<ProductsScreenState> getBillingSubscriptions() async* {
    dynamic response = await api.getBillingSubscription(token, state.businessId);
    yield* getTerminals();
  }

  Stream<ProductsScreenState> getTerminals() async* {
    List<Terminal> terminals = [];
    dynamic terminalsObj = await api.getTerminal(state.businessId, token);
    if (terminalsObj != null) {
      terminalsObj.forEach((terminal) {
        terminals.add(Terminal.fromJson(terminal));
      });
    }
    yield state.copyWith(terminals: terminals);
    yield* getShops();
  }

  Stream<ProductsScreenState> getShops() async* {
    List<ShopModel> shops = [];
    dynamic response = await api.getShops(state.businessId, token);
    if (response is List) {
      response.forEach((element) {
        shops.add(ShopModel.fromJson(element));
      });
    }
    yield state.copyWith(shops: shops, isLoading: false);
  }

  Stream<ProductsScreenState> uploadImageToProducts(File file) async* {
    yield state.copyWith(isUploading: true);
    dynamic response = await api.uploadImageToProducts(file, state.businessId, token);
    String blob = '';
    if (response != null) {
      blob = response['blobName'];
    }
    ProductsModel productsModel = state.productDetail;
    if (blob != null) {
      productsModel.images.add(blob);
    }

    yield state.copyWith(isUploading: false, productDetail: productsModel);
  }

  Stream<ProductsScreenState> uploadImageToCollection(File file) async* {
    yield state.copyWith(isUploading: true);
    dynamic response = await api.uploadImageToProducts(file, state.businessId, token);
    String blob = '';
    if (response != null) {
      blob = response['blobName'];
    }
    CollectionModel collectionModel = state.collectionDetail;
    if (blob != null) {
      collectionModel.image = blob;
    }

    yield state.copyWith(isUploading: false, collectionDetail: collectionModel);
  }

  Stream<ProductsScreenState> getCollectionDetail(String collectionId) async* {
    CollectionModel model;
    List<ProductsModel> products = [];
    dynamic response = await api.getCollection(token, state.businessId, collectionId);
    if (response != null) {
      model = CollectionModel.toMap(response);
    }

    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query': '{\n  getProducts(businessUuid: \"${state.businessId}\", paginationLimit: 200, pageNumber: 1, orderBy: \"createdAt\", orderDirection: \"desc\", filterById: [], search: \"\", filters: [{field: \"collections\", fieldType: \"string\", fieldCondition: \"is\", value: \"$collectionId\"}]) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };

    dynamic proRes = await api.getProducts(token, body);
    if (proRes != null) {
      dynamic data = proRes['data'];
      if (data != null) {
        dynamic getProducts = data['getProducts'];
        if (getProducts != null) {
          List productsObj = getProducts['products'];
          if (productsObj != null) {
            productsObj.forEach((element) {
              products.add(ProductsModel.toMap(element));
            });
          }
        }
      }
    }
    if (state.addToCollection) {
      state.productLists.forEach((element) {
        bool isContain = false;
        products.forEach((product) {
          if (product.id == element.productsModel.id) {
            isContain = true;
          }
        });
        if (!isContain) {
          products.add(element.productsModel);
        }
      });
    }
    yield state.copyWith(collectionDetail: model, collectionProducts: products);
    yield* unSelectProducts();
  }


  Stream<ProductsScreenState> updateCollection(CollectionModel model, List<ProductsModel> deleteList) async* {
    String businessId = state.businessId;
    if (model.image == null || model.image == '' ) {
      ProductsModel imageModel = state.collectionProducts.firstWhere((element) => element.images.length > 0);
      if (imageModel != null) {
        model.image = imageModel.images.first;
      }
    }
    print(model.image);
    dynamic response = await api.updateCollection(token, state.businessId, model.toJson(), model.id);
    if (response is Map) {
      CollectionModel collectionModel = CollectionModel.toMap(response);
      print(collectionModel);
    }

    deleteList.forEach((element) async {
      Map bodyObj = element.toDictionary();
      bodyObj['businessUuid'] = businessId;
      bodyObj['collections'] = [];
      Map<String, dynamic> body = {
        'operationName': 'updateProduct',
        'variables': {
          'product': bodyObj,
        },
        'query': 'mutation updateProduct(\$product: ProductUpdateInput!) {\n  updateProduct(product: \$product) {\n    title\n    id\n  }\n}\n'
      };
      dynamic res = await api.getProducts(token, body);
    });
    yield* addToCollectionProducts(model.id);
  }

  Stream<ProductsScreenState> createCollection(CollectionModel model) async* {

    String businessId = state.businessId;
    dynamic response = await api.createCollection(token, state.businessId, model.toJson());
    if (response is Map) {
      CollectionModel collectionModel = CollectionModel.toMap(response);
      print(collectionModel.toJson());
    }
    yield ProductsScreenState(businessId: businessId);
    yield state.copyWith(updateSuccess: true, businessId: businessId);
    yield* fetchProducts(businessId);
  }

  Stream<ProductsScreenState> deleteCollections() async* {

    List<String> list = [];
    List<CollectionListModel> collections = state.collectionLists;
    collections.forEach((element) {
      if (element.isChecked) {
        list.add(element.collectionModel.id);
      }
    });
    Map<String, dynamic> body = {'ids': list};
    dynamic response = await api.deleteCollections(token, state.businessId, body);
    yield* reloadCollections();
  }

  Stream<ProductsScreenState> createCategory(String title) async* {
    yield state.copyWith(isUpdating: true);
    String businessUuid = state.businessId;
    Map<String, dynamic> body = {
      'operationName': 'createCategory',
      'variables': {
        'businessUuid': businessUuid,
        'title': title,
      },
      'query': 'mutation createCategory(\$businessUuid: String!, \$title: String!) {\n  createCategory(category: {businessUuid: \$businessUuid, title: \$title}) {\n    id\n    businessUuid\n    title\n  slug\n  }\n}\n'
    };
    dynamic response = await api.createCategory(token, body);
    if (response is Map) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic categoryObj = data['data'];
        if (categoryObj != null) {
          Categories categories = Categories.toMap(categoryObj);
          List<Categories>categoriesList = state.categories;
          categoriesList.add(categories);
          yield state.copyWith(categories: categoriesList, isUpdating: false);
          yield CategoriesCreate();
        }
      }
    } else {

    }
  }
}