import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  const SubHeading(
      {Key? key,
      required this.title,
      required this.routePath,
      required this.context,
      this.refreshMainContainerState,
      this.refreshState})
      : super(key: key);
  final String title;
  final String routePath;
  final BuildContext context;
  final Function()? refreshMainContainerState;
  final Function()? refreshState;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Spacer(),
          InkWell(
            onTap: () => Navigator.of(context)
                .pushNamed(routePath, arguments: refreshMainContainerState)
                .then((value) {
              if (refreshState != null) refreshState!();
            }),
            child: Text(
              'View all',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right_outlined,
            color: primaryColor,
          ),
        ],
      ),
    );
  }
}
