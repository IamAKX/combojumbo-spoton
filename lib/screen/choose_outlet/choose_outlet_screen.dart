import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChooseOutletScreen extends StatefulWidget {
  const ChooseOutletScreen({Key? key}) : super(key: key);
  static const String CHOOSE_OUTLET_ROUTE = '/chooseOutlet';

  @override
  _ChooseOutletScreenState createState() => _ChooseOutletScreenState();
}

class _ChooseOutletScreenState extends State<ChooseOutletScreen> {
  late ProfileManagementService _profileManagementService;
  List<OutletModel> outletList = [];
  late OutletModel _selectedOutlet;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _profileManagementService.fetchAllOutlets(context).then(
        (value) {
          setState(() {
            outletList = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _profileManagementService = Provider.of<ProfileManagementService>(context);
    SnackBarService.instance.buildContext = context;
    if (prefs.getString(PrefernceKey.SELECTED_OUTLET) != null)
      _selectedOutlet =
          OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        actions: [
          InkWell(
            onTap: () {
              if (prefs.getString(PrefernceKey.SELECTED_OUTLET) != null)
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MainContainer.MAIN_CONTAINER_ROUTE, (route) => false,
                    arguments: 0);
              else
                SnackBarService.instance.showSnackBarError('Choose an outlet');
            },
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                'DONE',
                style: Theme.of(context)
                    .textTheme
                    .button
                    ?.copyWith(color: primaryColor),
              ),
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding * 3,
        ),
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: defaultPadding * 3),
            child: SvgPicture.asset(
              'assets/svg/location.svg',
              height: 300,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Hi, nice to meet you!',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: Colors.black),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Choose the Combo Jumbo Outlet',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: textColor),
            ),
          ),
          SizedBox(
            height: defaultPadding * 1.5,
          ),
          Card(
            elevation: 15,
            child: (prefs.getString(PrefernceKey.SELECTED_OUTLET) != null)
                ? ListTile(
                    minVerticalPadding: 1.0,
                    contentPadding: EdgeInsets.only(
                      left: 10,
                      bottom: 1,
                      top: 1,
                      right: 10,
                    ),
                    leading: CachedNetworkImage(
                      imageUrl:
                          "https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1567&q=80",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    dense: true,
                    title: Text('${_selectedOutlet.outletName}'),
                    subtitle: Text('${_selectedOutlet.outletId}'),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                    onTap: () {
                      _modalBottomSheetMenu();
                    },
                  )
                : ListTile(
                    title: Text('Tap to select an outlet'),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                    onTap: () {
                      _modalBottomSheetMenu();
                    },
                  ),
          )
        ],
      ),
    );
  }

  _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select outlet',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: textColor),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: outletList.length,
                itemBuilder: (context, index) {
                  OutletModel model = outletList.elementAt(index);
                  return ListTile(
                    minVerticalPadding: 1.0,
                    contentPadding: EdgeInsets.only(
                      left: 10,
                      bottom: 1,
                      top: 1,
                      right: 10,
                    ),
                    leading: CachedNetworkImage(
                      imageUrl:
                          "https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1567&q=80",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 80,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    dense: true,
                    title: Text('${model.outletName}'),
                    subtitle: Text('${model.outletId}'),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        prefs.setString(
                            PrefernceKey.SELECTED_OUTLET, model.toJson());
                      });
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}
