import 'package:badges/badges.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/cart/cart_screen.dart';
import 'package:cjspoton/screen/choose_outlet/choose_outlet_screen.dart';
import 'package:cjspoton/screen/cj_spoton/cj_spoton_table_booking_screen.dart';
import 'package:cjspoton/screen/comming_soon/comming_soon_screen.dart';
import 'package:cjspoton/screen/delivery_pincode/delivery_pincode_screen.dart';
import 'package:cjspoton/screen/favourite/favourite_screen.dart';
import 'package:cjspoton/screen/home/home_screen.dart';
import 'package:cjspoton/screen/ios_login_needed/ios_login_needed.dart';
import 'package:cjspoton/screen/order/order_screen.dart';
import 'package:cjspoton/screen/profile/profile_screen.dart';
import 'package:cjspoton/screen/search_page/search_page_screen.dart';
import 'package:cjspoton/screen/table_booking/table_booking_history/table_booking_history.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({Key? key, required this.initialIndex}) : super(key: key);
  static const String MAIN_CONTAINER_ROUTE = '/mainContainer';
  static late ProfileManagementService profileManagementService;
  final int initialIndex;

  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  late int _selectedIndex;
  TextEditingController _searchCtrl = TextEditingController();
  late PincodeModel _pincodeModel;
  late CatalogService _catalogService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _catalogService = Provider.of<CatalogService>(context);

    _pincodeModel = Constants.getDefaultPincode();
    MainContainer.profileManagementService =
        Provider.of<ProfileManagementService>(context);
    return Scaffold(
        extendBody: true,
        backgroundColor: greyedBgColor,
        appBar: getAppBar(),
        bottomNavigationBar: FloatingNavbar(
          elevation: 80,
          margin: EdgeInsets.all(defaultPadding),
          backgroundColor: bgColor,
          padding: EdgeInsets.zero,
          fontSize: 10,
          borderRadius: 0,
          selectedBackgroundColor: Colors.transparent,
          selectedItemColor: primaryColor,
          unselectedItemColor: textColor,
          onTap: (int val) => setState(() => _selectedIndex = val),
          currentIndex: _selectedIndex,
          items: [
            FloatingNavbarItem(
              icon: Icons.home_outlined,
              title: 'Home',
            ),
            FloatingNavbarItem(
              icon: Icons.history,
              title: 'Orders',
            ),
            FloatingNavbarItem(
              customWidget: Image.asset(
                'assets/images/cjspoton.png',
              ),
            ),
            FloatingNavbarItem(
              icon: Icons.favorite_border_outlined,
              title: 'CJ Fav',
            ),
            FloatingNavbarItem(
              icon: Icons.person_outline,
              title: 'Profile',
            ),
          ],
        ),
        body: WillPopScope(
          child: getBody(),
          onWillPop: () async {
            if (_selectedIndex != 0) {
              setState(() {
                _selectedIndex = 0;
              });
              return false;
            } else {
              return true;
            }
          },
        ));
  }

  getBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(refreshState);
      case 1:
        return OrderScreen();
      case 2:
        return CommingSoonScreen(
            menuScreenNavigatorPayloadModel: MenuScreenNavigatorPayloadModel(
                refreshMainContainerState: refreshState, categoryId: "0"));
      // return CJSpotOnTableBookingScreen(refreshState);
      case 3:
        return FavouriteScreen(
          refreshMainContainerState: refreshState,
        );
      case 4:
        return ProfileScreen();
    }
  }

  getAppBar() {
    switch (_selectedIndex) {
      case 0:
        return AppBar(
          toolbarHeight: 120,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.pin_drop_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(
                              DeliverPincodeScreen.DELIVERY_PINCODE_ROUTE)
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        '${_pincodeModel.location}',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dashed,
                          decorationColor: hintColor,
                          decorationThickness: 1,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(ChooseOutletScreen.CHOOSE_OUTLET_ROUTE),
                    icon: Icon(Icons.business_outlined),
                  ),
                  GetCartButton(
                    refreshState: refreshState,
                  ),
                ],
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed(
                  SearchPageScreen.SEARCH_SCREEN_ROUTE,
                  arguments: MenuScreenNavigatorPayloadModel(
                      refreshMainContainerState: refreshState, categoryId: "0"),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          Icons.search,
                          color: primaryColor,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          autocorrect: true,
                          controller: _searchCtrl,
                          enabled: false,
                          decoration: InputDecoration(
                              hintText: 'Search for dishes',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: hintColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
          backgroundColor: bgColor,
          centerTitle: false,
        );
      case 1:
        return AppBar(
          title: Text('My Orders'),
          backgroundColor: bgColor,
          centerTitle: false,
          actions: [
            GetCartButton(
              refreshState: refreshState,
            ),
            IconButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(TableBookingScreens.TABLE_BOOKING_HISTORY_ROUTE),
              icon: Image.asset(
                'assets/images/outline_table_bar_1.png',
              ),
            ),
          ],
        );
      case 2:
        return AppBar(
          title: Text('CJ SpotOn - Book Table'),
          backgroundColor: bgColor,
          centerTitle: false,
          actions: [
            GetCartButton(
              refreshState: refreshState,
            ),
          ],
        );
      case 3:
        return AppBar(
          title: Text('CJ Fav'),
          backgroundColor: bgColor,
          centerTitle: false,
          actions: [
            GetCartButton(
              refreshState: refreshState,
            ),
          ],
        );
      case 4:
        return AppBar(
          title: Text('Profile'),
          backgroundColor: bgColor,
          centerTitle: false,
          actions: [
            GetCartButton(
              refreshState: refreshState,
            ),
          ],
        );
    }
  }
}

// void configureFCM() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     NotificationApi.showNotification(
//         id: message.hashCode,
//         body: message.notification!.body,
//         title: message.notification!.title,
//         payload: message.data.toString());
//   });

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print('onMessageOpenedApp');
//   });
// }

class GetCartButton extends StatelessWidget {
  const GetCartButton({
    Key? key,
    required this.refreshState,
  }) : super(key: key);
  final Function() refreshState;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (prefs.getString(PrefernceKey.USER)!.isEmpty)
          Navigator.of(context)
              .pushNamed(IOSLoginNeeded.IOS_LOGIN_NEEDED_ROUTE);
        else
          Navigator.of(context)
              .pushNamed(CartScreen.CART_ROUTE, arguments: refreshState);
      },
      icon: CartHelper.getCartCount() == 0
          ? Icon(
              Icons.shopping_bag_outlined,
            )
          : Badge(
              badgeColor: primaryColor,
              badgeContent: Text(
                '${CartHelper.getCartCount()}',
              ),
              animationType: BadgeAnimationType.scale,
              child: Icon(
                Icons.shopping_bag_outlined,
              ),
            ),
    );
  }
}
