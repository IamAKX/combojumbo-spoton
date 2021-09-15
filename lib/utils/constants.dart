import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/utils/prefs_key.dart';

class Constants {
  static const String RUPEE = '₹';
  static const String PAYU_MONEY_MERCHANT_KEY = 'psIxnCGd';
  static const String PAYU_MONEY_MERCHANT_ID = '6713332';
  static const String PAYU_MONEY_SALT = '1cEIP21zvx';

  static const String OWNER_CONTACT_NUMBER = '+918850458452';

  static PincodeModel getDefaultPincode() {
    if (prefs.getString(PrefernceKey.SELECTED_PINCODE) != null)
      return PincodeModel.fromJson(
          prefs.getString(PrefernceKey.SELECTED_PINCODE)!);

    OutletModel outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    if (outletModel.outletId == 'ECJ2')
      return PincodeModel(
          id: '1',
          pincode: '400705',
          charge: '0',
          status: '1',
          outletid: 'ECJ2',
          location: 'Sanpada');
    else
      return PincodeModel(
          id: '4',
          pincode: '400706',
          charge: '0',
          status: '1',
          outletid: 'ECJ29',
          location: 'Nerul\/Seawoods');
  }
}

extension StringExtension on String {
  String toCamelCase() {
    if (this.length == 0) return this;
    if (this.length > 1)
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    else
      return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String toWordCase() {
    if (this.length == 0)
      return this;
    else
      return "${this.split(" ").map((str) => str.toCamelCase()).join(" ")}";
  }

  double toDouble() {
    if (this.length == 0)
      return 0;
    else {
      try {
        return double.parse(this);
      } catch (e) {
        return 0;
      }
    }
  }
}
