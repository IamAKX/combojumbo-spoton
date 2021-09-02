import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cjspoton/model/category_model.dart';
import 'package:cjspoton/screen/menu/menu_screen.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/static_data.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/subheading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size screenSize;
  late CatalogService _catalogService;
  List<CategoryModel> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _catalogService.fetchAllCategories(context).then(
        (value) {
          setState(() {
            list = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _catalogService = Provider.of<CatalogService>(context);
    SnackBarService.instance.buildContext = context;
    screenSize = MediaQuery.of(context).size;
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 120,
          width: double.infinity,
          child: CarouselSlider(
            items: getCJRouteOptions()
                .map(
                  (cjRouteModel) => Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: primaryColor,
                            width: 1.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor.withOpacity(0.1),
                          child: CachedNetworkImage(
                            imageUrl: cjRouteModel.image,
                            width: 30,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
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
                      Text(cjRouteModel.name),
                    ],
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
          context: context,
          routePath: MenuScreen.MENU_SCREEN_ROUTE,
          title: 'Category',
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
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 35,
                          height: 0.8),
                    ),
                    Text(
                      'offers',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.white,
                            fontSize: 25,
                            height: 0.9,
                          ),
                    ),
                    Text(
                      'at the best restaurant',
                      style: Theme.of(context).textTheme.caption?.copyWith(
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
        SubHeading(title: 'Recommended', routePath: '', context: context),
        RecomendedItems(screenSize: screenSize),
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
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        SubHeading(title: 'Combos', routePath: '', context: context),
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
                              'https://www.combojumbo.in/master/food/images/JC336image1161jain.jpg',
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
                            'Jain Meal',
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Text(
                            '2 Jain Hara Bhara Kebab/1 Jain Paneer Gravy/1 Jain Mix Veg/1 Jain Dhabe Wali Dal/1 Hara Moti Pulav/1 Sweet/Papad/ Pickle/ Chutney/2 Roti',
                            style: Theme.of(context).textTheme.caption,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            ' ₹ 459 ',
                          ),
                          Row(
                            children: [
                              Text(
                                ' ₹ 499 ',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'ADD',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.copyWith(
                                          color: primaryColor,
                                        ),
                                  ),
                                ),
                              )
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

class RecomendedItems extends StatelessWidget {
  const RecomendedItems({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      staggeredTiles: [
        for (int i = 0; i < 4; i++) ...{StaggeredTile.fit(1)}
      ],
      mainAxisSpacing: defaultPadding,
      physics: NeverScrollableScrollPhysics(),
      children: [
        for (int i = 0; i < 4; i++) ...{
          Container(
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // width: screenSize.width * 0.7,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: CachedNetworkImage(
                          height: screenSize.width * 0.4,
                          width: screenSize.width * 0.7,
                          fit: BoxFit.cover,
                          imageUrl:
                              'https://www.combojumbo.in/master/food/images/107image16632021-06-29-18-57-17paneer-tikka.jpg',
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: CircleAvatar(
                          backgroundColor: bgColor,
                          radius: 15,
                          child: Icon(
                            Icons.favorite_outline,
                            size: 20,
                            color: textColor,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                              Text(
                                '4.1',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
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
                Container(
                  padding: EdgeInsets.all(defaultPadding / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paneer Tikka',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Paneer marinated in curd and Indian spice cooked in tandoor',
                        style: Theme.of(context).textTheme.caption,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text('₹ 90'),
                          Spacer(),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'ADD',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                      color: primaryColor,
                                    ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        }
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.screenSize,
    required this.categoryModel,
  }) : super(key: key);

  final Size screenSize;
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      width: screenSize.width * 0.7,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // width: screenSize.width * 0.7,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    height: screenSize.width * 0.5,
                    width: screenSize.width * 0.7,
                    fit: BoxFit.cover,
                    imageUrl: '${categoryModel.image}',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(
                    backgroundColor: bgColor,
                    radius: 15,
                    child: Text('${categoryModel.foodcount}'),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                        Text(
                          '4.1',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
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
          Container(
            padding: EdgeInsets.all(defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${categoryModel.categoryName}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text('Starts from ₹ ${categoryModel.startsfrom}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
