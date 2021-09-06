import 'dart:convert';

import 'package:cjspoton/model/city_model.dart';
import 'package:cjspoton/model/state_model.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
}
