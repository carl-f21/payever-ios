
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/settings/models/models.dart';

abstract class SettingScreenEvent extends Equatable {
  SettingScreenEvent();

  @override
  List<Object> get props => [];
}

class SettingScreenInitEvent extends SettingScreenEvent {
  final String business;
  final User user;
  SettingScreenInitEvent({
    this.business,
    this.user,
  });

  @override
  List<Object> get props => [
    this.business,
    this.user,
  ];
}

class FetchWallpaperEvent extends SettingScreenEvent {}

class UpdateWallpaperEvent extends SettingScreenEvent {
  final Wallpaper wallpaper;
  UpdateWallpaperEvent({this.wallpaper});
  @override
  List<Object> get props => [wallpaper];
}

class WallpaperCategorySelected extends SettingScreenEvent {
  final String category;
  final List<String> subCategories;

  WallpaperCategorySelected({
    this.category,
    this.subCategories,
  });

  @override
  List<Object> get props => [
    this.category,
    this.subCategories,
  ];
}

class UploadWallpaperImage extends SettingScreenEvent{

  final File file;
  UploadWallpaperImage({this.file,});

  @override
  List<Object> get props => [
    this.file,
  ];
}

class BusinessUpdateEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  BusinessUpdateEvent(this.body);

  @override
  List<Object> get props => [body];
}

class UploadBusinessImage extends SettingScreenEvent {

  final File file;
  UploadBusinessImage({this.file,});

  @override
  List<Object> get props => [
    this.file,
  ];
}

class GetBusinessProductsEvent extends SettingScreenEvent {}

class GetEmployeesEvent extends SettingScreenEvent {}

class CheckEmployeeItemEvent extends SettingScreenEvent {
  final EmployeeListModel model;

  CheckEmployeeItemEvent({this.model});

  @override
  List<Object> get props => [
    this.model,
  ];
}

class SelectAllEmployeesEvent extends SettingScreenEvent {
  final bool isSelect;

  SelectAllEmployeesEvent({this.isSelect});
  @override
  List<Object> get props => [
    this.isSelect,
  ];
}

class GetGroupEvent extends SettingScreenEvent {}

class CheckGroupItemEvent extends SettingScreenEvent {
  final GroupListModel model;

  CheckGroupItemEvent({this.model});

  @override
  List<Object> get props => [
    this.model,
  ];
}

class SelectAllGroupEvent extends SettingScreenEvent {
  final bool isSelect;

  SelectAllGroupEvent({this.isSelect});
  @override
  List<Object> get props => [
    this.isSelect,
  ];
}

class CreateEmployeeEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  final String email;

  CreateEmployeeEvent({this.body, this.email});
}

class UpdateEmployeeEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  final String employeeId;
  final List<String> addGroups;
  final List<String> deleteGroups;

  UpdateEmployeeEvent({this.employeeId, this.body, this.addGroups = const [], this.deleteGroups = const []});
}
class ClearEmailInvalidEvent extends SettingScreenEvent {}

class DeleteEmployeeEvent extends SettingScreenEvent {}

class CreateGroupEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  final String groupName;

  CreateGroupEvent({this.body, this.groupName});
}

class UpdateGroupEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  final String groupId;
  final String groupName;
  final List<String> deleteEmployees;
  final List<String> addEmployees;

  UpdateGroupEvent({this.groupId, this.body, this.groupName, this.addEmployees = const [], this.deleteEmployees = const []});
}

class DeleteGroupEvent extends SettingScreenEvent {}

class GetGroupDetailEvent extends SettingScreenEvent {
  final Group group;
  GetGroupDetailEvent({this.group});
}

class SelectEmployeeToGroupEvent extends SettingScreenEvent {
  final Group group;
  SelectEmployeeToGroupEvent({this.group});
}

class AddEmployeeToGroupEvent extends SettingScreenEvent {
  final List<Employee> employees;
  AddEmployeeToGroupEvent({this.employees = const []});
}

class CancelSelectEmployeeEvent extends SettingScreenEvent {}

class UpdateEmployeeSearchText extends SettingScreenEvent {
  final String searchText;

  UpdateEmployeeSearchText({
    this.searchText,
  });

  List<Object> get props => [
    this.searchText,
  ];
}

class UpdateEmployeeFilterTypeEvent extends SettingScreenEvent {
  final List<FilterItem> filterTypes;

  UpdateEmployeeFilterTypeEvent({
    this.filterTypes,
  });

  List<Object> get props => [
    this.filterTypes,
  ];
}

class UpdateGroupSearchText extends SettingScreenEvent {
  final String searchText;

  UpdateGroupSearchText({
    this.searchText,
  });

  List<Object> get props => [
    this.searchText,
  ];
}

class UpdateGroupFilterTypeEvent extends SettingScreenEvent {
  final List<FilterItem> filterTypes;

  UpdateGroupFilterTypeEvent({
    this.filterTypes,
  });

  List<Object> get props => [
    this.filterTypes,
  ];
}

class GetLegalDocumentEvent extends SettingScreenEvent{
  final String type;
  GetLegalDocumentEvent({this.type});
}

class UpdateLegalDocumentEvent extends SettingScreenEvent{
  final String type;
  final Map<String, dynamic> content;
  UpdateLegalDocumentEvent({this.content, this.type});
}

class GetCurrentUserEvent extends SettingScreenEvent {}

class UpdateCurrentUserEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;

  UpdateCurrentUserEvent({this.body});
}

class UploadUserPhotoEvent extends SettingScreenEvent {
  final File image;
  UploadUserPhotoEvent({this.image});
}

class GetAuthUserEvent extends SettingScreenEvent {}

class UpdateAuthUserEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;

  UpdateAuthUserEvent({this.body});
}

class UpdatePasswordEvent extends SettingScreenEvent {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordEvent({this.oldPassword, this.newPassword});
}

class DeleteBusinessEvent extends SettingScreenEvent {}