import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/menu_item.dart';
import 'package:cjspoton/widgets/menu_subheading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);
  static const String MENU_SCREEN_ROUTE = '/menuScreen';

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final GlobalKey _menuKey = new GlobalKey();
  ScrollController _scrollController = ScrollController();

  void _scrollToIndex(index) {
    _scrollController.animateTo(100.0 * index,
        duration: Duration(seconds: 1), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final button = new PopupMenuButton(
      key: _menuKey,
      icon: Icon(
        Icons.list,
        color: bgColor,
      ),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Soup Kitchen'),
                CircleAvatar(
                  radius: 12,
                  child: Text(
                    '4',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            value: 'Soup Kitchen'),
        PopupMenuItem<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Charcol Night'),
                CircleAvatar(
                  radius: 12,
                  child: Text(
                    '6',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            value: 'Charcol Night'),
        PopupMenuItem<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kebabs'),
                CircleAvatar(
                  radius: 12,
                  child: Text(
                    '5',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            value: 'Kebabs'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                const Text('Review'),
              ],
            ),
            value: 'Review'),
      ],
      onSelected: (value) {
        switch (value.toString()) {
          case 'Soup Kitchen':
            _scrollToIndex(2);
            break;
          case 'Charcol Night':
            _scrollToIndex(7);
            break;
          case 'Kebabs':
            _scrollToIndex(14);
            break;
          case 'Review':
            _scrollToIndex(21);
            break;
        }
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dynamic state = _menuKey.currentState;
          state.showButtonMenu();
        },
        // child: Icon(
        //   Icons.list,
        //   color: bgColor,
        // ),
        child: button,
      ),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: bgColor),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.whatsapp),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.all(defaultPadding),
              color: primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CJ Vashi - Home Delivery',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: bgColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Delivering to 400705 - Sanpada',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: bgColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Change PIN code',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: bgColor,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding * 2,
            ),
            MenuSubheading(
              itemCount: '4',
              title: 'Soup Kitchen',
            ),
            for (var i = 0; i < 4; i++) ...{
              MenuItem(
                title: 'Veg Nesista Soup',
                subTitle:
                    'Indian vegetables cooked with fresh corriander and garnished with chopped veggies',
                amount: '120.50',
                imageUrl:
                    'https://www.combojumbo.in/master/food/images/95image19122021-07-24-10-50-35nesista.jpg',
                parentContext: context,
              ),
            },
            SizedBox(
              height: defaultPadding * 2,
            ),
            MenuSubheading(
              itemCount: '6',
              title: 'Charcol Nights',
            ),
            for (var i = 0; i < 6; i++) ...{
              MenuItem(
                title: 'Paneer Tikka',
                subTitle:
                    'Paneer marinated in curd and indian spices cooked in tandoor',
                amount: '230.50',
                imageUrl:
                    'https://www.combojumbo.in/master/food/images/107image16632021-06-29-18-57-17paneer-tikka.jpg',
                parentContext: context,
              ),
            },
            SizedBox(
              height: defaultPadding * 2,
            ),
            MenuSubheading(
              itemCount: '5',
              title: 'Kebabs',
            ),
            for (var i = 0; i < 6; i++) ...{
              MenuItem(
                title: 'Cj special platter (Jumbo-12pcs)',
                subTitle: 'A combination of our chef\'s specials',
                amount: '180.50',
                imageUrl:
                    'https://www.combojumbo.in/master/food/images/293image18192021-07-24-10-58-35paneer-seekh-kebab--1.jpg',
                parentContext: context,
              ),
            },
            SizedBox(
              height: defaultPadding,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              child: Text(
                'Review',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultPadding),
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Color(0xff65CC66),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Text(
                    '9.5',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: bgColor,
                          height: 0.9,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Superb',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: bgColor,
                        ),
                  ),
                  Text(
                    'Based on 4 review',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: bgColor,
                        ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Food Quality',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.9,
                          color: Color(0xff65CC66),
                          backgroundColor: hintColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        '9.0',
                        style:
                            Theme.of(context).textTheme.subtitle1?.copyWith(),
                      ),
                    ],
                  ),
                  Text(
                    'Punctuality',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.8,
                          color: Color(0xff65CC66),
                          backgroundColor: hintColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        '8.0',
                        style:
                            Theme.of(context).textTheme.subtitle1?.copyWith(),
                      ),
                    ],
                  ),
                  Text(
                    'Service',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.95,
                          color: Color(0xff65CC66),
                          backgroundColor: hintColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        '9.5',
                        style:
                            Theme.of(context).textTheme.subtitle1?.copyWith(),
                      ),
                    ],
                  ),
                  Text(
                    'Price',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.85,
                          color: Color(0xff65CC66),
                          backgroundColor: hintColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        '8.5',
                        style:
                            Theme.of(context).textTheme.subtitle1?.copyWith(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            for (var i = 0; i < 4; i++) ...{
              ReviewTile(),
            }
          ],
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: hintColor),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                imageUrl: 'https://www.combojumbo.in/img/avatar4.jpg',
                width: 40,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            title: RichText(
              text: TextSpan(
                text: '9.5 ',
                style: TextStyle(
                  color: Color(0xff65CC66),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: '/10',
                    style: TextStyle(
                      color: Color(0xff65CC66),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: ' Rating average',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Text('Yashraj Thakkar'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              'A worthy Joint to visit repeatedly!!',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              bottom: defaultPadding,
            ),
            child: Text(
              'Very Nice Food, Unique Ambience, excellent staff. The price points are less as compared to other establishments in the area. The staff was very accommodative and attentive to ensure good experience. A lot of different cuisines are available with good quality food. Oriental sizzlers, Manchow soup and Lazeez Dum Birayni were sumptuous. The place is also available as a Banquet too.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
