import 'package:cjspoton/screen/order/order_detail.dart';
import 'package:cjspoton/screen/order/order_food_model.dart';
import 'package:cjspoton/screen/order/order_menu_details.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key, required this.orderDetailModel})
      : super(key: key);
  static const String ORDER_DETAIL_ROUTE = '/orderDetailScreen';
  final OrderDetailModel orderDetailModel;

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: bgColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ORDER #${widget.orderDetailModel.order.trans_id}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              'Ordered at ${formatOrderTime(widget.orderDetailModel.order.date_creation)}',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.all(defaultPadding),
        children: [
          Row(
            children: [
              Icon(
                Icons.delivery_dining,
                color: primaryColor,
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Text(
                'Order delivered by ${widget.orderDetailModel.order.delivey_who.isEmpty ? 'unknown' : widget.orderDetailModel.order.delivey_who}',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: hintColor),
              ),
            ],
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Text(
            'Bill Details',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
          ),
          for (OrderMenuDetails orderDetail
              in widget.orderDetailModel.menuDetails) ...{
            Container(
              color: bgColor,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Icon(
                    Icons.adjust_outlined,
                    color: Colors.green,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                      '${orderDetail.food.productname} x ${orderDetail.food.qty}'),
                  Spacer(),
                  Text(
                    '${Constants.RUPEE} ${double.parse(orderDetail.food.calculateprice).toStringAsFixed(2)}',
                  )
                ],
              ),
            ),
          },
          SizedBox(
            height: 10,
          ),
          DashedDivider(
            color: borderColor,
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text('Item Total'),
              Spacer(),
              Text(
                  '${Constants.RUPEE} ${widget.orderDetailModel.order.subtotal.toDouble().toStringAsFixed(2)}'),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text('Order Packaging Charges'),
              Spacer(),
              if (widget.orderDetailModel.order.packging_charge.toDouble() == 0)
                Text(
                  'FREE',
                  style: TextStyle(color: Colors.green),
                )
              else
                Text(
                    '${Constants.RUPEE} ${widget.orderDetailModel.order.packging_charge.toDouble().toStringAsFixed(2)}'),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text('Delivery Partner fee'),
              Spacer(),
              Text(
                  '${Constants.RUPEE} ${widget.orderDetailModel.order.delivery_charge.toDouble().toStringAsFixed(2)}'),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text('Service Charge'),
              Spacer(),
              Text(
                  '${Constants.RUPEE} ${widget.orderDetailModel.order.service_charge.toDouble().toStringAsFixed(2)}'),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text('GST'),
              Spacer(),
              Text(
                  '${Constants.RUPEE} ${widget.orderDetailModel.order.gst_amount.toDouble().toStringAsFixed(2)}'),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: hintColor,
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text(
                'Paid via ${widget.orderDetailModel.order.payment_type}',
                style: Theme.of(context).textTheme.caption,
              ),
              Spacer(),
              Text(
                'Bill Paid  ${Constants.RUPEE} ${widget.orderDetailModel.order.total_amount.toDouble().toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatOrderTime(String? date_creation) {
    String formatedTimestamp = '';
    DateTime dateTime = DateTime.parse(date_creation!);
    formatedTimestamp = DateFormat('MMMM dd, hh:mm a').format(dateTime);
    return formatedTimestamp;
  }
}
