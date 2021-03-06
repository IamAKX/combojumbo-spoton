import 'dart:convert';
import 'dart:developer';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/add_on_model.dart';
import 'package:cjspoton/model/add_on_model_item.dart';
import 'package:cjspoton/model/category_model.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/model/offer_model.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/cj_spoton/table_model.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:universal_internet_checker/universal_internet_checker.dart';

enum CatalogStatus {
  Ideal,
  Loading,
  Success,
  Failed,
}

class CatalogService extends ChangeNotifier {
  static CatalogService instance = CatalogService();
  late Dio _dio;
  CatalogStatus? status = CatalogStatus.Ideal;

  CatalogService() {
    _dio = Dio();
  }

  Future<List<CategoryModel>> fetchAllCategories(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = CatalogStatus.Loading;
    notifyListeners();
    List<CategoryModel> list = [];
    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
      var reqBody = FormData.fromMap({'outletid': outletModel.outletId});

      Response response = await _dio.post(
        API.Categories,
        data: reqBody,
      );

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        var body = resBody['body'];

        if (resBody['status'] == 1) {
          for (var category in body) {
            CategoryModel categoryModel = CategoryModel(
              categoryName: category['CategoryName'],
              foodcount: category['foodcount'],
              id: category['Id'],
              startsfrom: category['startsfrom'],
              image: category['Image'],
              foodList: [],
            );
            list.add(categoryModel);
          }
          status = CatalogStatus.Success;
          notifyListeners();
        } else {
          status = CatalogStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
        }
      } else {
        status = CatalogStatus.Failed;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = CatalogStatus.Failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
    return list;
  }

  Future<List<CategoryModel>> fetchAllFoodItem(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = CatalogStatus.Loading;
    notifyListeners();
    List<CategoryModel> list = [];
    // try {
    OutletModel outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    var reqBody = FormData.fromMap({'outletid': outletModel.outletId});

    Response response = await _dio.post(
      API.FoodItems,
      data: reqBody,
    );

    var resBody = json.decode(response.data.toString());
    if (response.statusCode == 200) {
      var body = resBody['Category'];

      if (resBody['status'] == "1") {
        for (var category in body) {
          CategoryModel categoryModel = CategoryModel(
            categoryName: category['CategoryName'],
            foodcount: category['foodcount'],
            id: category['CategoryId'] ?? '',
            startsfrom: category['startsfrom'] ?? '',
            image: category['Image'] ??
                'https://www.freeiconspng.com/thumbs/error-icon/error-icon-32.png',
            foodList:
                category['Food'] == null ? [] : parseFoodList(category['Food']),
          );
          list.add(categoryModel);
        }
        status = CatalogStatus.Success;
        notifyListeners();
      } else {
        status = CatalogStatus.Failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError('${resBody['status']}');
      }
    } else {
      status = CatalogStatus.Failed;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
    }
    // } catch (e) {
    //   status = CatalogStatus.Failed;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    // }
    return list;
  }

  parseFoodList(foodList) {
    List<FoodModel> list = [];
    for (var food in foodList) {
      FoodModel foodModel = FoodModel(
          id: food['id'] ?? '',
          foodname: food['foodname'] ?? '',
          fooddescription: food['fooddescription'] ?? '',
          foodamount: food['foodamount'] ?? '',
          fooddiscountamount: food['fooddiscountamount'] ?? '',
          foodid: food['foodid'] ?? '',
          foodcode: food['foodcode'] ?? '',
          foodImage: food['foodImage'] ??
              'https://www.freeiconspng.com/thumbs/error-icon/error-icon-32.png',
          addons:
              food['addons'] == null ? [] : parseFoodAddons(food['addons']));

      list.add(foodModel);
    }
    return list;
  }

  parseFoodAddons(foodAddOnsList) {
    List<AddOnModel> list = [];
    for (var addOn in foodAddOnsList) {
      AddOnModel addOnModel = AddOnModel(
          id: addOn['id'] ?? '',
          Mainheading: addOn['Mainheading'] ?? '',
          Type: addOn['Type'] ?? '',
          Requirement: addOn['Requirement'] ?? '',
          Maxqnt: addOn['Maxqnt'] ?? '',
          subaddons: addOn['subaddons'] == null
              ? []
              : parseAddOnItem(addOn['subaddons']));
      list.add(addOnModel);
    }
    return list;
  }

  parseAddOnItem(addOnItemList) {
    List<AddOnItemModel> list = [];
    for (var item in addOnItemList) {
      AddOnItemModel model = AddOnItemModel(
        id: item['id'] ?? '',
        subaddonsname: item['subaddonsname'] ?? '',
        amount: item['amount'] ?? '',
      );
      list.add(model);
    }
    return list;
  }

  Future<List<TableModel>> fetchAllTable(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = CatalogStatus.Loading;
    notifyListeners();
    List<TableModel> list = [];
    // try {
    OutletModel outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);

    var reqBody = FormData.fromMap({'outletid': outletModel.outletId});
    Response response = await _dio.post(API.AllTable, data: reqBody);

    var resBody = json.decode(response.data);
    if (response.statusCode == 200) {
      var body = resBody['body'];

      if (resBody['status'] == 1) {
        for (var item in body) {
          TableModel model = TableModel.fromMap(item);
          list.add(model);
        }
        status = CatalogStatus.Success;
        notifyListeners();
      } else {
        status = CatalogStatus.Failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError((resBody['msg']));
      }
    } else {
      status = CatalogStatus.Failed;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
    }
    // } catch (e) {
    //   status = CatalogStatus.Failed;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    // }
    return list;
  }

  Future<OfferModel?> fetchOffer(BuildContext context) async {
    late OfferModel offerModel;
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return null;
    }
    status = CatalogStatus.Loading;
    notifyListeners();
    // try {
    OutletModel outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    var reqBody = FormData.fromMap({'outletid': outletModel.outletId});

    Response response = await _dio.post(
      API.OfferHome,
      data: reqBody,
    );

    var resBody = json.decode(response.data.toString());
    if (response.statusCode == 200) {
      if (resBody['status'] == 1) {
        offerModel = OfferModel.fromMap(resBody);
        status = CatalogStatus.Success;
        notifyListeners();
      } else {
        status = CatalogStatus.Failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError('${resBody['status']}');
      }
    } else {
      status = CatalogStatus.Failed;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
    }
    // } catch (e) {
    //   status = CatalogStatus.Failed;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    // }
    return offerModel;
  }

  Future<List<FoodModel>> getAllFavourite(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = CatalogStatus.Loading;
    notifyListeners();
    List<FoodModel> list = [];
    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
      UserModel userModel =
          UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({'custid': userModel.id});
      Response response = await _dio.post(API.FavouriteList, data: reqBody);
      log(response.data);
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        var body = resBody['data'];
        if (resBody == "Not Available") return [];
        if (resBody['status'] == "1") {
          for (var c in body) {
            FoodModel model = FoodModel(
                id: c['id'],
                foodname: c['foodname'],
                fooddescription: c['fooddescription'],
                foodamount: c['foodamount'],
                fooddiscountamount: c['fooddiscountamount'],
                foodid: c['foodid'],
                foodcode: c['foodcode'],
                foodImage: c['foodImage'],
                addons: c['addons'] ?? []);
            list.add(model);
          }
          Utilities().setFavouriteFood(list);
          log("saving fav locally : ${Utilities().getAllFavouriteFood().length}");
          status = CatalogStatus.Success;
          notifyListeners();
        } else {
          status = CatalogStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
        }
      } else {
        status = CatalogStatus.Failed;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = CatalogStatus.Failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
    return list;
  }

  Future<bool> addFavourite(String productId, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return false;
    }
    status = CatalogStatus.Loading;
    notifyListeners();

    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
      UserModel userModel =
          UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({
        'productid': productId,
        'userid': userModel.id,
        'outletid': outletModel.outletId
      });
      Response response = await _dio.post(API.AddFavourite, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        if (resBody['status'] == 1) {
          SnackBarService.instance.showSnackBarSuccess(resBody['msg']);
          status = CatalogStatus.Success;
          notifyListeners();
          return true;
        } else {
          status = CatalogStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
          return false;
        }
      } else {
        status = CatalogStatus.Failed;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
        return false;
      }
    } catch (e) {
      status = CatalogStatus.Failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      return false;
    }
  }

  Future<bool> removeFavourite(String productId, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return false;
    }
    status = CatalogStatus.Loading;
    notifyListeners();

    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
      UserModel userModel =
          UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({'id': productId, 'userid': userModel.id});
      Response response = await _dio.post(API.RemoveFavourite, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        // log(response.data);
        if (resBody['status'] == 1) {
          SnackBarService.instance.showSnackBarSuccess(resBody['msg']);
          status = CatalogStatus.Success;
          notifyListeners();
          return true;
        } else {
          status = CatalogStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
          return false;
        }
      } else {
        status = CatalogStatus.Failed;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
        return false;
      }
    } catch (e) {
      status = CatalogStatus.Failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      return false;
    }
  }
}
