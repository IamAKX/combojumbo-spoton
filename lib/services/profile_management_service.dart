import 'dart:convert';
import 'dart:io';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum ProfileStatus {
  Ideal,
  Loading,
  Success,
  Failed,
}

class ProfileManagementService extends ChangeNotifier {
  static ProfileManagementService instance = ProfileManagementService();
  late Dio _dio;
  ProfileStatus? status = ProfileStatus.Ideal;

  ProfileManagementService() {
    _dio = Dio();
  }

  Future<void> fetchProfile(BuildContext context) async {
    status = ProfileStatus.Ideal;
    notifyListeners();

    try {
      UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({
        'cust_id': user.id,
      });

      Response response = await _dio.post(
        API.Profile,
        data: reqBody,
      );
      print('Request : ${reqBody.fields}');
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          user.name = body['name'] ?? '';
          user.email = body['email'] ?? '';
          user.phone = body['contact'] ?? '';
          user.profileImage = body['image'] ?? '';
          prefs.setString(PrefernceKey.USER, user.toJson());
          status = ProfileStatus.Success;
          notifyListeners();
        } else {
          status = ProfileStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = ProfileStatus.Failed;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = ProfileStatus.Failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<List<OutletModel>> fetchAllOutlets(BuildContext context) async {
    status = ProfileStatus.Ideal;
    notifyListeners();
    List<OutletModel> list = [];
    try {
      Response response = await _dio.post(
        API.Outlets,
      );

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          for (var outlet in body) {
            OutletModel outletModel = OutletModel(
                outletId: outlet['OutletId'], outletName: outlet['OutletName']);
            list.add(outletModel);
          }
          status = ProfileStatus.Success;
          notifyListeners();
        } else {
          status = ProfileStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = ProfileStatus.Failed;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = ProfileStatus.Failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
    return list;
  }

  Future<void> updateProfile(String name, String email, String phone,
      File? image, BuildContext context) async {
    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      SnackBarService.instance.showSnackBarError('All fields are mandatory');
      return;
    }

    if (!Utilities().isValidEmail(email)) {
      SnackBarService.instance.showSnackBarError('Invalid Email');
      return;
    }
    if (!Utilities().isValidEmail(email)) {
      SnackBarService.instance.showSnackBarError('Invalid phone');
      return;
    }

    status = ProfileStatus.Loading;
    notifyListeners();
    UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    var reqBody = FormData.fromMap({
      'cust_id': user.id,
      'name': name,
      'contact': phone,
      'email': email,
      if (image != null)
        'image': await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last),
    });
    try {
      Response response = await _dio.post(
        API.UpdateProfile,
        data: reqBody,
      );

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          status = ProfileStatus.Success;

          user.email = email;
          user.phone = phone;
          user.name = name;
          user.profileImage = body['image'];

          prefs.setString(PrefernceKey.USER, user.toJson());

          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess((body['msg']));
        } else {
          status = ProfileStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = ProfileStatus.Failed;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = ProfileStatus.Failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }
}
