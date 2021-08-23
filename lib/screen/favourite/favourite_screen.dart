import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return StaggeredGridView.count(
      crossAxisCount: 2,

      // shrinkWrap: true,
      // childAspectRatio:
      //     (screenSize.width - (2 * defaultPadding)) / (screenSize.height / 1.7),
      mainAxisSpacing: defaultPadding,
      staggeredTiles: [
        for (int i = 0; i < 20; i++) ...{StaggeredTile.fit(1)}
      ],
      children: [
        for (int i = 0; i < 20; i++) ...{
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
                            Icons.bookmark,
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
