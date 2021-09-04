import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/utils/prefs_key.dart';

class Constants {
  static const String RUPEE = '₹';

  static PincodeModel getDefaultPincode() {
    if (prefs.getString(PrefernceKey.SELECTED_PINCODE) != null)
      return PincodeModel.fromJson(
          prefs.getString(PrefernceKey.SELECTED_PINCODE)!);

    OutletModel outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    if (outletModel.outletId == 'ECJ2')
      return PincodeModel(
          id: '1',
          pincode: '400611',
          charge: '0',
          status: '1',
          outletid: 'ECJ2',
          location: 'tt');
    else
      return PincodeModel(
          id: '4',
          pincode: '400706',
          charge: '0',
          status: '1',
          outletid: 'ECJ29',
          location: 'b');
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
}
