import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:cjspoton/widgets/cart_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key, required this.refreshMainContainerState})
      : super(key: key);
  final Function() refreshMainContainerState;
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late Size screenSize;
  late CatalogService _catalogService;
  List<FoodModel> favList = [];

  refreshState() {
    widget.refreshMainContainerState();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _catalogService.getAllFavourite(context).then(
        (value) {
          setState(() {
            favList = value;
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
    return favList.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/empty_favourite.png',
                  width: 300,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    'Add something to your favourite list',
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
        : Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: StaggeredGridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(vertical: defaultPadding),
              crossAxisSpacing: defaultPadding / 2,
              mainAxisSpacing: defaultPadding,
              staggeredTiles: [
                for (int i = 0; i < favList.length; i++) ...{
                  StaggeredTile.fit(1)
                }
              ],
              children: [
                for (int i = 0; i < favList.length; i++) ...{
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: defaultPadding / 2),
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
                                  imageUrl: favList.elementAt(i).foodImage,
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
                              Positioned(
                                right: 10,
                                top: 10,
                                child: InkWell(
                                  onTap: () async {
                                    if (Utilities().isFoodMarkedFavourite(
                                        favList, favList.elementAt(i).id)) {
                                      await _catalogService
                                          .removeFavourite(
                                              favList.elementAt(i).id, context)
                                          .then((value) {
                                        if (value)
                                          favList.removeWhere((element) =>
                                              element.id ==
                                              favList.elementAt(i).id);
                                      });
                                    } else {
                                      await _catalogService
                                          .addFavourite(
                                              favList.elementAt(i).id, context)
                                          .then((value) {
                                        if (value)
                                          favList.add(favList.elementAt(i));
                                      });
                                    }
                                    Utilities().setFavouriteFood(favList);
                                    setState(() {});
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: bgColor,
                                    radius: 15,
                                    child: Icon(
                                      Utilities().isFoodMarkedFavourite(
                                              favList, favList.elementAt(i).id)
                                          ? Icons.favorite
                                          : Icons.favorite_outline,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   right: 10,
                              //   bottom: 10,
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 10),
                              //     decoration: BoxDecoration(
                              //         color: Colors.green,
                              //         borderRadius: BorderRadius.circular(5)),
                              //     child: Row(
                              //       children: [
                              //         Icon(
                              //           Icons.star_outline,
                              //           color: Colors.white,
                              //           size: 18,
                              //         ),
                              //         Text(
                              //           '4.1',
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .headline6
                              //               ?.copyWith(
                              //                 color: Colors.white,
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(defaultPadding / 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favList.elementAt(i).foodname,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                '${favList.elementAt(i).fooddescription}',
                                style: Theme.of(context).textTheme.caption,
                                trimLines: 2,
                                trimMode: TrimMode.Line,
                                colorClickableText: primaryColor,
                                trimCollapsedText: 'Read more',
                                trimExpandedText: 'show less',
                              ),
                              Row(
                                children: [
                                  Text('₹ ${favList.elementAt(i).foodamount}'),
                                  Spacer(),
                                  if (CartHelper.getItemCountInCart(
                                          CartHelper.transformFoodModel(
                                              favList.elementAt(i))) ==
                                      0)
                                    CartButton().getCartButtonSimple(
                                      context,
                                      favList.elementAt(i),
                                      refreshState,
                                    )
                                  else
                                    CartButton().getCartButtonComplex(
                                      context,
                                      favList.elementAt(i),
                                      refreshState,
                                    ),
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
            ),
          );
  }
}
