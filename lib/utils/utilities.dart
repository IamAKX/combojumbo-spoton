import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/screen/add_delivery_addres/address_model.dart';
import 'package:cjspoton/utils/prefs_key.dart';

class Utilities {
  List<FoodModel> getAllFavouriteFood() {
    List<FoodModel> favList = [];
    if (prefs.getStringList(PrefernceKey.FAVOURITE_FOOD) != null) {
      for (String food in prefs.getStringList(PrefernceKey.FAVOURITE_FOOD)!)
        favList.add(FoodModel.fromJson(food));
    }
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

  bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isValidPhone(String phone) {
    try {
      if (phone.length != 10) return false;
      int.parse(phone);
    } catch (e) {
      return false;
    }
    return true;
  }

  static List<AddressModel> loadAllAddress() {
    List<AddressModel> list = [];
    if (prefs.getStringList(PrefernceKey.ADDRESS) != null) {
      for (String s in prefs.getStringList(PrefernceKey.ADDRESS)!)
        list.add(AddressModel.fromJson(s));
    }
    return list;
  }

  static addAddress(AddressModel model) {
    List<AddressModel> list = loadAllAddress();
    List<String> stringList = [];
    for (AddressModel m in list) {
      stringList.add(m.toJson());
    }
    stringList.add(model.toJson());
    prefs.setStringList(PrefernceKey.ADDRESS, stringList);
  }

  static deleteAddress(AddressModel model) {
    List<AddressModel> list = loadAllAddress();
    list.removeWhere(
        (element) => element.completeAddress == model.completeAddress);
    List<String> stringList = [];
    for (AddressModel m in list) {
      stringList.add(m.toJson());
    }
    prefs.setStringList(PrefernceKey.ADDRESS, stringList);
  }
}
