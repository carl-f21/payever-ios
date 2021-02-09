import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:payever/shop/models/models.dart';

abstract class ShopScreenEvent extends Equatable {
  ShopScreenEvent();

  @override
  List<Object> get props => [];
}

class ShopScreenInitEvent extends ShopScreenEvent {
  final String currentBusinessId;

  ShopScreenInitEvent({
    this.currentBusinessId,
  });

  @override
  List<Object> get props => [
    this.currentBusinessId,
  ];
}

class InstallThemeEvent extends ShopScreenEvent {
  final String businessId;
  final String shopId;
  final String themeId;

  InstallThemeEvent({
    this.businessId,
    this.shopId,
    this.themeId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.shopId,
    this.themeId,
  ];
}

class DuplicateThemeEvent extends ShopScreenEvent {
  final String businessId;
  final String shopId;
  final String themeId;

  DuplicateThemeEvent({
    this.businessId,
    this.shopId,
    this.themeId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.shopId,
    this.themeId,
  ];
}

class DeleteThemeEvent extends ShopScreenEvent {
  final String businessId;
  final String shopId;
  final String themeId;

  DeleteThemeEvent({
    this.businessId,
    this.shopId,
    this.themeId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.shopId,
    this.themeId,
  ];
}

class GetActiveThemeEvent extends ShopScreenEvent {
  final String businessId;
  final String shopId;

  GetActiveThemeEvent({
    this.businessId,
    this.shopId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.shopId,
  ];
}


class UploadShopImage extends ShopScreenEvent{
  final File file;
  final String businessId;
  UploadShopImage({this.file, this.businessId});

  @override
  List<Object> get props => [
    this.file,
    this.businessId,
  ];
}

class CreateShopEvent extends ShopScreenEvent {
  final String name;
  final String logo;
  final String businessId;

  CreateShopEvent({
    this.name,
    this.logo,
    this.businessId,
  });
  @override
  List<Object> get props => [
    this.name,
    this.logo,
    this.businessId,
  ];
}

class SetDefaultShop extends ShopScreenEvent {
  final String businessId;
  final String shopId;

  SetDefaultShop({
    this.shopId,
    this.businessId,
  });
  @override
  List<Object> get props => [
    this.shopId,
    this.businessId,
  ];
}

class UpdateShopSettings extends ShopScreenEvent {
  final AccessConfig config;
  final String businessId;
  final String shopId;

  UpdateShopSettings({
    this.config,
    this.businessId,
    this.shopId,
  });

  @override
  List<Object> get props => [
    this.config,
    this.businessId,
    this.shopId,
  ];
}

class ShopCategorySelected extends ShopScreenEvent {
  final String category;
  final List<String> subCategories;

  ShopCategorySelected({
    this.category,
    this.subCategories,
  });

  @override
  List<Object> get props => [
    this.category,
    this.subCategories,
  ];
}

class SelectThemeEvent extends ShopScreenEvent {
  final ThemeListModel model;

  SelectThemeEvent({this.model});

  @override
  List<Object> get props => [
    this.model,
  ];
}

class SelectAllThemesEvent extends ShopScreenEvent {
  final bool isSelect;
  SelectAllThemesEvent({this.isSelect});
  @override
  List<Object> get props => [
    this.isSelect,
  ];
}