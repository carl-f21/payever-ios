import 'dart:core';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/views/add_variant_screen.dart';

import 'variants.dart';

class VariantsScreenBloc extends Bloc<VariantsScreenEvent, VariantsScreenState> {
  final ProductsScreenBloc productsScreenBloc;
  VariantsScreenBloc({this.productsScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  VariantsScreenState get initialState => VariantsScreenState();

  @override
  Stream<VariantsScreenState> mapEventToState(VariantsScreenEvent event) async* {
    if (event is VariantsScreenInitEvent) {
      yield state.copyWith(variants: event.variants ?? new Variants(), businessId: productsScreenBloc.state.businessId);
      if (event.variants != null) {
        InventoryModel inventoryModel = productsScreenBloc.state.inventories.singleWhere((element) => element.sku == event.variants.sku);
        if (inventoryModel != null) {
          yield state.copyWith(inventory: inventoryModel);
        }
      } else {
        TagVariantItem item = TagVariantItem(name: 'Default', type: 'string', values: [], key: 'tag0');
        List<TagVariantItem> children = [];
        children.add(item);
        yield state.copyWith(children: children);
      }
    } else if (event is UpdateVariantDetail) {
      yield state.copyWith(variants: event.variants, inventory: event.inventoryModel, increaseStock: event.increaseStock,);
    } else if (event is UploadVariantImageToProduct) {
      yield* uploadVariantImageToProduct(event.file);
    } else if (event is CreateVariantsEvent) {
      yield* getAllCombinations();
    } else if (event is SaveVariantsEvent) {
      ProductsModel productsModel = productsScreenBloc.state.productDetail;
      List<Variants> variants = productsModel.variants;
      int index = variants.indexWhere((element) => element.sku == state.variants.sku);
      variants[index] = state.variants;
      productsModel.variants = variants;

      List<InventoryModel> updated = [];
      updated.addAll(productsScreenBloc.state.updatedInventories);
      InventoryModel inventoryModel = state.inventory;
      List<InventoryModel> contains = updated.where((element) => element.sku == state.inventory.sku).toList();
      inventoryModel.stock = inventoryModel.stock + state.increaseStock;
      if (contains.length == 0) {
        updated.add(inventoryModel);
      }
      productsScreenBloc.add(UpdateProductDetail(productsModel: productsModel, inventories: updated));
      yield VariantsScreenStateSuccess();
    } else if (event is UpdateTagVariantItems) {
      yield state.copyWith(children: event.items);
    }
  }

  Stream<VariantsScreenState> uploadVariantImageToProduct(File file) async* {
    yield state.copyWith(isUploading: true);
    dynamic response = await api.uploadImageToProducts(file, state.businessId, token);
    String blob = '';
    if (response is Map) {
      blob = response['blobName'];
    }
    Variants variants = state.variants;
    if (blob != '') {
      variants.images.add(blob);
    }

    yield state.copyWith(isUploading: false, variants: variants);
  }

  Stream<VariantsScreenState> getAllCombinations() async* {
    List<TagVariantItem> items = state.children;
    List<TempContainer<VariantOption>> containers = [];
    items.forEach((item) {
      List<VariantOption> options = [];
      TempContainer<VariantOption> container = new TempContainer<VariantOption>();
      item.values.forEach((value) {
        options.add(VariantOption(name: item.name, value: value));
      });
      container.setItems(options);
      containers.add(container);
    });
    List<List<VariantOption>> combinations = getCombination(0, containers);
    ProductsModel productsModel = productsScreenBloc.state.productDetail;
    List<Variants> variants = productsModel.variants;
    combinations.forEach((element) {
      Variants variant = Variants();
      variant.options = element;
      variant.sku = '${productsModel.sku}-${variants.length + 1}';
      variants.add(variant);
    });

    productsModel.variants = variants;
    productsScreenBloc.add(UpdateProductDetail(productsModel: productsModel, inventoryModel: productsScreenBloc.state.inventory));
    yield VariantsScreenStateSuccess();
  }

  List<List<VariantOption>> getCombination(int currentIndex, List<TempContainer<VariantOption>> containers) {
    if (currentIndex == containers.length) {
      // Skip the items for the last container
      List<List<VariantOption>> combinations = new List<List<VariantOption>>();
      combinations.add(new List<VariantOption>());
      return combinations;
    }
    List<List<VariantOption>> combinations = new List<List<VariantOption>>();
    TempContainer<VariantOption> container = containers[currentIndex];
    List<VariantOption> containerItemList = container.getItems();
    // Get combination from next index
    List<List<VariantOption>> suffixList = getCombination(currentIndex + 1, containers);
    int size = containerItemList.length;
    for (int ii = 0; ii < size; ii++) {
      VariantOption containerItem = containerItemList[ii];
      if (suffixList != null) {
        for (List<VariantOption> suffix in suffixList) {
          List<VariantOption> nextCombination = new List<VariantOption>();
          nextCombination.add(containerItem);
          nextCombination.addAll(suffix);
          combinations.add(nextCombination);
        }
      }
    }
    return combinations;
  }

}

class TempContainer<VariantOption> {
  List<VariantOption> items;
  void setItems(List<VariantOption> items) {
    this.items = items;
  }

  List<VariantOption> getItems() {
    return items;
  }
}
