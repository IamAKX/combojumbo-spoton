import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/faq/faq_model.dart';
import 'package:cjspoton/screen/image_gallery/image_gallery_model.dart';
import 'package:cjspoton/screen/video_gallery/video_gallery_model.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:universal_internet_checker/universal_internet_checker.dart';

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
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return null;
    }
    status = ProfileStatus.Loading;
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
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
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
                outletId: outlet['OutletId'],
                outletName: outlet['OutletName'],
                address: outlet['Address'],
                image: outlet['Image']);
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
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return null;
    }
    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      SnackBarService.instance.showSnackBarError('All fields are mandatory');
      return;
    }

    if (!Utilities().isValidEmail(email)) {
      SnackBarService.instance.showSnackBarError('Invalid Email');
      return;
    }
    if (!Utilities().isValidPhone(phone)) {
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
        'aimage': await MultipartFile.fromFile(image.path,
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
          status = ProfileStatus.Success;
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

  Future<void> sendFeedback(String name, String email, String phone,
      String feedback, BuildContext context, File? image) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return null;
    }
    if (name.isEmpty || email.isEmpty || phone.isEmpty || feedback.isEmpty) {
      SnackBarService.instance.showSnackBarError('All fields are mandatory');
      return;
    }

    if (!Utilities().isValidEmail(email)) {
      SnackBarService.instance.showSnackBarError('Invalid Email');
      return;
    }
    if (!Utilities().isValidPhone(phone)) {
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
      'type': 'Report',
      'message': feedback,
      'aimage': (image != null)
          ? await MultipartFile.fromFile(image.path,
              filename: image.path.split('/').last)
          : '',
    });

    try {
      Response response = await _dio.post(
        API.Feedback,
        data: reqBody,
      );

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        if (resBody['status'] == 1) {
          status = ProfileStatus.Success;
          notifyListeners();
          SnackBarService.instance
              .showSnackBarSuccess((resBody['body']['msg']));
          Navigator.of(context).pop();
        } else {
          status = ProfileStatus.Failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((resBody['body']['msg']));
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

  Future<List<ImageGalleryModel>> fetchImageGallery(
      BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = ProfileStatus.Ideal;
    notifyListeners();
    List<ImageGalleryModel> list = [];
    try {
      Response response = await _dio.post(
        API.ImageGallery,
      );

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['data'];

        if (resBody['status'] == "1") {
          for (var item in body) {
            ImageGalleryModel model =
                ImageGalleryModel(image: item['image'], title: item['title']);
            list.add(model);
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

  Future<List<VideoGalleryModel>> fetchVideoGallery(
      BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = ProfileStatus.Ideal;
    notifyListeners();
    List<VideoGalleryModel> list = [];
    try {
      Response response = await _dio.post(
        API.VideoGallery,
      );

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['data'];

        if (resBody['status'] == "1") {
          for (var item in body) {
            VideoGalleryModel model =
                VideoGalleryModel(image: item['image'], link: item['link']);
            list.add(model);
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

  Future<List<FAQModel>> fetchFAQ(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return [];
    }
    status = ProfileStatus.Ideal;
    notifyListeners();
    List<FAQModel> list = [];
    try {
      Response response = await _dio.post(
        API.FAQ,
      );

      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['data'];

        if (resBody['status'] == "1") {
          for (var item in body) {
            FAQModel model = FAQModel.fromMap(item);
            list.add(model);
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
}
