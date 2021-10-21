import 'dart:developer';

import 'package:cjspoton/model/add_on_model.dart';
import 'package:cjspoton/model/add_on_model_item.dart';
import 'package:cjspoton/model/cart_item.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class CartButton {
  Container getCartButtonComplex(
      BuildContext context, FoodModel foodModel, Function() refreshState) {
    CartItem cartItem = CartHelper.transformFoodModel(foodModel);
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              CartHelper.removeItemToCart(cartItem);
              refreshState();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Icon(
                Icons.remove,
                color: primaryColor,
                size: 15,
              ),
            ),
          ),
          Text('${CartHelper.getItemCountInCart(cartItem)}'),
          InkWell(
            onTap: () {
              CartHelper.addItemToCart(cartItem);
              refreshState();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Icon(
                Icons.add,
                color: primaryColor,
                size: 15,
              ),
            ),
          )
        ],
      ),
    );
  }

  InkWell getCartButtonSimple(
      BuildContext context, FoodModel foodModel, Function() refreshState) {
    return InkWell(
      onTap: () {
        if (foodModel.addons.isEmpty) {
          CartItem cartItem = CartHelper.transformFoodModel(foodModel);
          CartHelper.addItemToCart(cartItem);
        } else {
          addNewItemToCart(context, foodModel);
        }
        refreshState();
      },
      child: Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'ADD',
          style: Theme.of(context).textTheme.button?.copyWith(
                color: primaryColor,
              ),
        ),
      ),
    );
  }

  ScrollController _scrollController = ScrollController();
  Future<void> addNewItemToCart(BuildContext context, FoodModel foodModel) {
    Map<String, String> singleSelectOption = Map<String, String>();
    for (AddOnModel addOnModel
        in foodModel.addons.where((element) => element.Type == 'Single'))
      singleSelectOption[addOnModel.id] = '';
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
                      // Text('Customize',
                      //     style:
                      //         Theme.of(context).textTheme.subtitle1?.copyWith(
                      //               fontWeight: FontWeight.bold,
                      //             )),
                      // Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'ADD',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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
                      child: ListView.builder(
                        itemCount: foodModel.addons.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          AddOnModel addOnModel =
                              foodModel.addons.elementAt(index);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      '${addOnModel.Mainheading} ',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    Text(
                                      '(${addOnModel.subaddons.length})',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: addOnModel.Type == 'Single'
                                    ? Text(
                                        'Choose any 1 extra (${addOnModel.Requirement})',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      )
                                    : Text(
                                        'Choose any extra (${addOnModel.Requirement})',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                              ),
                              if (addOnModel.Type == 'Single') ...{
                                for (AddOnItemModel addOnItemModel
                                    in addOnModel.subaddons) ...{
                                  RadioListTile(
                                    title:
                                        Text('${addOnItemModel.subaddonsname}'),
                                    value: addOnItemModel.id,
                                    secondary: Text(
                                        '${Constants.RUPEE} ${addOnItemModel.amount.toDouble().toStringAsFixed(2)}'),
                                    activeColor: primaryColor,
                                    groupValue:
                                        singleSelectOption[addOnModel.id],
                                    onChanged: (value) {
                                      setState(() {
                                        singleSelectOption[addOnModel.id] =
                                            addOnItemModel.id;
                                        log(singleSelectOption.toString());
                                      });
                                    },
                                  ),
                                },
                              } else ...{
                                for (AddOnItemModel addOnItemModel
                                    in addOnModel.subaddons) ...{
                                  CheckboxListTile(
                                    dense: true,
                                    title:
                                        Text('${addOnItemModel.subaddonsname}'),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value:
                                        multiSelect.contains(addOnItemModel.id),
                                    secondary: Text(
                                        '${Constants.RUPEE} ${addOnItemModel.amount.toDouble().toStringAsFixed(2)}'),
                                    activeColor: primaryColor,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!)
                                          multiSelect.add(addOnItemModel.id);
                                        else
                                          multiSelect.remove(addOnItemModel.id);
                                      });
                                    },
                                  ),
                                },
                              },
                              SizedBox(
                                height: defaultPadding,
                              ),
                            ],
                          );
                        },
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
