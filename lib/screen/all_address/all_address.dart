import 'package:cjspoton/screen/add_delivery_addres/add_delivery_address_screen.dart';
import 'package:cjspoton/screen/add_delivery_addres/address_model.dart';
import 'package:cjspoton/screen/update_address/update_delivery_address_screen.dart';
import 'package:cjspoton/services/address_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AllAddressScreen extends StatefulWidget {
  const AllAddressScreen({Key? key}) : super(key: key);
  static const String ALL_ADDRESS_ROUTE = '/allAddress';

  @override
  _AllAddressScreenState createState() => _AllAddressScreenState();
}

class _AllAddressScreenState extends State<AllAddressScreen> {
  late AddressService _addressService;
  List<AddressModel> addressList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => reloadAddressList(context));
  }

  reloadAddressList(BuildContext context) {
    _addressService.getAllAddress(context).then(
      (value) {
        setState(() {
          addressList = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _addressService = Provider.of<AddressService>(context);
    SnackBarService.instance.buildContext = context;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('My Address'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(AddDeliveryAddress.ADD_DELIVERY_ADDRESS_ROUTE)
                .then((value) => reloadAddressList(context)),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: _addressService.status == AddressStatus.Loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : addressList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/add_address.svg',
                        width: 300,
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          'Please add your address',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: addressList.length,
                  itemBuilder: (context, index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        tileColor: bgColor,
                        isThreeLine: true,
                        leading: getAddressIcon(
                            addressList.elementAt(index).addressType),
                        title: Text(
                          '${addressList.elementAt(index).address1}',
                          maxLines: 1,
                        ),
                        onTap: () => Navigator.of(context)
                            .pushNamed(
                              UpdateDeliveryAddress
                                  .UPDATE_DELIVERY_ADDRESS_ROUTE,
                              arguments: addressList.elementAt(index),
                            )
                            .then(
                              (value) => reloadAddressList(
                                context,
                              ),
                            ),
                        trailing: IconButton(
                          onPressed: () async {
                            await _addressService.deleteAddress(
                                addressList.elementAt(index), context);
                            reloadAddressList(context);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        subtitle: Text(
                            '${addressList.elementAt(index).city.name}, ${addressList.elementAt(index).stateModel.name}\n${addressList.elementAt(index).pincode}'),
                      ),
                      Divider(
                        color: borderColor,
                        height: 1,
                        indent: 70,
                        endIndent: 10,
                      )
                    ],
                  ),
                ),
    );
  }

  getAddressIcon(String addressType) {
    switch (addressType) {
      case 'HOME':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(
              color: primaryColor,
              width: 1.0,
            ),
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: categoryBackground,
            child: Icon(
              Icons.home_outlined,
              color: primaryColor,
              size: 30,
            ),
          ),
        );
      case 'WORK':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(
              color: primaryColor,
              width: 1.0,
            ),
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: categoryBackground,
            child: Icon(
              Icons.work_outline,
              color: primaryColor,
              size: 30,
            ),
          ),
        );
      case 'OTHER':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(
              color: primaryColor,
              width: 1.0,
            ),
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: categoryBackground,
            child: Icon(
              Icons.pin_drop_outlined,
              color: primaryColor,
              size: 30,
            ),
          ),
        );
      default:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(
              color: primaryColor,
              width: 1.0,
            ),
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: categoryBackground,
            child: Icon(
              Icons.pin_drop_outlined,
              color: primaryColor,
              size: 30,
            ),
          ),
        );
    }
  }
}
