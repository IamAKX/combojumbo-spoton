import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackBarService {
  late BuildContext _buildContext;
  static SnackBarService instance = SnackBarService();

  SnackBarService();

  set buildContext(BuildContext _context) {
    _buildContext = _context;
  }

  void showSnackBarError(String _message) {
    // ScaffoldMessenger.of(_buildContext).showSnackBar(
    //   SnackBar(
    //     duration: Duration(seconds: 2),
    //     content: Text(
    //       _message,
    //       style: TextStyle(color: Colors.white, fontSize: 15),
    //     ),
    //     backgroundColor: Colors.red,
    //   ),
    // );
    // showTopSnackBar(
    //   _buildContext,
    //   CustomSnackBar.error(
    //     message: _message,
    //   ),
    //   displayDuration: Duration(seconds: 1),
    // );
    Fluttertoast.showToast(
        msg: _message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showSnackBarInfo(String _message) {
    // ScaffoldMessenger.of(_buildContext).showSnackBar(
    //   SnackBar(
    //     duration: Duration(seconds: 2),
    //     content: Text(
    //       _message,
    //       style: TextStyle(color: Colors.white, fontSize: 15),
    //     ),
    //     backgroundColor: Colors.amber,
    //   ),
    // );
    // showTopSnackBar(
    //   _buildContext,
    //   CustomSnackBar.info(
    //     message: _message,
    //   ),
    //   displayDuration: Duration(seconds: 1),
    // );
    Fluttertoast.showToast(
        msg: _message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amber,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showSnackBarSuccess(String _message) {
    // ScaffoldMessenger.of(_buildContext).showSnackBar(
    //   SnackBar(
    //     duration: Duration(seconds: 2),
    //     content: Text(
    //       _message,
    //       style: TextStyle(color: Colors.white, fontSize: 15),
    //     ),
    //     backgroundColor: Colors.green,
    //   ),
    // );
    // showTopSnackBar(
    //   _buildContext,
    //   CustomSnackBar.success(
    //     message: _message,
    //   ),
    //   displayDuration: Duration(seconds: 1),
    // );
    Fluttertoast.showToast(
        msg: _message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
