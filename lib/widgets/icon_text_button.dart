import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    Key? key,
    required this.context,
    required this.text,
    required this.iconAssetPath,
    required this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final String text;
  final String iconAssetPath;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconAssetPath,
              width: 20,
            ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
