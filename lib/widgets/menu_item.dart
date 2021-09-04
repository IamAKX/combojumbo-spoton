import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/cart_buttons.dart';
import 'package:flutter/material.dart';

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
  }) : super(key: key);
  final String title;
  final String subTitle;
  final String amount;
  final String imageUrl;
  final BuildContext parentContext;
  final FoodModel foodModel;
  final Function() refreshState;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            '${title.toCamelCase()}',
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
          subtitle: Text(
            '${subTitle.toCamelCase()}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(color: borderColor),
          ),
          contentPadding:
              EdgeInsets.only(right: defaultPadding, left: defaultPadding),
          minVerticalPadding: 0,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 80,
              height: 80,
              child: CachedNetworkImage(
                imageUrl: '$imageUrl',
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ),
        Divider(
          color: hintColor,
        ),
      ],
    );
  }

  ScrollController _scrollController = ScrollController();
  Future<void> addNewItemToCart(BuildContext context) {
    int singleSelectOption = 0;
    List multiSelect = [];
    return showModalBottomSheet<void>(
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(children: [
                      Text('Customize',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ]),
                  ),
                  Expanded(
                    child: NotificationListener(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification &&
                            _scrollController.position.pixels == 0.0) {
                          // Navigator.pop(context);
                        }
                        return true;
                      },
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Burger Combo Item ',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  '(4)',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Choose any 1 extra (*Mandatory)',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          for (var i = 0; i < 4; i++) ...{
                            RadioListTile(
                              title: Text('Option $i'),
                              value: i,
                              secondary: Text('${Constants.RUPEE} 123.00'),
                              activeColor: primaryColor,
                              groupValue: singleSelectOption,
                              onChanged: (value) {
                                setState(() {
                                  singleSelectOption =
                                      int.parse(value.toString());
                                });
                              },
                            ),
                          },
                          SizedBox(
                            height: defaultPadding,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Fries and Sauce ',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  '(6)',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Choose any extra (*Mandatory)',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          for (var i = 0; i < 4; i++) ...{
                            CheckboxListTile(
                              dense: true,
                              title: Text('Option $i'),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: multiSelect.contains(i),
                              secondary: Text('${Constants.RUPEE} 5.00'),
                              activeColor: primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  if (value!)
                                    multiSelect.add(i);
                                  else
                                    multiSelect.remove(value);
                                });
                              },
                            ),
                          },
                          SizedBox(
                            height: defaultPadding * 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'ADD',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]);
          }),
        );
      },
      context: context,
      isScrollControlled: true,
      isDismissible: false,
    );
  }
}
