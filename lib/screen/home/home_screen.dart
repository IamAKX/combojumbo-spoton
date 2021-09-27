import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cjspoton/model/add_slider_model.dart';
import 'package:cjspoton/model/category_model.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/comming_soon/comming_soon_screen.dart';
import 'package:cjspoton/screen/home/home_widgets.dart';
import 'package:cjspoton/screen/menu/menu_screen.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/static_data.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:cjspoton/widgets/cart_buttons.dart';
import 'package:cjspoton/widgets/subheading.dart';
import 'package:cjspoton/widgets/webview_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

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
  late CategoryModel combocategory;

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
            if (list.any((element) => element.id == '38'))
              combocategory = list.firstWhere((element) => element.id == '38');
            else
              combocategory = list.first;
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
                                  backgroundColor: categoryBackground,
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
                height: (screenSize.width * 0.67),
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
                    for (AddSliderCardModel model in getAdSlider()) ...{
                      InkWell(
                        onTap: () {
                          switch (model.redirection) {
                            case MenuScreen.MENU_SCREEN_ROUTE:
                              Navigator.of(context).pushNamed(
                                MenuScreen.MENU_SCREEN_ROUTE,
                                arguments: MenuScreenNavigatorPayloadModel(
                                  categoryId: "${model.arguments}",
                                  refreshMainContainerState:
                                      widget.refreshMainContainerState,
                                ),
                              );
                              return;
                            case WebviewInternal.WEBVIEW_ROUTE:
                              Navigator.of(context).pushNamed(
                                WebviewInternal.WEBVIEW_ROUTE,
                                arguments: model.arguments,
                              );
                              return;
                            case CommingSoonScreen.COMMING_SOON_ROUTE:
                              Navigator.of(context).pushNamed(
                                CommingSoonScreen.COMMING_SOON_ROUTE,
                                arguments: MenuScreenNavigatorPayloadModel(
                                  categoryId: "${model.arguments}",
                                  refreshMainContainerState:
                                      widget.refreshMainContainerState,
                                ),
                              );
                              return;
                          }
                        },
                        child: Container(
                          height: 250,
                          width: 200,
                          margin: EdgeInsets.symmetric(horizontal: 5),
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
                                model.color,
                                model.color.withOpacity(0.5),
                                model.color.withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${model.text1}',
                                // maxLines: 1,
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
                                '${model.text2}',
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 25,
                                      height: 0.9,
                                    ),
                              ),
                              Text(
                                '${model.text3}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              Spacer(),
                              Container(
                                height: 118,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: -20,
                                      right: -30,
                                      child: Image.asset(
                                        model.imageLink,
                                        height: 120,
                                        width: 160,
                                        fit: BoxFit.fitHeight,
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
                        ),
                      ),
                    }
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
              InkWell(
                onTap: () => Navigator.of(context).pushNamed(
                  MenuScreen.MENU_SCREEN_ROUTE,
                  arguments: MenuScreenNavigatorPayloadModel(
                    categoryId: "0",
                    refreshMainContainerState: widget.refreshMainContainerState,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: defaultPadding, horizontal: defaultPadding / 2),
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    // child: CachedNetworkImage(
                    //   fit: BoxFit.cover,
                    //   imageUrl:
                    //       'https://askbootstrap.com/preview/swiggi/template2/img/banner.png',
                    //   progressIndicatorBuilder:
                    //       (context, url, downloadProgress) => Center(
                    //           child: CircularProgressIndicator(
                    //               value: downloadProgress.progress)),
                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                    // ),
                    child: Image.asset(
                      'assets/images/banner.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SubHeading(
                title: 'Combos',
                context: context,
                routePath: MenuScreen.MENU_SCREEN_ROUTE,
                menuScreenNavigatorPayloadModel:
                    MenuScreenNavigatorPayloadModel(
                  categoryId: combocategory.id,
                  refreshMainContainerState: widget.refreshMainContainerState,
                ),
                refreshState: refreshState,
              ),
              for (FoodModel foodModel in combocategory.foodList) ...{
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
                                imageUrl: '${foodModel.foodImage}',
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
                                        '8.02% off',
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
                                  '${foodModel.foodname.toWordCase()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                ReadMoreText(
                                  '${foodModel.fooddescription.toCamelCase()}',
                                  style: Theme.of(context).textTheme.caption,
                                  trimLines: 3,
                                  trimMode: TrimMode.Line,
                                  colorClickableText: primaryColor,
                                  trimCollapsedText: 'Read more',
                                  trimExpandedText: 'show less',
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ' ₹ ${foodModel.foodamount} ',
                                        ),
                                        Text(
                                          ' ₹ ${int.parse(foodModel.foodamount) + 100}',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    (CartHelper.getItemCountInCart(
                                                CartHelper.transformFoodModel(
                                                    foodModel)) ==
                                            0)
                                        ? CartButton().getCartButtonSimple(
                                            context, foodModel, refreshState)
                                        : CartButton().getCartButtonComplex(
                                            context, foodModel, refreshState)
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
