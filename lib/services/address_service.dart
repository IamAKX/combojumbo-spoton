import 'dart:convert';
import 'dart:developer';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/city_model.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/model/state_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/add_delivery_addres/address_model.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:universal_internet_checker/universal_internet_checker.dart';

enum AddressStatus {
  Loading,
  Success,
  Error,
  Ideal,
}

class AddressService extends ChangeNotifier {
  static AddressService instance = AddressService();
  late Dio _dio;
  AddressStatus? status = AddressStatus.Ideal;
  AddressService() {
    _dio = Dio();
  }

  Future<List<StateModel>> getStateList(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = AddressStatus.Loading;
    notifyListeners();
    List<StateModel> list = [];
    try {
      Response response = await _dio.post(API.State);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['data'];

        if (resBody['status'] == 1) {
          for (var s in body) {
            StateModel state = StateModel(
              id: s['id'],
              name: s['name'],
              country_id: s['country_id'],
            );
            list.add(state);
          }
          status = AddressStatus.Success;
          notifyListeners();
        } else {
          status = AddressStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
        }
      } else {
        status = AddressStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AddressStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
    return list;
  }

  Future<List<CityModel>> getCityList(
      StateModel state, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = AddressStatus.Loading;
    notifyListeners();
    List<CityModel> list = [];
    try {
      var reqBody = FormData.fromMap({'state_id': state.id});
      Response response = await _dio.post(API.City, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['data'];

        if (resBody['status'] == 1) {
          for (var c in body) {
            CityModel cityModel = CityModel(
              id: c['id'],
              name: c['name'],
              state_id: c['state_id'],
            );
            list.add(cityModel);
          }
          status = AddressStatus.Success;
          notifyListeners();
        } else {
          status = AddressStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
        }
      } else {
        status = AddressStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AddressStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
    return list;
  }

  Future<void> addAddress(AddressModel address, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    status = AddressStatus.Loading;
    notifyListeners();
    UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var reqBody = FormData.fromMap({
      'cust_id': '${user.id}',
      'add1': '${address.address1}',
      'add2': '${address.address2}',
      'landmark': '${address.landmark}',
      'state': '${address.stateModel.id}',
      'city': '${address.city.id}',
      'pincode': '${address.pincode}',
      'nickname': '${address.addressType}',
      'delivery_instruction': '${address.deliveryInstruction}',
    });
    try {
      Response response = await _dio.post(API.AddAddress, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        if (resBody['status'] == 1) {
          status = AddressStatus.Success;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess((resBody['msg']));
          Navigator.of(context).pop();
        } else {
          status = AddressStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
        }
      } else {
        status = AddressStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AddressStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<List<AddressModel>> getAllAddress(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = AddressStatus.Loading;
    notifyListeners();
    List<AddressModel> list = [];
    try {
      UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({'cust_id': '${user.id}'});
      Response response = await _dio.post(API.GetAddress, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          for (var a in body) {
            CityModel cityModel = CityModel(
              id: a['City']['city_id'],
              name: a['City']['city_name'],
              state_id: a['City']['state_id'],
            );
            StateModel stateModel = StateModel(
              id: a['State']['state_id'],
              name: a['State']['state_name'],
              country_id: a['State']['country_id'],
            );
            AddressModel addressModel = AddressModel(
              id: a['Id'],
              pincode: a['Pincode'],
              address1: a['Address 1'],
              address2: a['Address 2'],
              landmark: a['Landmark'],
              city: cityModel,
              stateModel: stateModel,
              deliveryInstruction: a['delivery_instruction'],
              addressType: a['Nickname'],
            );
            list.add(addressModel);
          }
          status = AddressStatus.Success;
          notifyListeners();
        } else {
          status = AddressStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
        }
      } else {
        status = AddressStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AddressStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
    return list;
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
    status = AddressStatus.Loading;
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
            PincodeModel model = PincodeModel(
                id: pincode['id'],
                pincode: pincode['pincode'],
                charge: pincode['charge'],
                status: pincode['status'],
                outletid: pincode['outletid'],
                location: pincode['location']);

            list.add(model);
          }
          status = AddressStatus.Success;
          notifyListeners();
        } else {
          status = AddressStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
        }
      } else {
        status = AddressStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AddressStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
    return list;
  }

  Future<bool> deleteAddress(AddressModel address, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return false;
    }
    status = AddressStatus.Loading;
    notifyListeners();
    UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var reqBody =
        FormData.fromMap({'id': '${address.id}', 'cust_id': '${user.id}'});
    try {
      Response response = await _dio.post(API.DeleteAddress, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        if (resBody['status'] == 1) {
          status = AddressStatus.Success;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess((resBody['msg']));
          return true;
        } else {
          status = AddressStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
          return false;
        }
      } else {
        status = AddressStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
        return false;
      }
    } catch (e) {
      status = AddressStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      return false;
    }
  }

  Future<void> updateAddress(AddressModel address, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    status = AddressStatus.Loading;
    notifyListeners();
    UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var reqBody = FormData.fromMap({
      'cust_id': '${user.id}',
      'id': '${address.id}',
      'add1': '${address.address1}',
      'add2': '${address.address2}',
      'landmark': '${address.landmark}',
      'state': '${address.stateModel.id}',
      'city': '${address.city.id}',
      'pincode': '${address.pincode}',
      'nickname': '${address.addressType}',
      'delivery_instruction': '${address.deliveryInstruction}',
    });
    var tem = {
      'cust_id': '${user.id}',
      'id': '${address.id}',
      'add1': '${address.address1}',
      'add2': '${address.address2}',
      'landmark': '${address.landmark}',
      'state': '${address.stateModel.id}',
      'city': '${address.city.id}',
      'pincode': '${address.pincode}',
      'nickname': '${address.addressType}',
      'delivery_instruction': '${address.deliveryInstruction}',
    };
    log(tem.toString());
    try {
      Response response = await _dio.post(API.UpdateAddress, data: reqBody);

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        if (resBody['status'] == 1) {
          status = AddressStatus.Success;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess((resBody['msg']));
        } else {
          status = AddressStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['msg']));
        }
      } else {
        status = AddressStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AddressStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }
}
