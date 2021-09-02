import 'dart:convert';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/add_on_model.dart';
import 'package:cjspoton/model/add_on_model_item.dart';
import 'package:cjspoton/model/category_model.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
    status = CatalogStatus.Ideal;
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
        print('Response : ${response.data}');

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
    status = CatalogStatus.Ideal;
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
      print('Response : $resBody');

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
}
