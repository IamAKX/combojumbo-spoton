import 'dart:convert';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum CartStatus {
  Ideal,
  Loading,
  Success,
  Failed,
}

class CartServices extends ChangeNotifier {
  static CartServices instance = CartServices();
  late Dio _dio;
  CartStatus? status = CartStatus.Ideal;

  CartServices() {
    _dio = Dio();
  }

  Future<List<PincodeModel>> fetchAllPincodes(BuildContext context) async {
    status = CartStatus.Loading;
    notifyListeners();
    List<PincodeModel> list = [];
    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);

      Response response = await _dio.post(
        API.PincodeCharge,
      );

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['data'];

        if (resBody['status'] == 1) {
          for (var pincode in body) {
            if (outletModel.outletId == pincode['outletid']) {
              PincodeModel model = PincodeModel(
                  id: pincode['id'],
                  pincode: pincode['pincode'],
                  charge: pincode['charge'],
                  status: pincode['status'],
                  outletid: pincode['outletid'],
                  location: pincode['location']);

              list.add(model);
            }
          }
          status = CartStatus.Success;
          notifyListeners();
        } else {
          status = CartStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
        }
      } else {
        status = CartStatus.Failed;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = CartStatus.Failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
    return list;
  }
}
