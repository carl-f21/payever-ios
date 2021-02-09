import 'package:flutter/cupertino.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/shop/models/models.dart';

class ShopScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploading;
  final bool isDuplicate;
  final Business activeBusiness;
  final List<TemplateModel> templates;
  final List<ThemeModel> themes;
  final List<ThemeListModel> themeListModels;
  final List<ThemeModel> myThemes;
  final List<ThemeListModel> myThemeListModels;
  final List<ShopDetailModel> shops;
  final ShopDetailModel activeShop;
  final ThemeModel activeTheme;
  final String blobName;
  final String installThemeId;
  final String selectedCategory;
  final List<String>subCategories;

  ShopScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploading = false,
    this.isDuplicate = false,
    this.activeBusiness,
    this.shops = const [],
    this.templates = const [],
    this.themes = const [],
    this.myThemes = const [],
    this.themeListModels = const [],
    this.myThemeListModels = const [],
    this.activeShop,
    this.activeTheme,
    this.blobName,
    this.installThemeId = '',
    this.selectedCategory = 'All',
    this.subCategories,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isUploading,
    this.isDuplicate,
    this.templates,
    this.activeBusiness,
    this.shops,
    this.themes,
    this.myThemes,
    this.themeListModels,
    this.myThemeListModels,
    this.activeShop,
    this.activeShop,
    this.blobName,
    this.installThemeId,
    this.selectedCategory,
    this.subCategories,
  ];

  ShopScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isUploading,
    bool isDuplicate,
    Business activeBusiness,
    List<TemplateModel> templates,
    List<ThemeModel> themes,
    List<ThemeModel> myThemes,
    List<ThemeListModel> themeListModels,
    List<ThemeListModel> myThemeListModels,
    List<ShopDetailModel> shops,
    ShopDetailModel activeShop,
    ThemeModel activeTheme,
    String blobName,
    String installThemeId,
    String selectedCategory,
    List<String>subCategories,
  }) {
    return ShopScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploading: isUploading ?? this.isUploading,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      activeBusiness: activeBusiness ?? this.activeBusiness,
      templates: templates ?? this.templates,
      shops: shops ?? this.shops,
      themes: themes ?? this.themes,
      myThemes: myThemes ?? this.myThemes,
      themeListModels: themeListModels ?? this.themeListModels,
      myThemeListModels: myThemeListModels ?? this.myThemeListModels,
      activeShop: activeShop ?? this.activeShop,
      activeTheme: activeTheme ?? this.activeTheme,
      blobName: blobName ?? this.blobName,
      installThemeId: installThemeId ?? this.installThemeId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      subCategories: subCategories ?? this.subCategories,
    );
  }
}

class ShopScreenStateSuccess extends ShopScreenState {}

class ShopScreenStateFailure extends ShopScreenState {
  final String error;

  ShopScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ShopScreenStateFailure { error $error }';
  }
}

class ShopScreenStateThemeFailure extends ShopScreenState {
  final String error;

  ShopScreenStateThemeFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ShopScreenStateFailure { error $error }';
  }
}