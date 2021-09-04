import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/food_model.dart';
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
}
