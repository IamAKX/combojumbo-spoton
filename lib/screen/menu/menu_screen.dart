import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/category_model.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/cart/cart_screen.dart';
import 'package:cjspoton/screen/delivery_pincode/delivery_pincode_screen.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/menu_item.dart';
import 'package:cjspoton/widgets/menu_subheading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    Key? key,
    required this.menuScreenNavigatorPayloadModel,
  }) : super(key: key);
  static const String MENU_SCREEN_ROUTE = '/menuScreen';
  // final Function() refreshMainContainerState;
  final MenuScreenNavigatorPayloadModel menuScreenNavigatorPayloadModel;

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final GlobalKey _menuKey = new GlobalKey();
  ScrollController _scrollController = ScrollController();
  late OutletModel _outletModel;
  late CatalogService _catalogService;
  List<CategoryModel> list = [];
  late PincodeModel _pincodeModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _outletModel =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _catalogService.fetchAllFoodItem(context).then(
        (value) {
          setState(() {
            list = value;
            if (widget.menuScreenNavigatorPayloadModel.categoryId != '0') {
              int height = 1;
              for (CategoryModel cat in list) {
                if (widget.menuScreenNavigatorPayloadModel.categoryId == cat.id)
                  break;
                height += cat.foodList.length + 1;
              }
              _scrollToIndex(height);
            }
          });
        },
      ),
    );
  }

  refreshState() {
    widget.menuScreenNavigatorPayloadModel.refreshMainContainerState();
    setState(() {});
  }

  void _scrollToIndex(index) {
    // _scrollController.animateTo(100.0 * index,
    //     duration: Duration(seconds: 1), curve: Curves.easeIn);
    _scrollController.jumpTo(index * 100.0);
  }

  @override
  Widget build(BuildContext context) {
    _pincodeModel = Constants.getDefaultPincode();
    _catalogService = Provider.of<CatalogService>(context);
    SnackBarService.instance.buildContext = context;
    final button = new PopupMenuButton(
      key: _menuKey,
      icon: Icon(
        Icons.list,
        color: bgColor,
      ),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        for (CategoryModel _cat in list) ...{
          PopupMenuItem<String>(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_cat.categoryName.toCamelCase()}'),
                  CircleAvatar(
                    radius: 12,
                    child: Text(
                      '${_cat.foodcount}',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              value: '${_cat.id}'),
        },
        PopupMenuItem<String>(
            child: Row(
              children: [
                const Text('Review'),
              ],
            ),
            value: 'Review'),
      ],
      onSelected: (value) {
        switch (value.toString()) {
          case 'Review':
            int height = 1;
            for (CategoryModel cat in list) {
              height += cat.foodList.length + 1;
            }
            _scrollToIndex(height);
            break;
          default:
            int height = 1;
            for (CategoryModel cat in list) {
              if (value == cat.id) break;
              height += cat.foodList.length + 1;
            }
            _scrollToIndex(height);
            break;
        }
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dynamic state = _menuKey.currentState;
          state.showButtonMenu();
        },
        // child: Icon(
        //   Icons.list,
        //   color: bgColor,
        // ),
        child: button,
      ),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: bgColor),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.CART_ROUTE,
                  arguments: widget.menuScreenNavigatorPayloadModel
                      .refreshMainContainerState);
            },
            icon: CartHelper.getCartCount() == 0
                ? Icon(
                    Icons.shopping_bag_outlined,
                  )
                : Badge(
                    badgeColor: Colors.white,
                    badgeContent: Text(
                      '${CartHelper.getCartCount()}',
                    ),
                    animationType: BadgeAnimationType.scale,
                    child: Icon(
                      Icons.shopping_bag_outlined,
                    ),
                  ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.whatsapp),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.all(defaultPadding),
              color: primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_outletModel.outletName} - Home Delivery',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: bgColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Delivering to ${_pincodeModel.pincode} - ${_pincodeModel.location}',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: bgColor,
                          fontWeight: FontWeight.bold,
                        ),
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
                    child: Text(
                      'Change PIN code',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: bgColor,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding * 2,
            ),
            if (_catalogService.status != CatalogStatus.Success)
              Container(
                height: 500,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            else
              for (CategoryModel category in list) ...{
                MenuSubheading(
                  itemCount: '${category.foodcount.trim()}',
                  title: '${category.categoryName.trim()}',
                ),
                for (FoodModel food in category.foodList) ...{
                  MenuItem(
                    title: '${food.foodname.trim()}',
                    subTitle: '${food.fooddescription.trim()}',
                    amount: '${food.foodamount.trim()}',
                    imageUrl: '${food.foodImage.trim()}',
                    parentContext: context,
                    foodModel: food,
                    refreshState: refreshState,
                  ),
                },
                SizedBox(
                  height: defaultPadding * 2,
                ),
              },
            SizedBox(
              height: defaultPadding,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              child: Text(
                'Review',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultPadding),
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Color(0xff65CC66),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Text(
                    '9.5',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: bgColor,
                          height: 0.9,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Superb',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: bgColor,
                        ),
                  ),
                  Text(
                    'Based on 4 review',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: bgColor,
                        ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Food Quality',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.9,
                          color: Color(0xff65CC66),
                          backgroundColor: hintColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        '9.0',
                        style:
                            Theme.of(context).textTheme.subtitle1?.copyWith(),
                      ),
                    ],
                  ),
                  Text(
                    'Punctuality',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.8,
                          color: Color(0xff65CC66),
                          backgroundColor: hintColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        '8.0',
                        style:
                            Theme.of(context).textTheme.subtitle1?.copyWith(),
                      ),
                    ],
                  ),
                  Text(
                    'Service',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.95,
                          color: Color(0xff65CC66),
                          backgroundColor: hintColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        '9.5',
                        style:
                            Theme.of(context).textTheme.subtitle1?.copyWith(),
                      ),
                    ],
                  ),
                  Text(
                    'Price',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.85,
                          color: Color(0xff65CC66),
                          backgroundColor: hintColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        '8.5',
                        style:
                            Theme.of(context).textTheme.subtitle1?.copyWith(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            for (var i = 0; i < 4; i++) ...{
              ReviewTile(),
            }
          ],
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: hintColor),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                imageUrl: 'https://www.combojumbo.in/img/avatar4.jpg',
                width: 40,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            title: RichText(
              text: TextSpan(
                text: '9.5 ',
                style: TextStyle(
                  color: Color(0xff65CC66),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: '/10',
                    style: TextStyle(
                      color: Color(0xff65CC66),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: ' Rating average',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Text('Yashraj Thakkar'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              'A worthy Joint to visit repeatedly!!',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              bottom: defaultPadding,
            ),
            child: Text(
              'Very Nice Food, Unique Ambience, excellent staff. The price points are less as compared to other establishments in the area. The staff was very accommodative and attentive to ensure good experience. A lot of different cuisines are available with good quality food. Oriental sizzlers, Manchow soup and Lazeez Dum Birayni were sumptuous. The place is also available as a Banquet too.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
