import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliverPincodeScreen extends StatefulWidget {
  const DeliverPincodeScreen({Key? key}) : super(key: key);
  static const String DELIVERY_PINCODE_ROUTE = '/deliveryPincode';

  @override
  _DeliverPincodeScreenState createState() => _DeliverPincodeScreenState();
}

class _DeliverPincodeScreenState extends State<DeliverPincodeScreen> {
  late CartServices _cartServices;
  List<PincodeModel> pincodeList = [];
  PincodeModel selectedPincode = Constants.getDefaultPincode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _cartServices.fetchAllPincodes(context).then(
        (value) {
          setState(() {
            pincodeList = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _cartServices = Provider.of<CartServices>(context);
    SnackBarService.instance.buildContext = context;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Text('Delivery Area'),
          centerTitle: false,
        ),
        body: pincodeList.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: pincodeList.length,
                itemBuilder: (context, index) {
                  PincodeModel model = pincodeList.elementAt(index);
                  return RadioListTile(
                    title: Text(model.location),
                    subtitle: Text(model.pincode),
                    value: model,
                    groupValue: selectedPincode,
                    onChanged: (value) {
                      setState(() {
                        selectedPincode = value as PincodeModel;
                        prefs.setString(PrefernceKey.SELECTED_PINCODE,
                            selectedPincode.toJson());
                      });
                    },
                  );
                },
              ));
  }
}
