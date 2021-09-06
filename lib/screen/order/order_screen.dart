import 'dart:developer';

import 'package:cjspoton/screen/order/order_detail.dart';
import 'package:cjspoton/screen/order/order_details_screen.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late CartServices _cartServices;
  List<OrderDetailModel> orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _cartServices.getOrderHistory(context).then(
        (value) {
          setState(() {
            orders = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _cartServices = Provider.of<CartServices>(context);
    SnackBarService.instance.buildContext = context;
    log('orders.length = ${orders.length}');
    return orders.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: [
              for (OrderDetailModel order in orders) ...{
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        OrderDetailScreen.ORDER_DETAIL_ROUTE,
                        arguments: order);
                  },
                  child: Container(
                    color: bgColor,
                    margin: EdgeInsets.only(bottom: defaultPadding / 2),
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'CJ ${order.outletname}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Spacer(),
                            Text(
                              '${order.order.status}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.check_circle,
                              size: 15,
                              color: Colors.green,
                            )
                          ],
                        ),
                        Text(
                          '${order.order.oid}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          '${order.address}',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Row(
                          children: [
                            Text(
                              '${Constants.RUPEE} ${order.order.total_amount}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 15,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                          color: hintColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${order.menuDetails.map((e) => e.food.productname.toCamelCase()).toList().join(',')}',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          '${formatOrderTime(order.order.date_creation)}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              }
            ],
          );
  }

  String formatOrderTime(String? date_creation) {
    String formatedTimestamp = '';
    DateTime dateTime = DateTime.parse(date_creation!);
    formatedTimestamp = DateFormat('MMMM dd, HH:mm a').format(dateTime);
    return formatedTimestamp;
  }
}
