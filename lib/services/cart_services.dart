import 'dart:convert';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/coupon_discount_detail_model.dart';
import 'package:cjspoton/model/coupon_model.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/model/user_model.dart';
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

  Future<AllChargesModel> getAllCharges(BuildContext context) async {
    status = CartStatus.Loading;
    notifyListeners();
    late AllChargesModel allChargesModel;
    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
      var reqBody = FormData.fromMap({'outletid': outletModel.outletId});
      Response response = await _dio.post(API.AllCharges, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          body = body[0];
          allChargesModel = AllChargesModel(
              Service_Charge: body['Service_Charge'],
              Packing_Charge: body['Packing_Charge'],
              Table_Booking_Charge: body['Table_Booking_Charge'],
              Discount_Amount_Table_Booking:
                  body['Discount_Amount_Table_Booking'],
              EDining_Charges: body['EDining_Charges'],
              max_cod_allowed_for_delivery:
                  body['max_cod_allowed_for_delivery'],
              min_order_online: body['min_order_online'],
              min_order_free_shipping: body['min_order_free_shipping'],
              gst: body['gst']);
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
    return allChargesModel;
  }

  Future<List<CouponModel>> getAllCoupon(BuildContext context) async {
    status = CartStatus.Loading;
    notifyListeners();
    List<CouponModel> couponList = [];
    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
      var reqBody = FormData.fromMap({'outletid': outletModel.outletId});
      Response response = await _dio.post(API.CouponCode, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          for (var c in body) {
            CouponModel model =
                CouponModel(Id: c['Id'], code: c['Coupon Code']);
            couponList.add(model);
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
    return couponList;
  }

  Future<CouponDiscountDetailModel> verifyCoupon(
      String cuponCode, String totalAmount, BuildContext context) async {
    status = CartStatus.Loading;
    notifyListeners();
    late CouponDiscountDetailModel couponDiscountDetailModel;
    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
      UserModel userModel =
          UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({
        'cust_id': userModel.id,
        'outletid': outletModel.outletId,
        'cupon_code': cuponCode,
        'totalamount': totalAmount
      });
      Response response = await _dio.post(API.VerifyCouponCode, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          body = body[0];
          couponDiscountDetailModel = CouponDiscountDetailModel(
            coupon_code: body['coupon_code'],
            coupon_type: body['coupon_type'],
            coupon_value: body['coupon_value'],
            coupon_id: body['coupon_id'],
            minimum_order_value: body['minimum_order_value'],
            maximum_order_value: body['maximum_order_value'],
            no_times: body['no_times'],
          );
          status = CartStatus.Success;
          SnackBarService.instance
              .showSnackBarSuccess((resBody['msg']).toString().trim());

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
    return couponDiscountDetailModel;
  }
}
