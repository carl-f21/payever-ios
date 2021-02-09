import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/settings/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting.dart';

class SettingScreenBloc extends Bloc<SettingScreenEvent, SettingScreenState> {

  final DashboardScreenBloc dashboardScreenBloc;
  final PersonalDashboardScreenBloc personalDashboardScreenBloc;
  final GlobalStateModel globalStateModel;
  final isBusinessMode;

  SettingScreenBloc({this.dashboardScreenBloc, this.personalDashboardScreenBloc, this.globalStateModel, this.isBusinessMode = true});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  SettingScreenState get initialState => SettingScreenState();

  @override
  Stream<SettingScreenState> mapEventToState(
      SettingScreenEvent event) async* {
    if (event is SettingScreenInitEvent) {
      yield state.copyWith(
        business: event.business,
        user: event.user
      );
      yield* getBusiness(event.business);
    } else if (event is FetchWallpaperEvent) {
      yield* fetchWallpapers();
    } else if (event is UpdateWallpaperEvent) {
      yield* updateWallpaper(event.wallpaper);
    } else if (event is WallpaperCategorySelected) {
      yield state.copyWith(
          selectedCategory: event.category, subCategories: event.subCategories);
    } else if (event is UploadWallpaperImage) {
      yield* uploadWallpaperImage(event.file);
    } else if (event is BusinessUpdateEvent) {
      yield* uploadBusiness(event.body);
    } else if (event is UploadBusinessImage) {
      yield* uploadBusinessImage(event.file);
    } else if (event is GetBusinessProductsEvent) {
      yield* getBusinessProducts();
    } else if (event is GetEmployeesEvent) {
      yield state.copyWith(
        searchEmployeeText: '',
        filterEmployeeTypes: [],
        searchGroupText: '',
        filterGroupTypes: [],
      );
      yield* getEmployee();
    } else if (event is CheckEmployeeItemEvent) {
      yield* selectEmployee(event.model);
    } else if(event is SelectAllEmployeesEvent) {
      yield* selectAllEmployees(event.isSelect);
    } else if (event is GetGroupEvent) {
      yield state.copyWith(
        searchEmployeeText: '',
        filterEmployeeTypes: [],
        searchGroupText: '',
        filterGroupTypes: [],
      );
      yield* getGroup();
    } else if (event is CheckGroupItemEvent) {
      yield* selectGroup(event.model);
    } else if(event is SelectAllGroupEvent) {
      yield* selectAllGroup(event.isSelect);
    } else if (event is CreateEmployeeEvent) {
      yield* createEmployee(event.body, event.email);
    } else if (event is UpdateEmployeeEvent) {
      yield* updateEmployee(event.employeeId, event.body, event.addGroups, event.deleteGroups);
    } else if (event is ClearEmailInvalidEvent) {
      yield state.copyWith(emailInvalid: false);
    } else if (event is DeleteEmployeeEvent) {
      yield* deleteEmployees();
    } else if (event is CreateGroupEvent) {
      yield* createGroup(event.body, event.groupName);
    } else if (event is UpdateGroupEvent) {
      yield* updateGroup(event.groupId, event.body, event.groupName, event.addEmployees, event.deleteEmployees);
    } else if (event is DeleteGroupEvent) {
      yield* deleteGroups();
    } else if (event is GetGroupDetailEvent) {
      yield* getGroupDetail(event.group);
    } else if (event is SelectEmployeeToGroupEvent) {
      yield state.copyWith(isSelectingEmployee: true);
    } else if (event is AddEmployeeToGroupEvent) {
      Group groupDetail = state.groupDetail;
      groupDetail.employees = event.employees;
      yield state.copyWith(groupDetail: groupDetail);
      yield* selectAllEmployees(false);
    } else if (event is CancelSelectEmployeeEvent) {
      yield state.copyWith(isSelectingEmployee: false);
    } else if (event is UpdateEmployeeSearchText) {
      yield state.copyWith(searchEmployeeText: event.searchText, isSearching: true);
      yield* getEmployeeWithFilter(state.searchEmployeeText, state.filterEmployeeTypes);
    } else if (event is UpdateEmployeeFilterTypeEvent) {
      yield state.copyWith(filterEmployeeTypes: event.filterTypes, isSearching: true);
      yield* getEmployeeWithFilter(state.searchEmployeeText, state.filterEmployeeTypes);
    } else if (event is UpdateGroupSearchText) {
      yield state.copyWith(searchGroupText: event.searchText, isSearching: true);
      yield* getGroupWithFilter(state.searchGroupText, state.filterGroupTypes);
    } else if (event is UpdateGroupFilterTypeEvent) {
      yield state.copyWith(filterGroupTypes: event.filterTypes, isSearching: true);
      yield* getGroupWithFilter(state.searchGroupText, state.filterGroupTypes);
    } else if (event is GetLegalDocumentEvent) {
      yield* getLegalDocument(event.type);
    } else if (event is UpdateLegalDocumentEvent) {
      yield* updateLegalDocument(event.content, event.type);
    } else if (event is GetCurrentUserEvent) {
      yield* getUser();
    } else if (event is UpdateCurrentUserEvent) {
      yield* updateUser(event.body);
    } else if (event is UploadUserPhotoEvent) {
      yield* uploadUserPhoto(event.image);
    } else if (event is GetAuthUserEvent) {
      yield* getAuthUser();
    } else if (event is UpdateAuthUserEvent) {
      yield* updateAuthUser(event.body);
    } else if (event is UpdatePasswordEvent) {
      yield* updatePassword(event.newPassword, event.oldPassword);
    } else if (event is DeleteBusinessEvent) {
      yield* deleteBusiness();
    }
  }

  Stream<SettingScreenState> getBusiness(String id) async* {
    if (!isBusinessMode) return;
    yield state.copyWith(isLoading: true);

    dynamic response = await api.getBusiness(token, id);

    Business business = Business.map(response);
    dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(business: business));
    globalStateModel.setCurrentBusiness(business, notify: true);
    yield state.copyWith(isLoading: false);
  }

  Stream<SettingScreenState> uploadBusinessImage(File file) async* {
    yield state.copyWith(blobName: '', isUpdatingBusinessImg: true);
    dynamic response = await api.postImageToBusiness(file, state.business, GlobalUtils.activeToken.accessToken);
    String blobName = response['blobName'];
    yield state.copyWith(blobName: blobName, isUpdatingBusinessImg: false);
  }

  Stream<SettingScreenState> fetchConnectInstallations(String business,
      {bool isLoading = false}) async* {
    yield state.copyWith(isLoading: isLoading);
  }

  Stream<SettingScreenState> fetchWallpapers() async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isLoading: true);

    List<WallpaperCategory> wallpaperCategories = state.wallpaperCategories;
    List<Wallpaper>wallpapers = state.wallpapers;
    List<Wallpaper>myWallpapers = state.myWallpapers;

    if (wallpapers == null) {
      wallpaperCategories = [];
      wallpapers = [];
      myWallpapers = [];

      dynamic objects = await api.getProductWallpapers(token, state.business);
      if (objects != null && !(objects is DioError)) {
        objects.forEach((element) {
          wallpaperCategories.add(WallpaperCategory.fromMap(element));
        });
        // All Wallpapers
        wallpaperCategories.forEach((wallpaperCategory) {
          wallpaperCategory.industries.forEach((industry) {
            industry.wallpapers.forEach((wallpaper) {
              wallpapers.add(wallpaper);
            });
          });
        });
        // My Wallpapers
        if (isBusinessMode) {
          dynamic objects1 = await api.getMyWallpaper(token, state.business,);
          MyWallpaper myWallpaper = MyWallpaper.fromMap(objects1);
          myWallpaper.myWallpapers.forEach((wallpaper) {
            myWallpapers.add(wallpaper);
          });
        } else {
          MyWallpaper personalWallpaper;
          dynamic wallPaperObj = await api.getWallpaperPersonal(token);
          if (wallPaperObj is Map) {
            personalWallpaper = MyWallpaper.fromMap(wallPaperObj);
            myWallpapers = personalWallpaper.myWallpapers;
            dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(personalWallpaper: personalWallpaper));
          }
        }
      }
    }

    yield state.copyWith(isLoading: false,
        wallpaperCategories: wallpaperCategories,
        wallpapers: wallpapers,
        myWallpapers: myWallpapers);
  }

  Stream<SettingScreenState> updateWallpaper(Wallpaper wallpaper) async* {
    String token = GlobalUtils.activeToken.accessToken;
    Map<String, dynamic>body = wallpaper.toDictionary();
    yield state.copyWith(updatingWallpaper: body[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER_WALLPAPER]);

    dynamic object = await api.updateWallpaper(token, state.business, body, isBusinessMode);
    String curWall = Env.storage + '/wallpapers/' + body[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER_WALLPAPER];
    if (object != null && !(object is DioError)) {
      if (isBusinessMode) {
        dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(curWall: curWall));
        globalStateModel.setCurrentWallpaper(curWall, notify: true);
      } else {
        MyWallpaper myWallpaper = dashboardScreenBloc.state.personalWallpaper;
        myWallpaper.currentWallpaper = wallpaper;
        dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(personalWallpaper: myWallpaper));
        personalDashboardScreenBloc.add(UpdatePersonalWallpaperEvent(personalWallpaper: myWallpaper, curWall: curWall));
      }
      print('Update Wallpaper Success!');
    } else {
      print('Update Wallpaper failed!');
    }

    yield state.copyWith(updatingWallpaper: '');
  }

  Stream<SettingScreenState> uploadWallpaperImage(File file) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.postImageToWallpaper(file, state.business, GlobalUtils.activeToken.accessToken);
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else {
      String blobName = response['blobName'];
      await api.addNewWallpaper(token, state.business, 'default', blobName, isBusinessMode);

      List<Wallpaper>myWallpapers = state.myWallpapers;
      if (myWallpapers == null) myWallpapers = [];
      Wallpaper wallpaper = Wallpaper();

      wallpaper.theme = 'default';
      wallpaper.wallpaper = blobName;
      wallpaper.industry = 'Own';

      myWallpapers.add(wallpaper);

      yield state.copyWith(myWallpapers: myWallpapers, isUpdating: false);
    }

  }

  Stream<SettingScreenState> uploadBusiness(Map body) async* {
    yield state.copyWith(isUpdating: true);
    print(body);
    dynamic response = await api.patchUpdateBusiness(token, state.business, body);
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else if (response is Map){
      dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(business: Business.map(response)));
      globalStateModel.setCurrentBusiness(Business.map(response),
          notify: true);
      yield state.copyWith(isUpdating: false);
      yield SettingScreenUpdateSuccess(
        business: state.business,
      );
    } else {
      yield SettingScreenStateFailure(error: 'Update Business name failed');
      yield state.copyWith(isUpdating: false);
    }
  }

  Stream<SettingScreenState> getBusinessProducts() async* {
    List<BusinessProduct> businessProducts = [];
    dynamic response = await api.getBusinessProducts(token);

    if (response is List) {
      response.forEach((element) {
        businessProducts.add(BusinessProduct.fromMap(element));
      });
    }
    yield state.copyWith(businessProducts: businessProducts);
  }

  Stream<SettingScreenState> getEmployee() async* {
    List<Employee>employees = [];
    List<EmployeeListModel> employeeListModels = [];

    if (state.employees == null || state.employees.isEmpty) {
      yield state.copyWith(isLoading: true);
    }
    dynamic response = await api.getEmployees(token, state.business, {'limit' : '50', 'page': '1'});
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else if (response is Map){
      dynamic data = response['data'];
      if (data is List) {
        data.forEach((element) {
          employees.add(Employee.fromMap(element));
          employeeListModels.add(EmployeeListModel(employee: Employee.fromMap(element), isChecked: false));
        });
      }
      yield state.copyWith(isLoading: false, employees: employees, employeeListModels: employeeListModels);
    } else {
      yield SettingScreenStateFailure(error: 'Get Employee failed');
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<SettingScreenState> getEmployeeWithFilter(String searchText, List<FilterItem> filterItems) async* {
    List<Employee>employees = [];
    List<EmployeeListModel> employeeListModels = [];

    Map<String, String> query = {};
    query['limit'] = '50';
    query['page'] = '1';
    if (searchText != '') {
      query['search'] = searchText;
    }
    if (filterItems.length > 0) {
      filterItems.forEach((element) {
        query[_getFilterKeyString(element.type)] = _getFilterValueString(element.condition, element.value);
      });
    }
    dynamic response = await api.getEmployees(token, state.business, query);
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else if (response is Map){
      dynamic data = response['data'];
      if (data is List) {
        data.forEach((element) {
          employees.add(Employee.fromMap(element));
          employeeListModels.add(EmployeeListModel(employee: Employee.fromMap(element), isChecked: false));
        });
      }
      yield state.copyWith(isSearching: false, employees: employees, employeeListModels: employeeListModels);
    } else {
      yield SettingScreenStateFailure(error: 'Get Employee failed');
      yield state.copyWith(isSearching: false);
    }
  }

  Stream<SettingScreenState> selectEmployee(EmployeeListModel model) async* {
    List<EmployeeListModel> employeeListModels = [];
    employeeListModels.addAll(state.employeeListModels);
    int index = employeeListModels.indexOf(model);
    employeeListModels[index].isChecked = !model.isChecked;
    yield state.copyWith(employeeListModels: employeeListModels);
  }

  Stream<SettingScreenState> selectAllEmployees(bool isSelect) async* {
    List<EmployeeListModel> employeeListModels = [];
    employeeListModels.addAll(state.employeeListModels);
    employeeListModels.forEach((element) {
      element.isChecked = isSelect;
    });
    yield state.copyWith(employeeListModels: employeeListModels);
  }

  Stream<SettingScreenState> getGroup() async* {
    List<Group> groups = [];
    List<GroupListModel> groupList = [];
    if (state.employeeGroups == null || state.employeeGroups.isEmpty) {
      yield state.copyWith(isLoading: true);
    }
    dynamic response = await api.getGroups(token, state.business, {'limit' : '50', 'page': '1'});
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else if (response is Map){
      dynamic data = response['data'];
      if (data is List) {
        data.forEach((element) {
          groups.add(Group.fromMap(element));
          groupList.add(GroupListModel(group: Group.fromMap(element), isChecked: false));
        });
      }
      yield state.copyWith(isLoading: false, employeeGroups: groups, groupList: groupList);
    } else {
      yield SettingScreenStateFailure(error: 'Get Group failed');
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<SettingScreenState> getGroupWithFilter(String searchText, List<FilterItem> filterItems) async* {
    List<Group> groups = [];
    List<GroupListModel> groupList = [];
    Map<String, String> query = {};
    query['limit'] = '50';
    query['page'] = '1';
    if (searchText != '') {
      query['search'] = searchText;
    }
    if (filterItems.length > 0) {
      filterItems.forEach((element) {
        query['filter\[name\]'] = _getFilterValueString(element.condition, element.value);
      });
    }
    print(query);
    dynamic response = await api.getGroups(token, state.business, query);
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else if (response is Map){
      dynamic data = response['data'];
      if (data is List) {
        data.forEach((element) {
          groups.add(Group.fromMap(element));
          groupList.add(GroupListModel(group: Group.fromMap(element), isChecked: false));
        });
      }
      yield state.copyWith(isSearching: false, employeeGroups: groups, groupList: groupList);
    } else {
      yield SettingScreenStateFailure(error: 'Get Group failed');
      yield state.copyWith(isSearching: false);
    }
  }

  Stream<SettingScreenState> selectGroup(GroupListModel model) async* {
    List<GroupListModel> groupListModels = [];
    groupListModels.addAll(state.groupList);
    int index = groupListModels.indexOf(model);
    groupListModels[index].isChecked = !model.isChecked;
    yield state.copyWith(groupList: groupListModels);
  }

  Stream<SettingScreenState> selectAllGroup(bool isSelect) async* {
    List<GroupListModel> groupListModels = [];
    groupListModels.addAll(state.groupList);
    groupListModels.forEach((element) {
      element.isChecked = isSelect;
    });
    yield state.copyWith(groupList: groupListModels);
  }

  Stream<SettingScreenState> createEmployee( Map<String, dynamic> body, String email,) async* {
    yield state.copyWith(isUpdating: true, emailInvalid: false);
    dynamic emailCheck = await api.getEmailCount(token, state.business, email);
    if (emailCheck is num) {
      if (emailCheck == 0) {
        dynamic response = await api.createEmployee(token, state.business, body);
        yield state.copyWith(isUpdating: false, emailInvalid: false);
        yield SettingScreenUpdateSuccess(business: state.business);
      } else {
        yield state.copyWith(isUpdating: false, emailInvalid: true);
      }
    } else {
      yield state.copyWith(isUpdating: false, emailInvalid: true);
    }
  }

  Stream<SettingScreenState> updateEmployee(String employeeId, Map<String, dynamic> body, List<String> added, List<String> deleted) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.updateEmployee(token, state.business, employeeId, body);
    if (added.length > 0) {
      for(int i = 0; i < added.length; i++) {
        yield* addEmployeeToGroup([employeeId], added[i]);
      }
    }
    if (deleted.length > 0) {
      for(int i = 0; i < deleted.length; i++) {
        yield* deleteEmployeeFromGroup([employeeId], deleted[i]);
      }
    }

    yield state.copyWith(isUpdating: false);
    yield SettingScreenUpdateSuccess(business: state.business);
  }

  Stream<SettingScreenState> deleteEmployees() async* {
    yield state.copyWith(isLoading: true);
    List<EmployeeListModel> employees = state.employeeListModels;
    List<EmployeeListModel> selected = employees.where((element) => element.isChecked).toList();
    if (selected.length > 0) {
      for(int i = 0; i < selected.length; i++) {
        await api.deleteEmployee(token, state.business, selected[i].employee.id);
      }
    }

    yield state.copyWith(isLoading: false);
    add(GetEmployeesEvent());
  }

  Stream<SettingScreenState> createGroup( Map<String, dynamic> body, String groupName) async* {
    yield state.copyWith(isUpdating: true, emailInvalid: false);
    dynamic nameCheck = await api.getGroupNameCount(token, state.business, groupName);
    if (nameCheck is num) {
      if (nameCheck == 0) {
        dynamic response = await api.createGroup(token, state.business, body);
        yield state.copyWith(isUpdating: false, emailInvalid: false);
        yield SettingScreenUpdateSuccess(business: state.business);
      } else {
        yield state.copyWith(isUpdating: false, emailInvalid: true);
      }
    } else {
      yield state.copyWith(isUpdating: false, emailInvalid: true);
    }
  }

  Stream<SettingScreenState> updateGroup(String groupId, Map<String, dynamic> body, String groupName, List<String> added, List<String> deleted) async* {
    yield state.copyWith(isUpdating: true);
    if (groupName != null) {
      dynamic nameCheck = await api.getGroupNameCount(
          token, state.business, groupName);
      if (nameCheck is num) {
        if (nameCheck == 0) {
          dynamic response = await api.updateGroup(token, state.business, groupId, body);
          print('added => $added');
          print('deleted => $deleted');
          if (added.length > 0) {
            yield* addEmployeeToGroup(added, groupId);
          }
          if (deleted.length > 0) {
            yield* deleteEmployeeFromGroup(deleted, groupId);
          }
          yield state.copyWith(isUpdating: false);
          yield SettingScreenUpdateSuccess(business: state.business);
        } else {
          yield state.copyWith(isUpdating: false, emailInvalid: true);
        }
      } else {
        yield state.copyWith(isUpdating: false, emailInvalid: true);
      }
    } else {
      dynamic response = await api.updateGroup(token, state.business, groupId, body);
      print('added => $added');
      print('deleted => $deleted');
      if (added.length > 0) {
        yield* addEmployeeToGroup(added, groupId);
      }
      if (deleted.length > 0) {
        yield* deleteEmployeeFromGroup(deleted, groupId);
      }
      yield state.copyWith(isUpdating: false);
      yield SettingScreenUpdateSuccess(business: state.business);
    }
  }

  Stream<SettingScreenState> deleteGroups() async* {
    yield state.copyWith(isLoading: true);
    List<GroupListModel> groups = state.groupList;
    List<GroupListModel> selected = groups.where((element) => element.isChecked).toList();
    if (selected.length > 0) {
      for(int i = 0; i < selected.length; i++) {
        await api.deleteGroup(token, state.business, selected[i].group.id);
      }
    }

    yield state.copyWith(isLoading: false);
    add(GetGroupEvent());
  }

  Stream<SettingScreenState> getGroupDetail(Group group) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.getGroupDetail(token, state.business, group.id);
    if (response is Map) {
      Group groupDetail = Group.fromMap(response);
      yield state.copyWith(groupDetail: groupDetail, isLoading: false);
    } else {
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<SettingScreenState> addEmployeeToGroup(List<String> employees, String groupId) async* {
    dynamic response = await api.addEmployeeToGroup(token, state.business, groupId, employees);
    yield state.copyWith(isLoading: false);
  }

  Stream<SettingScreenState> deleteEmployeeFromGroup(List<String> employees, String groupId) async* {
    dynamic response = await api.deleteEmployeeFromGroup(token, state.business, groupId, employees);
    yield state.copyWith(isLoading: false);
  }

  Stream<SettingScreenState> getLegalDocument(String type) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.getLegalDocument(token, state.business, type);
    if (response is Map) {
      LegalDocument legalDocument = LegalDocument.fromMap(response);
      yield state.copyWith(isLoading: false, legalDocument: legalDocument);
    } else {
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<SettingScreenState> updateLegalDocument(Map<String, dynamic> body, String type) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.updateLegalDocument(token, state.business, body, type);
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else if (response is Map){
      LegalDocument legalDocument = LegalDocument.fromMap(response);
      dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(business: legalDocument.business));
      globalStateModel.setCurrentBusiness(legalDocument.business,
          notify: true);
      yield state.copyWith(isUpdating: false);
      yield SettingScreenUpdateSuccess(
        business: state.business,
      );
    } else {
      yield SettingScreenStateFailure(error: 'Update Business name failed');
      yield state.copyWith(isUpdating: false);
    }
  }

  Stream<SettingScreenState> getUser() async* {
    User _user = state.user;
    if (_user == null) {
      yield state.copyWith(isLoading: true);
      dynamic userResponse = await api.getUser(token);
      User user = User.map(userResponse);
      dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(user: user));
      yield state.copyWith(isLoading: false, user: user);
    }
  }

  Stream<SettingScreenState> updateUser(Map<String, dynamic> body) async* {
    yield state.copyWith(isUpdating: true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic response = await api.updateUser(token, body);
    dynamic userResponse = await api.getUser(token);
    User user = User.map(userResponse);
    preferences.setString(GlobalUtils.LANGUAGE, user.language);
    Language.setLanguage(user.language);
    dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(user: user));
    yield SettingScreenUpdateSuccess(business: state.business,);
    yield state.copyWith(isUpdating: false, user: user);
  }

  Stream<SettingScreenState> uploadUserPhoto(File file) async* {
    yield state.copyWith(uploadUserImage: true);
    yield state.copyWith(blobName: '', isUpdatingBusinessImg: true);
    dynamic response = await api.postImageToBusiness(file, state.business, GlobalUtils.activeToken.accessToken);
    String blobName = response['blobName'];
    User user = state.user;
    user.logo = blobName;

    yield state.copyWith(uploadUserImage: false, user: user);
  }

  Stream<SettingScreenState> getAuthUser() async* {
    yield state.copyWith(isLoading: true);
    dynamic userResponse = await api.getAuthUser(token);
    AuthUser user = AuthUser.fromMap(userResponse);
    dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(authUser: user));
    yield state.copyWith(isLoading: false, authUser: user);
  }

  Stream<SettingScreenState> updateAuthUser(Map<String, dynamic> body) async* {
    yield state.copyWith(updating2FA: true);
    dynamic userResponse = await api.updateAuthUser(token, body);
    AuthUser user = AuthUser.fromMap(userResponse);
    dashboardScreenBloc.add(UpdateBusinessUserWallpaperEvent(authUser: user));
    yield state.copyWith(updating2FA: false, authUser: user);
  }

  Stream<SettingScreenState> updatePassword(String newPassword, String oldPassword) async* {
    yield state.copyWith(isUpdating: true);
    dynamic userResponse = await api.updatePassword(token, {'newPassword': newPassword, 'oldPassword': oldPassword});
    yield state.copyWith(isUpdating: false,);
    yield SettingScreenUpdateSuccess(business: state.business);
  }

  Stream<SettingScreenState> deleteBusiness() async* {
    yield state.copyWith(isDeleting: true);
    dynamic response = await api.deleteBusiness(token, state.business);
    yield state.copyWith(isDeleting: false,);
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.message);
    } else {
      yield BusinessDeleteSuccessState();
    }
  }

  String _getFilterKeyString(String type) {
    switch (type) {
      case 'name':
        return 'filter\[nameAndEmail\]';
      case 'position':
        return 'filter\[positions.positionType\]';
      case 'email':
        return 'filter\[email\]';
      case 'status':
        return 'filter\[status\]';
    }
    return '';
  }

  String _getFilterValueString(String type, String value) {
    switch (type) {
      case 'is':
        return '\^$value\$';
      case 'isNot':
        return '\^\(\?\!$value\$)';
      case 'startsWith':
        return '\^$value';
      case 'endsWith':
        return '$value\$';
      case 'contains':
        return '$value';
      case 'doesNotContain':
        return '\^\(\(\?\!$value\)\.\)\*\$';
    }
    return '';
  }
}