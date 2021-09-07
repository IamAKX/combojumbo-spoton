import 'dart:developer';

import 'package:cjspoton/model/category_model.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SearchPageScreen extends StatefulWidget {
  const SearchPageScreen(
      {Key? key, required this.menuScreenNavigatorPayloadModel})
      : super(key: key);
  static const String SEARCH_SCREEN_ROUTE = '/searchScreen';
  // final Function() refreshMainContainerState;
  final MenuScreenNavigatorPayloadModel menuScreenNavigatorPayloadModel;

  @override
  _SearchPageScreenState createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen> {
  TextEditingController _searchCtrl = TextEditingController();
  List<CategoryModel> list = [];
  late CatalogService _catalogService;

  List<FoodModel> searchResultList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _catalogService.fetchAllFoodItem(context).then(
        (value) {
          setState(() {
            list = value;
            _searchCtrl.addListener(() {
              String searchString = _searchCtrl.text.toLowerCase();
              if (searchString.isEmpty)
                searchResultList.clear();
              else {
                searchResultList.clear();
                for (CategoryModel category in list) {
                  for (FoodModel food in category.foodList) {
                    if (food.foodname.toLowerCase().contains(searchString)) {
                      searchResultList.add(food);
                    }
                  }
                }
              }
              setState(() {});
            });
          });
        },
      ),
    );
  }

  refreshState() {
    widget.menuScreenNavigatorPayloadModel.refreshMainContainerState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _catalogService = Provider.of<CatalogService>(context);
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Search'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(defaultPadding),
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
                          fillColor: bgColor,
                          filled: true,
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
            Expanded(
              child: ListView(
                children: [
                  if (_catalogService.status != CatalogStatus.Success)
                    Container(
                      height: 500,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                  else if (searchResultList.isEmpty)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: defaultPadding * 2,
                          ),
                          SvgPicture.asset(
                            'assets/svg/search.svg',
                            width: 200,
                          ),
                          SizedBox(
                            height: defaultPadding,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Text(
                              'No search result...',
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
                  else
                    for (FoodModel food in searchResultList) ...{
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
