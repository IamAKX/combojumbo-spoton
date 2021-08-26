import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.amount,
    required this.imageUrl,
  }) : super(key: key);
  final String title;
  final String subTitle;
  final String amount;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('$title'),
          isThreeLine: true,
          trailing: Column(
            children: [
              Text('${Constants.RUPEE} $amount'),
              SizedBox(
                height: 1,
              ),
              Container(
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
                        addNewItemToCart(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: defaultPadding / 2),
                        child: Icon(
                          Icons.remove,
                          color: primaryColor,
                          size: 15,
                        ),
                      ),
                    ),
                    Text('1'),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: defaultPadding / 2),
                        child: Icon(
                          Icons.add,
                          color: primaryColor,
                          size: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          subtitle: Text(
            '$subTitle',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          contentPadding: EdgeInsets.only(right: defaultPadding),
          minVerticalPadding: 0,
          leading: Container(
            width: 80,
            height: 80,
            child: CachedNetworkImage(
              imageUrl: '$imageUrl',
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        Divider(
          color: hintColor,
        ),
      ],
    );
  }

  Future<void> addNewItemToCart(BuildContext context) {
    return showModalBottomSheet<void>(
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Text(
                        "Add on",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          color: TEXT_COLOR,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
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
