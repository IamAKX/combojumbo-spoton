import 'dart:developer';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Utilities {
  List<FoodModel> getAllFavouriteFood() {
    List<FoodModel> favList = [];
    if (prefs.getStringList(PrefernceKey.FAVOURITE_FOOD) != null) {
      for (String food in prefs.getStringList(PrefernceKey.FAVOURITE_FOOD)!)
        favList.add(FoodModel.fromJson(food));
    }

    return favList;
  }

  Future<List<FoodModel>> getAllFavouriteFoodOnline(
      CatalogService _catalogService, BuildContext context) async {
    List<FoodModel> favList = [];
    // if (prefs.getStringList(PrefernceKey.FAVOURITE_FOOD) != null) {
    //   for (String food in prefs.getStringList(PrefernceKey.FAVOURITE_FOOD)!)
    //     favList.add(FoodModel.fromJson(food));
    // }
    await _catalogService
        .getAllFavourite(context)
        .then((value) => favList = value);

    return favList;
  }

  setFavouriteFood(List<FoodModel> favList) {
    List<String> foodStringList = [];
    for (FoodModel foodModel in favList) foodStringList.add(foodModel.toJson());
    prefs.setStringList(PrefernceKey.FAVOURITE_FOOD, foodStringList);
  }

  bool isFoodMarkedFavourite(List<FoodModel> favList, String id) {
    bool isPresent = false;
    for (FoodModel model in favList) {
      if (model.id == id) {
        isPresent = true;
        break;
      }
    }
    return isPresent;
  }

  String getYoutubeVideoId(String url) {
    String vID = '';
    try {
      vID = YoutubePlayer.convertUrlToId(url)!;
      print('this is ' + vID);
    } on Exception catch (exception) {
      // only executed if error is of type Exception
      print('exception');
    } catch (error) {
      // executed for errors of all types other than Exception
      print('catch error');
      //  videoIdd="error";

    }
    return vID;
  }

  bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  Future<bool> removeAppliedDiscout() {
    return prefs.remove(PrefernceKey.COUPON_CODE);
  }

  bool isValidPhone(String phone) {
    try {
      if (phone.length != 10) return false;
      int.parse(phone);
    } catch (e) {
      return false;
    }
    return RegExp(r"^[789]\d{9}$").hasMatch(phone);
  }

  bool isValidPassword(String password) {
    // check for min length
    if (password.length < 6) {
      SnackBarService.instance
          .showSnackBarInfo('Password must be of alteast 6 charater');
      return false;
    }

    // check for lowercase
    int count = 0;
    for (var c in password.split('')) {
      if (Constants.LOWERCASE_ALPHABET.contains(c)) count++;
    }
    if (count == 0) {
      SnackBarService.instance.showSnackBarInfo(
          'Password must contain atleast 1 lowercase alphabet');
      return false;
    }

    // check for uppercase
    count = 0;
    for (var c in password.split('')) {
      if (Constants.UPPERCASE_ALPHABET.contains(c)) count++;
    }
    if (count == 0) {
      SnackBarService.instance.showSnackBarInfo(
          'Password must contain atleast 1 uppercase alphabet');
      return false;
    }

    // check for digit
    count = 0;
    for (var c in password.split('')) {
      if (Constants.DIGITS.contains(c)) count++;
    }
    if (count == 0) {
      SnackBarService.instance
          .showSnackBarInfo('Password must contain atleast 1 digit');
      return false;
    }

    // check for sepcial character
    count = 0;
    for (var c in password.split('')) {
      if (Constants.SPECIAL_CHARACTER.contains(c)) count++;
    }
    if (count == 0) {
      SnackBarService.instance.showSnackBarInfo(
          'Password must contain atleast 1 special character');
      return false;
    }

    return true;
  }

  // static List<AddressModel> loadAllAddress() {
  //   List<AddressModel> list = [];
  //   if (prefs.getStringList(PrefernceKey.ADDRESS) != null) {
  //     for (String s in prefs.getStringList(PrefernceKey.ADDRESS)!)
  //       list.add(AddressModel.fromJson(s));
  //   }
  //   return list;
  // }

  // static addAddress(AddressModel model) {
  //   List<AddressModel> list = loadAllAddress();
  //   List<String> stringList = [];
  //   for (AddressModel m in list) {
  //     stringList.add(m.toJson());
  //   }
  //   stringList.add(model.toJson());
  //   prefs.setStringList(PrefernceKey.ADDRESS, stringList);
  // }

  // static deleteAddress(AddressModel model) {
  //   List<AddressModel> list = loadAllAddress();
  //   list.removeWhere((element) => element.id == model.id);
  //   List<String> stringList = [];
  //   for (AddressModel m in list) {
  //     stringList.add(m.toJson());
  //   }
  //   prefs.setStringList(PrefernceKey.ADDRESS, stringList);
  // }
}
