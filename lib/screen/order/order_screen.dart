import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (int i = 0; i < 10; i++) ...{
          Container(
            color: bgColor,
            margin: EdgeInsets.only(bottom: defaultPadding / 2),
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Vashi',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Spacer(),
                    Text(
                      'Delivered',
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
                  'Pune, Maharastra',
                  style: Theme.of(context).textTheme.caption,
                ),
                Row(
                  children: [
                    Text(
                      '${Constants.RUPEE} 189',
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
                  'Tandoori Roti x 3, Rumali Roti x 2',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  '23 August, 8:40 PM',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        }
      ],
    );
  }
}
