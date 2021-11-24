import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:cjspoton/widgets/cart_buttons.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class MenuItem extends StatelessWidget {
  MenuItem({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.amount,
    required this.imageUrl,
    required this.parentContext,
    required this.foodModel,
    required this.refreshState,
    required this.favList,
    required this.reloadFavList,
    required this.catalogService,
    required this.context,
  }) : super(key: key);
  final String title;
  final String subTitle;
  final String amount;
  final String imageUrl;
  final BuildContext parentContext;
  final FoodModel foodModel;
  final Function() refreshState;
  final List<FoodModel> favList;
  final Function() reloadFavList;
  final CatalogService catalogService;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            '${title}',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: textColor),
          ),
          isThreeLine: true,
          trailing: Column(
            children: [
              Text('${Constants.RUPEE} $amount'),
              SizedBox(
                height: 1,
              ),
              if (CartHelper.getItemCountInCart(
                      CartHelper.transformFoodModel(foodModel)) ==
                  0)
                CartButton().getCartButtonSimple(
                  context,
                  foodModel,
                  refreshState,
                )
              else
                CartButton().getCartButtonComplex(
                  context,
                  foodModel,
                  refreshState,
                ),
            ],
          ),
          subtitle: ReadMoreText(
            '${subTitle.toCamelCase()}',
            trimLines: 2,
            trimMode: TrimMode.Line,
            colorClickableText: primaryColor,
            trimCollapsedText: 'Read more',
            trimExpandedText: 'show less',
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(color: borderColor),
          ),
          contentPadding:
              EdgeInsets.only(right: defaultPadding, left: defaultPadding),
          minVerticalPadding: 0,
          leading: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 80,
                  height: 80,
                  child: CachedNetworkImage(
                    imageUrl: '$imageUrl',
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Positioned(
                right: 1,
                top: 1,
                child: InkWell(
                  onTap: () async {
                    if (Utilities()
                        .isFoodMarkedFavourite(favList, foodModel.id)) {
                      await catalogService
                          .removeFavourite(foodModel.id, context)
                          .then((value) {
                        if (value)
                          favList.removeWhere(
                              (element) => element.id == foodModel.id);
                      });
                    } else {
                      await catalogService
                          .addFavourite(foodModel.id, context)
                          .then((value) {
                        if (value) favList.add(foodModel);
                      });
                    }

                    Utilities().setFavouriteFood(favList);
                    reloadFavList();
                  },
                  child: CircleAvatar(
                    backgroundColor: bgColor,
                    radius: 12,
                    child: Icon(
                      Utilities().isFoodMarkedFavourite(favList, foodModel.id)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: hintColor,
        ),
      ],
    );
  }
}
