import 'dart:convert';
import 'dart:developer';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/coupon_discount_detail_model.dart';
import 'package:cjspoton/model/coupon_model.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/model/section_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/add_delivery_addres/address_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/cart/cart_variable_model.dart';
import 'package:cjspoton/screen/order/order_detail.dart';
import 'package:cjspoton/screen/order/order_food_model.dart';
import 'package:cjspoton/screen/order/order_menu_details.dart';
import 'package:cjspoton/screen/order/order_model.dart';
import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_menu_details.dart';
import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_model.dart';
import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_order_details.dart';
import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_order_food_model.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_payu_unofficial/models/payment_params_model.dart';
import 'package:universal_internet_checker/universal_internet_checker.dart';
import '../utils/constants.dart';

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
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
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

  Future<AllChargesModel?> getAllCharges(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return null;
    }
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
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = CartStatus.Loading;
    notifyListeners();
    List<CouponModel> couponList = [];
    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
      UserModel userModel =
          UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap(
          {'outletid': outletModel.outletId, 'cust_id': userModel.id});
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

  Future<CouponDiscountDetailModel?> verifyCoupon(
      String cuponCode, String totalAmount, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return null;
    }
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
          CouponDiscountDetailModel cModel = CouponDiscountDetailModel(
            coupon_code: body['coupon_code'],
            coupon_type: body['coupon_type'],
            coupon_value: body['coupon_value'],
            coupon_id: body['coupon_id'],
            minimum_order_value: body['minimum_order_value'],
            maximum_order_value: body['maximum_order_value'],
            no_times: body['no_times'],
          );
          double cartAmt = double.parse(totalAmount);
          if (cModel != null &&
              cartAmt > cModel.minimum_order_value.toDouble()) {
            couponDiscountDetailModel = cModel;
            status = CartStatus.Success;
            SnackBarService.instance
                .showSnackBarSuccess((resBody['msg']).toString().trim());
          } else {
            status = CartStatus.Failed;
            SnackBarService.instance.showSnackBarSuccess(
                'Cart amount must be more than ${Constants.RUPEE} ${cModel.minimum_order_value.toDouble().toStringAsFixed(2)}');
          }
          notifyListeners();
        } else {
          status = CartStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
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

  Future<bool> placeOrder(
      CartVriablesModel cartVriablesModel,
      AddressModel addressModel,
      Map? payUMoneyResponse,
      PaymentParams paymentParam,
      String payUMoneyTxnId,
      String paymentState,
      BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return false;
    }
    status = CartStatus.Loading;
    notifyListeners();

    // try {
    OutletModel outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    UserModel userModel =
        UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var payload = {
      'cust_id': "${userModel.id.toString()}",
      'outletid': '${outletModel.outletId}',
      'response': '$paymentState',
      'responseDetials': payUMoneyResponse,
      'oid': '${userModel.id}${DateTime.now().millisecond}',
      'subtotal': '${CartHelper.getTotalPriceOfCart()}',
      'couponcode':
          '${cartVriablesModel.couponDiscountDetailModel?.coupon_code}',
      'actualdiscountvalue':
          '${CartHelper.getDiscountPrice(cartVriablesModel.couponDiscountDetailModel)}',
      'discountvalue':
          '${cartVriablesModel.couponDiscountDetailModel?.coupon_value}',
      'deliverycharge': '${cartVriablesModel.selectedPincode.charge}',
      'packingcharge': '${cartVriablesModel.allChargesModel!.Packing_Charge}',
      'gstpercentage': '${cartVriablesModel.allChargesModel!.gst}',
      'gstvalue':
          '${CartHelper.getServiceCharge(cartVriablesModel.allChargesModel).toStringAsFixed(2)}',
      'servicecharge': '${cartVriablesModel.allChargesModel!.Service_Charge}',
      'totalpaidamount': '${cartVriablesModel.netAmount}',
      'pay': 'payumoney',
      'transcation_id': '$payUMoneyTxnId',
      'ordertype': 'Delivery',
      'address1': '${addressModel.address1}',
      'address2': '${addressModel.address2}',
      'landmark': '${addressModel.landmark}',
      'state': '${addressModel.stateModel.id}',
      'city': '${addressModel.city.id}',
      'pincode': '${cartVriablesModel.selectedPincode.id}',
      'delivery_suggestion': '${cartVriablesModel.deliverySuggestion}',
      'delivery_instruction': '${addressModel.deliveryInstruction}',
      'cart': CartHelper.getGroupedCartJson()
    };
    var reqBody = FormData.fromMap(payload);

    log(json.encode(payload));

    Response response = await _dio.post(API.PlaceOrder, data: payload);
    log('response : ' + response.data.toString());
    var resBody = json.decode(response.data);
    if (response.statusCode == 200) {
      print('Response : ${response.data}');
      var body = resBody['body'];
      if (resBody['status'] == 1) {
        status = CartStatus.Success;
        SnackBarService.instance
            .showSnackBarSuccess((resBody['msg']).toString().trim());
        if (paymentState == 'success') CartHelper.clearCart();
        notifyListeners();
        return true;
      } else {
        status = CartStatus.Failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError((body['msg']));
        return false;
      }
    } else {
      status = CartStatus.Failed;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
      return false;
    }
    // }
    // catch (e) {
    //   status = CartStatus.Failed;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    //   return false;
    // }
    return false;
  }

  Future<List<OrderDetailModel>> getOrderHistory(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = CartStatus.Loading;
    notifyListeners();
    List<OrderDetailModel> list = [];
    // try {
    UserModel userModel =
        UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var reqBody = FormData.fromMap({
      'cust_id': '${userModel.id} ',
    });
    Response response = await _dio.post(API.OrderHistory, data: reqBody);

    var resBody = json.decode(response.data);
    if (response.statusCode == 200) {
      log('Response : ${response.data}');

      var body = resBody['body'] ?? [];

      if (resBody['status'] == "1" || resBody['status'] == 1) {
        status = CartStatus.Success;
        for (var history in body) {
          var orderJson = history['order'];
          OrderModel orderModel = OrderModel(
            id: orderJson['id'],
            trans_id: orderJson['trans_id'],
            cust_id: orderJson['cust_id'],
            oid: orderJson['oid'],
            coupon_code: orderJson['coupon_code'],
            coupon_type: orderJson['coupon_type'],
            coupon_minimum: orderJson['coupon_minimum'],
            coupon_maximum: orderJson['coupon_maximum'],
            coupon_orignal_discount: orderJson['coupon_orignal_discount'],
            wheelcoupon: orderJson['wheelcoupon'],
            coupon_value: orderJson['coupon_value'],
            subtotal: orderJson['subtotal'],
            coupon_discountamount: orderJson['coupon_discountamount'],
            delivery_charge: orderJson['delivery_charge'],
            gst: orderJson['gst'],
            gst_amount: orderJson['gst_amount'],
            service_charge: orderJson['service_charge'],
            packging_charge: orderJson['packging_charge'],
            total_amount: orderJson['total_amount'],
            date_creation: orderJson['date_creation'],
            genrated_by: orderJson['genrated_by'],
            payment_type: orderJson['payment_type'],
            status: orderJson['status'],
            order_status: orderJson['order_status'],
            ordertype: orderJson['ordertype'],
            whosorderadd_id: orderJson['whosorderadd_id'],
            order_addrole: orderJson['order_addrole'],
            delivery_boy_id: orderJson['delivery_boy_id'],
            delivery_boy_name: orderJson['delivery_boy_name'],
            delivery_otp: orderJson['delivery_otp'],
            link_uid: orderJson['link_uid'],
            noofpeopletable: orderJson['noofpeopletable'],
            tablebook: orderJson['tablebook'],
            randpaymeny: orderJson['randpaymeny'],
            outletid: orderJson['outletid'],
            addrecordid: orderJson['addrecordid'],
            waiter_tip: orderJson['waiter_tip'],
            txnid: orderJson['txnid'],
            cart_id: orderJson['cart_id'],
            address_id: orderJson['address_id'],
            delivey_who: orderJson['delivey_who'],
            uricko_token: orderJson['uricko_token'],
            uricko_status: orderJson['uricko_status'],
            table_booking_id: orderJson['table_booking_id'],
            adjust_amount_table: orderJson['adjust_amount_table'],
            refund_amount: orderJson['refund_amount'],
            paid_amount: orderJson['paid_amount'],
            app: orderJson['app'],
          );

          List<OrderMenuDetails>? menuDetails = [];
          var menuDetailsJson = history['menu-deails'] ?? [];
          for (var element in menuDetailsJson) {
            var foodJson = element['food'];
            OrderFoodModel orderFoodModel = OrderFoodModel(
              id: foodJson['id'],
              relid: foodJson['relid'],
              oid: foodJson['oid'],
              pro_id: foodJson['pro_id'],
              qty: foodJson['qty'],
              price: foodJson['price'],
              discountprice: foodJson['discountprice'],
              calculateprice: foodJson['calculateprice'],
              productname: foodJson['productname'],
              status: foodJson['status'],
              cust_id: foodJson['cust_id'],
              combooffer: foodJson['combooffer'],
              remark: foodJson['remark'],
              outletid: foodJson['outletid'],
              addrecordid: foodJson['addrecordid'],
              date: foodJson['date'],
              addons: foodJson['addons'],
              addonsfoodrelated: foodJson['addonsfoodrelated'],
              sequenceid: foodJson['sequenceid'],
              foodidrelatedaddons: foodJson['foodidrelatedaddons'],
              kotid: foodJson['kotid'],
              addonsrelation: foodJson['addonsrelation'],
              payment_id: foodJson['payment_id'],
              type: foodJson['type'],
              addonslebel: foodJson['addonslebel'],
              addonslebelid: foodJson['addonslebelid'],
              partypacks: foodJson['partypacks'],
              app: foodJson['app'],
            );
            OrderMenuDetails orderMenuDetails =
                OrderMenuDetails(food: orderFoodModel, addons: '');
            menuDetails.add(orderMenuDetails);
          }
          OrderDetailModel orderDetailModel = OrderDetailModel(
              order: orderModel,
              menuDetails: menuDetails,
              address: history['address'],
              outletname: history['outletname']);
          list.add(orderDetailModel);
        }

        notifyListeners();
      } else {
        status = CartStatus.Failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError('Something went wrong');
      }
    } else {
      status = CartStatus.Failed;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
    }
    // } catch (e) {
    //   status = CartStatus.Failed;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    // }
    return list;
  }

  Future<bool> placeTakeAwayOrder(
      CartVriablesModel cartVriablesModel,
      Map? payUMoneyResponse,
      PaymentParams paymentParam,
      String payUMoneyTxnId,
      String paymentState,
      BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return false;
    }
    status = CartStatus.Loading;
    notifyListeners();

    // try {
    OutletModel outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    UserModel userModel =
        UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var payload = {
      'cust_id': "${userModel.id.toString()}",
      'outletid': '${outletModel.outletId}',
      'response': '$paymentState',
      'responseDetials': payUMoneyResponse,
      'oid': '${userModel.id}${DateTime.now().millisecond}',
      'subtotal': '${CartHelper.getTotalPriceOfCart()}',
      'couponcode':
          '${cartVriablesModel.couponDiscountDetailModel?.coupon_code}',
      'actualdiscountvalue':
          '${CartHelper.getDiscountPrice(cartVriablesModel.couponDiscountDetailModel)}',
      'discountvalue':
          '${cartVriablesModel.couponDiscountDetailModel?.coupon_value}',
      'deliverycharge': '${cartVriablesModel.selectedPincode.charge}',
      'packingcharge': '${cartVriablesModel.allChargesModel!.Packing_Charge}',
      'gstpercentage': '${cartVriablesModel.allChargesModel!.gst}',
      'gstvalue':
          '${CartHelper.getServiceCharge(cartVriablesModel.allChargesModel).toStringAsFixed(2)}',
      'servicecharge': '${cartVriablesModel.allChargesModel!.Service_Charge}',
      'totalpaidamount': '${cartVriablesModel.netAmount}',
      'pay': 'payumoney',
      'transcation_id': '$payUMoneyTxnId',
      'ordertype': 'Take-Away',
      'address1': '',
      'address2': '',
      'landmark': '',
      'state': '',
      'city': '',
      'pincode': '${cartVriablesModel.selectedPincode.id}',
      'delivery_suggestion': '${cartVriablesModel.deliverySuggestion}',
      'delivery_instruction': '',
      'cart': CartHelper.getGroupedCartJson()
    };
    var reqBody = FormData.fromMap(payload);

    log(json.encode(payload));

    Response response = await _dio.post(API.PlaceOrder, data: payload);
    log('response : ' + response.data.toString());
    var resBody = json.decode(response.data);
    if (response.statusCode == 200) {
      print('Response : ${response.data}');
      var body = resBody['body'];
      if (resBody['status'] == 1) {
        status = CartStatus.Success;
        SnackBarService.instance
            .showSnackBarSuccess((resBody['msg']).toString().trim());
        if (paymentState == 'success') CartHelper.clearCart();
        notifyListeners();
        return true;
      } else {
        status = CartStatus.Failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError((body['msg']));
        return false;
      }
    } else {
      status = CartStatus.Failed;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
      return false;
    }
    // }
    // catch (e) {
    //   status = CartStatus.Failed;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    //   return false;
    // }
    return false;
  }

  Future<List<SectionModel>> getAllSection(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = CartStatus.Loading;
    notifyListeners();
    List<SectionModel> list = [];
    try {
      OutletModel outletModel =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);

      var reqBody = FormData.fromMap({'outletid': outletModel.outletId});
      Response response = await _dio.post(API.GetSection, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          for (var section in body) {
            SectionModel model = SectionModel(
              id: section['id'],
              selectedOutlet: section['outletid'],
              sectionname: section['sectionname'],
              guest: section['guest'],
              image: section['image'],
            );
            list.add(model);
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

  Future<bool> placeTableBookingOrder(
      TableBookingModel tableBookingModel,
      Map? payUMoneyResponse,
      PaymentParams paymentParam,
      String payUMoneyTxnId,
      String paymentState,
      BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return false;
    }
    status = CartStatus.Loading;
    notifyListeners();

    // try {
    OutletModel outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    UserModel userModel =
        UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var payload = {
      'cust_id': "${userModel.id.toString()}",
      'outletid': '${outletModel.outletId}',
      'response': '$paymentState',
      'responseDetials': payUMoneyResponse,
      'oid': '${userModel.id}${DateTime.now().millisecond}',
      'totalpaidamount':
          '${tableBookingModel.allChargesModel!.Table_Booking_Charge.toDouble()}',
      'pay': 'payumoney',
      'transcation_id': '$payUMoneyTxnId',
      'ordertype': 'Table Booking',
      'sectionid': '${tableBookingModel.section.id}',
      'dateTime': '${tableBookingModel.bookingSlot}',
      'guestcount': '${tableBookingModel.numberOfGuest}',
    };
    var reqBody = FormData.fromMap(payload);

    log(json.encode(payload));

    Response response = await _dio.post(API.PlaceOrder, data: payload);
    log('response : ' + response.data.toString());
    var resBody = json.decode(response.data);
    if (response.statusCode == 200) {
      print('Response : ${response.data}');
      var body = resBody['body'];
      if (resBody['status'] == 1) {
        status = CartStatus.Success;
        SnackBarService.instance
            .showSnackBarSuccess((resBody['msg']).toString().trim());
        if (paymentState == 'success') CartHelper.clearCart();
        notifyListeners();
        return true;
      } else {
        status = CartStatus.Failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError((body['msg']));
        return false;
      }
    } else {
      status = CartStatus.Failed;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
      return false;
    }
    // } catch (e) {
    //   status = CartStatus.Failed;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    //   return false;
    // }
    return false;
  }

  Future<List<TableBookingOrderDetails>> getTableBookingOrderHistory(
      BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = CartStatus.Loading;
    notifyListeners();
    List<TableBookingOrderDetails> list = [];
    // try {
    UserModel userModel =
        UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var reqBody = FormData.fromMap({
      'cust_id': '${userModel.id} ',
    });
    Response response =
        await _dio.post(API.TableBookingOrderHistory, data: reqBody);
    log(reqBody.toString());
    var resBody = json.decode(response.data);
    if (response.statusCode == 200) {
      log('Response : ${response.data}');

      var body = resBody['body'] ?? [];

      if (resBody['status'] == "1" || resBody['status'] == 1) {
        status = CartStatus.Success;
        for (var history in body) {
          List<TableBookingMenuDetails>? menuDetails = [];
          var menuDetailsJson = history['menu-deails'] ?? [];
          for (var element in menuDetailsJson) {
            var foodJson = element['food'];
            TableBookingOrderFoodModel orderFoodModel =
                TableBookingOrderFoodModel(
              id: foodJson['id'],
              relid: foodJson['relid'],
              oid: foodJson['oid'],
              pro_id: foodJson['pro_id'],
              qty: foodJson['qty'],
              price: foodJson['price'],
              discountprice: foodJson['discountprice'],
              calculateprice: foodJson['calculateprice'],
              productname: foodJson['productname'],
              status: foodJson['status'],
              cust_id: foodJson['cust_id'],
              combooffer: foodJson['combooffer'],
              remark: foodJson['remark'],
              outletid: foodJson['outletid'],
              addrecordid: foodJson['addrecordid'],
              date: foodJson['date'],
              addons: foodJson['addons'],
              addonsfoodrelated: foodJson['addonsfoodrelated'],
              sequenceid: foodJson['sequenceid'],
              foodidrelatedaddons: foodJson['foodidrelatedaddons'],
              kotid: foodJson['kotid'],
              addonsrelation: foodJson['addonsrelation'],
              payment_id: foodJson['payment_id'],
              type: foodJson['type'],
              addonslebel: foodJson['addonslebel'],
              addonslebelid: foodJson['addonslebelid'],
              partypacks: foodJson['partypacks'],
              app: foodJson['app'],
            );
            TableBookingMenuDetails orderMenuDetails =
                TableBookingMenuDetails(food: orderFoodModel, addons: '');
            menuDetails.add(orderMenuDetails);
          }

          TableBookingOrderDetails bookingOrderDetails =
              TableBookingOrderDetails(
                  datetime: history['datetime'],
                  ordertype: history['ordertype'],
                  orderstatus: history['orderstatus'],
                  totalamount: history['totalamount'],
                  tableno: history['tableno'],
                  noguest: history['noguest'],
                  outletname: history['outletname'],
                  adddate: history['adddate'],
                  menuDetailsList: menuDetails);
          list.add(bookingOrderDetails);
        }

        notifyListeners();
      } else {
        status = CartStatus.Failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError('Something went wrong');
      }
    } else {
      status = CartStatus.Failed;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
    }
    // } catch (e) {
    //   status = CartStatus.Failed;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    // }
    return list;
  }

  Future<bool> placeEDiningOrder(
      CartVriablesModel cartVriablesModel,
      Map? payUMoneyResponse,
      PaymentParams paymentParam,
      String payUMoneyTxnId,
      String paymentState,
      BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return false;
    }
    status = CartStatus.Loading;
    notifyListeners();

    // try {
    OutletModel outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    UserModel userModel =
        UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var payload = {
      'cust_id': "${userModel.id.toString()}",
      'outletid': '${outletModel.outletId}',
      'response': '$paymentState',
      'responseDetials': payUMoneyResponse,
      'oid': '${userModel.id}${DateTime.now().millisecond}',
      'subtotal': '${CartHelper.getTotalPriceOfCart()}',
      'couponcode':
          '${cartVriablesModel.couponDiscountDetailModel?.coupon_code}',
      'actualdiscountvalue':
          '${CartHelper.getDiscountPrice(cartVriablesModel.couponDiscountDetailModel)}',
      'discountvalue':
          '${cartVriablesModel.couponDiscountDetailModel?.coupon_value}',
      'deliverycharge': '${cartVriablesModel.selectedPincode.charge}',
      'packingcharge': '${cartVriablesModel.allChargesModel!.Packing_Charge}',
      'gstpercentage': '${cartVriablesModel.allChargesModel!.gst}',
      'gstvalue':
          '${CartHelper.getServiceCharge(cartVriablesModel.allChargesModel).toStringAsFixed(2)}',
      'servicecharge': '${cartVriablesModel.allChargesModel!.Service_Charge}',
      'totalpaidamount': '${cartVriablesModel.netAmount}',
      'pay': 'payumoney',
      'transcation_id': '$payUMoneyTxnId',
      'ordertype': 'E-Dining',
      'address1': '',
      'address2': '',
      'landmark': '',
      'state': '',
      'city': '',
      'pincode': '${cartVriablesModel.selectedPincode.id}',
      'delivery_suggestion': '${cartVriablesModel.deliverySuggestion}',
      'delivery_instruction': '',
      'cart': CartHelper.getGroupedCartJson()
    };
    var reqBody = FormData.fromMap(payload);

    log(json.encode(payload));

    Response response = await _dio.post(API.PlaceOrder, data: payload);
    log('response : ' + response.data.toString());
    var resBody = json.decode(response.data);
    if (response.statusCode == 200) {
      print('Response : ${response.data}');
      var body = resBody['body'];
      if (resBody['status'] == 1) {
        status = CartStatus.Success;
        SnackBarService.instance
            .showSnackBarSuccess((resBody['msg']).toString().trim());
        if (paymentState == 'success') CartHelper.clearCart();
        notifyListeners();
        return true;
      } else {
        status = CartStatus.Failed;
        notifyListeners();
        SnackBarService.instance.showSnackBarError((body['msg']));
        return false;
      }
    } else {
      status = CartStatus.Failed;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
      return false;
    }
    // }
    // catch (e) {
    //   status = CartStatus.Failed;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    //   return false;
    // }
    return false;
  }
}
