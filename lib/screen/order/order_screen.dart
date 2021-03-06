import 'dart:developer';

import 'package:cjspoton/screen/order/order_detail.dart';
import 'package:cjspoton/screen/order/order_details_screen.dart';
import 'package:cjspoton/screen/order_feedback/order_feedback_screen.dart';
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
    // log('orders.length = ${orders.length}');
    return _cartServices.status == CartStatus.Loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/order_history.png',
                      width: 300,
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(
                        'You have no order history',
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
                                  '${getOrderStatus(order.order.order_status)}',
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
                              'Order #${order.order.showorderid.isEmpty ? order.order.id : order.order.showorderid}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            // if (order.address.isEmpty)
                            //   Text(
                            //     '${order.address.replaceAll(',', ', ')}',
                            //     style: Theme.of(context).textTheme.subtitle2,
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //   ),
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
                                ),
                                Spacer(),
                                Text(
                                  '${order.order.ordertype.replaceAll('-', '')}',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
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
                            if (order.menuDetails.isNotEmpty)
                              Text(
                                '${order.menuDetails.map((e) => e.food.productname + ' x ' + e.food.qty).toList().join(', ')}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(color: hintColor),
                              ),
                            Text(
                              '${order.orderdate}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (isOrderDelivered(order.order.order_status))
                              InkWell(
                                onTap: () => Navigator.of(context).pushNamed(
                                    OrderFeedback.ORDER_FEEDBACK_ROUTE,
                                    arguments: order),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    'FEEDBACK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.copyWith(color: primaryColor),
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

  String formatOrderTime(String? date_creation) {
    String formatedTimestamp = '';
    DateTime dateTime = DateTime.parse(date_creation!);
    formatedTimestamp = DateFormat('MMMM dd, hh:mm a').format(dateTime);
    return formatedTimestamp;
  }
}
