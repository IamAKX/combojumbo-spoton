import 'package:cjspoton/screen/order_feedback/order_feedback_screen.dart';
import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_order_details.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableBookingScreens extends StatefulWidget {
  const TableBookingScreens({Key? key}) : super(key: key);
  static const String TABLE_BOOKING_HISTORY_ROUTE =
      '/tableBookingOrderDetailScreen';

  @override
  _TableBookingScreensState createState() => _TableBookingScreensState();
}

class _TableBookingScreensState extends State<TableBookingScreens> {
  late CartServices _cartServices;
  List<TableBookingOrderDetails> orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _cartServices.getTableBookingOrderHistory(context).then(
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: bgColor,
        title: Text('Booking History'),
      ),
      body: _cartServices.status == CartStatus.Loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/not_table_booking_history.png',
                        width: 300,
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          'Book a Table and start enjoying luscious meals at CJ',
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
                    for (TableBookingOrderDetails order in orders) ...{
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).pushNamed(
                          //     OrderDetailScreen.ORDER_DETAIL_ROUTE,
                          //     arguments: order);
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
                                    '${order.ordertype.replaceAll('-', ' ')}',
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
                                    '${getOrderStatus(order.orderstatus)}',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
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
                                'CJ ${order.outletname}',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                '${order.noguest} Guest${order.noguest == '1' ? '' : 's'}',
                                style: Theme.of(context).textTheme.subtitle2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Booking for ${order.datetime}',
                                style: Theme.of(context).textTheme.subtitle2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${Constants.RUPEE} ${order.totalamount}',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
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
                              // Text(
                              //   '${order.menuDetailsList.map((e) => e.food.productname).toList().join(',')}',
                              //   style: Theme.of(context).textTheme.subtitle2,
                              // ),
                              Text(
                                '${order.adddate}',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              if (isOrderDelivered(order.orderstatus))
                                InkWell(
                                  onTap: () => Navigator.of(context).pushNamed(
                                      OrderFeedback.ORDER_FEEDBACK_ROUTE,
                                      arguments: order),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
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
                ),
    );
  }
}
