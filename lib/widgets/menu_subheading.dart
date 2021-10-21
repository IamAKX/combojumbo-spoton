import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class MenuSubheading extends StatelessWidget {
  const MenuSubheading({
    Key? key,
    required this.title,
    required this.itemCount,
  }) : super(key: key);

  final String title;
  final String itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$title',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                width: defaultPadding * 0.5,
              ),
              Text(
                "$itemCount ${itemCount.toDouble() > 1 ? 'ITEMS' : 'ITEM'}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: borderColor),
              )
            ],
          ),
        ),
        Divider(
          color: hintColor,
        ),
      ],
    );
  }
}
