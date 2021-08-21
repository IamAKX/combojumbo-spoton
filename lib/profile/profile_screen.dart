import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          color: bgColor,
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://askbootstrap.com/preview/swiggi/template2/img/user1.jpg'),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nellie H. Riggs',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text('nellie.h@gmail.com'),
                ],
              )
            ],
          ),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        Container(
          color: bgColor,
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Account Credits'),
              Text(
                '${Constants.RUPEE} 52.25',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        ListTile(
          tileColor: bgColor,
          title: Text(
            'Payment Cards',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
          ),
          subtitle: Text('Add a credit or debit card'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          tileColor: bgColor,
          title: Text(
            'Address',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
          ),
          subtitle: Text('Add or remove a delivery address'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          tileColor: bgColor,
          title: Text(
            'Refer Friends',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 20),
          ),
          subtitle: Text(
            'Get ${Constants.RUPEE}10.00 FREE',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(
              Icons.car_rental,
              color: bgColor,
            ),
          ),
          tileColor: bgColor,
          title: Text(
            'Delivery Support',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.pink,
            child: Icon(
              Icons.call_outlined,
              color: bgColor,
            ),
          ),
          tileColor: bgColor,
          title: Text(
            'Contact Us',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(
              Icons.info_outline,
              color: bgColor,
            ),
          ),
          tileColor: bgColor,
          title: Text(
            'Term of Use',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.lock_outline,
              color: bgColor,
            ),
          ),
          tileColor: bgColor,
          title: Text(
            'Privacy Policy',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }
}
