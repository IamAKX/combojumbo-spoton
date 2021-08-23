import 'package:cjspoton/profile/profile_screen.dart';
import 'package:cjspoton/screen/cart/cart_screen.dart';
import 'package:cjspoton/screen/choose_outlet/choose_outlet_screen.dart';
import 'package:cjspoton/screen/favourite/favourite_screen.dart';
import 'package:cjspoton/screen/home/home_screen.dart';
import 'package:cjspoton/screen/order/order_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({Key? key}) : super(key: key);
  static const String MAIN_CONTAINER_ROUTE = '/mainContainer';

  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;
  TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: greyedBgColor,
      appBar: getAppBar(),
      bottomNavigationBar: FloatingNavbar(
        elevation: 80,
        margin: EdgeInsets.all(defaultPadding),
        backgroundColor: bgColor,
        selectedBackgroundColor: Colors.transparent,
        selectedItemColor: primaryColor,
        unselectedItemColor: textColor,
        onTap: (int val) => setState(() => _selectedIndex = val),
        currentIndex: _selectedIndex,
        items: [
          FloatingNavbarItem(icon: Icons.home_outlined, title: 'Home'),
          FloatingNavbarItem(icon: Icons.history, title: 'Orders'),
          FloatingNavbarItem(
              icon: Icons.bookmark_border_outlined, title: 'Favourite'),
          FloatingNavbarItem(icon: Icons.person_outline, title: 'Profile'),
        ],
      ),
      body: getBody(),
    );
  }

  getBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return OrderScreen();
      case 2:
        return FavouriteScreen();
      case 3:
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
                  Text(
                    'Pune, Maharastra',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dashed,
                      decorationColor: hintColor,
                      decorationThickness: 1,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(ChooseOutletScreen.CHOOSE_OUTLET_ROUTE),
                    icon: Icon(Icons.business_outlined),
                  ),
                  GetCartButton(),
                ],
              ),
              Container(
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
              )
            ],
          ),
          backgroundColor: bgColor,
          centerTitle: false,
        );
      case 1:
        return AppBar(
          title: Text('Order'),
          backgroundColor: bgColor,
          centerTitle: false,
          actions: [
            GetCartButton(),
          ],
        );
      case 2:
        return AppBar(
          title: Text('Favourite'),
          backgroundColor: bgColor,
          centerTitle: false,
          actions: [
            GetCartButton(),
          ],
        );
      case 3:
        return AppBar(
          title: Text('Profile'),
          backgroundColor: bgColor,
          centerTitle: false,
          actions: [
            GetCartButton(),
          ],
        );
    }
  }
}

class GetCartButton extends StatelessWidget {
  const GetCartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(CartScreen.CART_ROUTE);
      },
      icon: Icon(
        Icons.shopping_bag_outlined,
      ),
    );
  }
}
