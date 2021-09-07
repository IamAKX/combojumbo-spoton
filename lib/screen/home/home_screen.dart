import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cjspoton/model/category_model.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/home/home_widgets.dart';
import 'package:cjspoton/screen/menu/menu_screen.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/static_data.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:cjspoton/widgets/cart_buttons.dart';
import 'package:cjspoton/widgets/subheading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.refreshMainContainerState) : super();
  final Function() refreshMainContainerState;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size screenSize;
  late CatalogService _catalogService;
  List<CategoryModel> list = [];
  List<FoodModel> favList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFavouriteFood();

    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _catalogService.fetchAllFoodItem(context).then(
        (value) {
          setState(() {
            list = value;
          });
        },
      ),
    );
  }

  loadFavouriteFood() {
    setState(() {
      favList = Utilities().getAllFavouriteFood();
    });
  }

  refreshState() {
    widget.refreshMainContainerState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _catalogService = Provider.of<CatalogService>(context);
    SnackBarService.instance.buildContext = context;
    screenSize = MediaQuery.of(context).size;
    return list.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 120,
                width: double.infinity,
                child: CarouselSlider(
                  items: getCJRouteOptions()
                      .map(
                        (cjRouteModel) => InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              cjRouteModel.redirectionUrl,
                              arguments: MenuScreenNavigatorPayloadModel(
                                categoryId: "0",
                                refreshMainContainerState:
                                    widget.refreshMainContainerState,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      primaryColor.withOpacity(0.1),
                                  child: CachedNetworkImage(
                                    imageUrl: cjRouteModel.image,
                                    width: 30,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                cjRouteModel.name,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    height: 110,
                    initialPage: 0,
                    viewportFraction: 0.25,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: hintColor,
              ),
              SubHeading(
                title: 'Category',
                context: context,
                routePath: MenuScreen.MENU_SCREEN_ROUTE,
                menuScreenNavigatorPayloadModel:
                    MenuScreenNavigatorPayloadModel(
                  categoryId: "0",
                  refreshMainContainerState: widget.refreshMainContainerState,
                ),
                refreshState: refreshState,
              ),
              Container(
                height: (screenSize.width * 0.65),
                width: screenSize.width * 0.7,
                child: _catalogService.status == CatalogStatus.Loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: list.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => CategoryCard(
                          screenSize: screenSize,
                          categoryModel: list.elementAt(index),
                          refreshMainContainerState:
                              widget.refreshMainContainerState,
                        ),
                      ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Divider(
                height: 1,
                color: hintColor,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                child: CarouselSlider(
                  items: [
                    Container(
                      height: 250,
                      width: 200,
                      padding: EdgeInsets.only(
                        left: defaultPadding,
                        top: defaultPadding,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          end: Alignment.topLeft,
                          begin: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xff5748CF),
                            Color(0xff696ECF),
                            Color(0xff8399DA)
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'the best',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 35,
                                    height: 0.8),
                          ),
                          Text(
                            'offers',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: Colors.white,
                                      fontSize: 25,
                                      height: 0.9,
                                    ),
                          ),
                          Text(
                            'at the best restaurant',
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          Spacer(),
                          Container(
                            height: 130,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: -10,
                                  right: -10,
                                  child: SvgPicture.asset(
                                    'assets/svg/landing2.svg',
                                    height: 130,
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 0,
                                  child: CircleAvatar(
                                    backgroundColor: bgColor,
                                    radius: 20,
                                    child: Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 30,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                  options: CarouselOptions(
                    height: 250,
                    initialPage: 0,
                    viewportFraction: 0.5,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Divider(
                height: 1,
                color: hintColor,
              ),
              SubHeading(
                title: 'Recommended',
                context: context,
                routePath: MenuScreen.MENU_SCREEN_ROUTE,
                menuScreenNavigatorPayloadModel:
                    MenuScreenNavigatorPayloadModel(
                  categoryId: "0",
                  refreshMainContainerState: widget.refreshMainContainerState,
                ),
                refreshState: refreshState,
              ),
              RecomendedItems(
                  screenSize: screenSize,
                  list: list,
                  favList: favList,
                  reloadFavList: loadFavouriteFood,
                  refreshState: refreshState),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding / 2),
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        'https://askbootstrap.com/preview/swiggi/template2/img/banner.png',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SubHeading(
                title: 'Combos',
                context: context,
                routePath: MenuScreen.MENU_SCREEN_ROUTE,
                menuScreenNavigatorPayloadModel:
                    MenuScreenNavigatorPayloadModel(
                  categoryId: "0",
                  refreshMainContainerState: widget.refreshMainContainerState,
                ),
                refreshState: refreshState,
              ),
              for (int i = 0; i < 4; i++) ...{
                Container(
                  width: double.infinity,
                  color: bgColor,
                  margin: EdgeInsets.only(
                    left: defaultPadding / 2,
                    right: defaultPadding / 2,
                    bottom: defaultPadding,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Row(
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                                imageUrl:
                                    '${list.elementAt(2).foodList.elementAt(i).foodImage}',
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress)),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: textColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.whatshot,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '8.02 off',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${list.elementAt(2).foodList.elementAt(i).foodname}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '${list.elementAt(2).foodList.elementAt(i).fooddescription}',
                                  style: Theme.of(context).textTheme.caption,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ' ₹ ${list.elementAt(2).foodList.elementAt(i).foodamount} ',
                                        ),
                                        Text(
                                          ' ₹ ${int.parse(list.elementAt(2).foodList.elementAt(i).foodamount) + 100}',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    (CartHelper.getItemCountInCart(
                                                CartHelper.transformFoodModel(
                                                    list
                                                        .elementAt(2)
                                                        .foodList
                                                        .elementAt(i))) ==
                                            0)
                                        ? CartButton().getCartButtonSimple(
                                            context,
                                            list
                                                .elementAt(2)
                                                .foodList
                                                .elementAt(i),
                                            refreshState)
                                        : CartButton().getCartButtonComplex(
                                            context,
                                            list
                                                .elementAt(2)
                                                .foodList
                                                .elementAt(i),
                                            refreshState)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              }
            ],
          );
  }
}
