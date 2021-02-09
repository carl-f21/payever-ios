import 'package:flutter/material.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/views/add_variant_screen.dart';

class VariantsScreenState {
  final bool isLoading;
  final bool isUploading;
  final String businessId;
  final Variants variants;
  final InventoryModel inventory;
  final num increaseStock;
  final List<TagVariantItem> children;
  final Map<String, Color> colorsMap;

  VariantsScreenState({
    this.isLoading = false,
    this.isUploading = false,
    this.businessId,
    this.variants,
    this.inventory,
    this.increaseStock = 0,
    this.children = const [],
    this.colorsMap = const {
      'Blue': Color(0xff0084ff),
      'Green': Color(0xff81d552),
      'Yellow': Color(0xffeebd40),
      'Pink': Color(0xffde68a5),
      'Brown': Color(0xff594139),
      'Black': Color(0xff000000),
      'White': Color(0xffffffff),
      'Grey': Color(0xff434243),
    },
  });

  List<Object> get props => [
    this.isLoading,
    this.variants,
    this.isUploading,
    this.businessId,
    this.inventory,
    this.increaseStock,
    this.children,
    this.colorsMap,
  ];

  VariantsScreenState copyWith({
    bool isLoading,
    bool isUploading,
    String businessId,
    Variants variants,
    InventoryModel inventory,
    num increaseStock,
    List<TagVariantItem> children,
    Map<String, Color> colorsMap,
  }) {
    return VariantsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      businessId: businessId ?? this.businessId,
      variants: variants ?? this.variants,
      inventory: inventory ?? this.inventory,
      increaseStock: increaseStock ?? this.increaseStock,
      children: children ?? this.children,
      colorsMap: colorsMap ?? this.colorsMap,
    );
  }
}

class VariantsScreenStateSuccess extends VariantsScreenState {}

class VariantsScreenStateFailure extends VariantsScreenState {
  final String error;

  VariantsScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'VariantsScreenStateFailure { error $error }';
  }
}
