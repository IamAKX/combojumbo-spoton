import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/category_model.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/model/review_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/cart/cart_screen.dart';
import 'package:cjspoton/screen/delivery_pincode/delivery_pincode_screen.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/screen/search_page/search_page_screen.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/static_data.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:cjspoton/widgets/menu_item.dart';
import 'package:cjspoton/widgets/menu_subheading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

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
  List<FoodModel> favList = [];

  loadFavouriteFood() {
    setState(() {
      favList = Utilities().getAllFavouriteFood();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFavouriteFood();
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
                  Container(
                    child: Text(
                      '${_cat.categoryName.toWordCase()}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    width: 220,
                  ),
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 12,
                    child: Text(
                      '${_cat.foodcount}',
                      style: TextStyle(fontSize: 12, color: bgColor),
                    ),
                  ),
                ],
              ),
              value: '${_cat.id}'),
        },
        PopupMenuItem<String>(
            child: Row(
              children: [
                const Text('Reviews'),
              ],
            ),
            value: 'Reviews'),
      ],
      onSelected: (value) {
        switch (value.toString()) {
          case 'Reviews':
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
              Navigator.of(context)
                  .pushNamed(CartScreen.CART_ROUTE,
                      arguments: widget.menuScreenNavigatorPayloadModel
                          .refreshMainContainerState)
                  .then((value) => refreshState());
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
            onPressed: () {
              launch("tel://${Constants.OWNER_CONTACT_NUMBER}");
            },
            icon: Icon(Icons.call),
          ),
          IconButton(
            onPressed: () async {
              final link = WhatsAppUnilink(
                phoneNumber: '${Constants.OWNER_CONTACT_NUMBER}',
                text: "Hey!..",
              );
              // Convert the WhatsAppUnilink instance to a string.
              // Use either Dart's string interpolation or the toString() method.
              // The "launch" method is part of "url_launcher".
              await launch('$link');
            },
            icon: FaIcon(FontAwesomeIcons.whatsapp),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(
                    SearchPageScreen.SEARCH_SCREEN_ROUTE,
                    arguments: widget.menuScreenNavigatorPayloadModel,
                  )
                  .then((value) => refreshState());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainContainer.MAIN_CONTAINER_ROUTE, (route) => false,
              arguments: 0);
          return true;
        },
        child: SafeArea(
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
                      'CJ ${_outletModel.outletName} - Home Delivery',
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
                      favList: favList,
                      reloadFavList: loadFavouriteFood,
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
                  'Reviews',
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
                      'Based on 4 reviews',
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
                          '10.0',
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
                          '9.5',
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
                          '9.0',
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
                          '9.5',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              for (ReviewModel r in getReview()) ...{
                ReviewTile(
                  name: r.name,
                  review: r.review,
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key? key,
    required this.review,
    required this.name,
  }) : super(key: key);
  final String review;
  final String name;

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
            subtitle: Text('$name'),
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
              '$review',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
