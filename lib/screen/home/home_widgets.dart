import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/model/category_model.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RecomendedItems extends StatelessWidget {
  const RecomendedItems({
    Key? key,
    required this.screenSize,
    required this.list,
    required this.favList,
    required this.reloadFavList,
  }) : super(key: key);

  final Size screenSize;
  final List<CategoryModel> list;
  final List<FoodModel> favList;
  final Function() reloadFavList;

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
                          imageUrl: list.first.foodList.elementAt(i).foodImage,
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
                        child: InkWell(
                          onTap: () {
                            if (Utilities().isFoodMarkedFavourite(
                                favList, list.first.foodList.elementAt(i).id))
                              favList.removeWhere((element) =>
                                  element.id ==
                                  list.first.foodList.elementAt(i).id);
                            else
                              favList.add(list.first.foodList.elementAt(i));
                            Utilities().setFavouriteFood(favList);
                            reloadFavList();
                          },
                          child: CircleAvatar(
                            backgroundColor: bgColor,
                            radius: 15,
                            child: Icon(
                              Utilities().isFoodMarkedFavourite(favList,
                                      list.first.foodList.elementAt(i).id)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 20,
                              color: Colors.red,
                            ),
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
                                '4.8',
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
                        '${list.first.foodList.elementAt(i).foodname}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${list.first.foodList.elementAt(i).fooddescription}',
                        style: Theme.of(context).textTheme.caption,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                              '₹ ${list.first.foodList.elementAt(i).foodamount}'),
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
