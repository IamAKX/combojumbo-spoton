import 'package:cjspoton/screen/choose_outlet/choose_outlet_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);
  static const String INTRODUCTION_ROUTE = '/introduction';

  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  List<PageViewModel> pages = [
    PageViewModel(
      title: 'Discover Place Near You',
      body:
          'We make it simple to find the food you crave. Enter your address and let us do the rest.',
      image: SvgPicture.asset('assets/svg/landing1.svg'),
    ),
    PageViewModel(
      title: 'Discover Place Near You',
      body:
          'We make it simple to find the food you crave. Enter your address and let us do the rest.',
      image: SvgPicture.asset('assets/svg/landing2.svg'),
    ),
    PageViewModel(
      title: 'Discover Place Near You',
      body:
          'We make it simple to find the food you crave. Enter your address and let us do the rest.',
      image: SvgPicture.asset('assets/svg/landing3.svg'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: defaultPadding * 4,
          left: defaultPadding * 2,
          right: defaultPadding * 2,
          bottom: defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context)
                  .pushNamed(ChooseOutletScreen.CHOOSE_OUTLET_ROUTE),
              label: Text(
                'Skip',
                style: Theme.of(context)
                    .textTheme
                    .button
                    ?.copyWith(color: Colors.red),
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.red.withOpacity(0.1)),
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(
                    color: Colors.red,
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(
                    vertical: defaultPadding / 2,
                    horizontal: defaultPadding,
                  ),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.red,
              ),
            ),
            Expanded(
              child: IntroductionScreen(
                pages: pages,
                showSkipButton: false,
                color: Colors.white,
                showNextButton: false,
                showDoneButton: false,
                isProgress: true,
                isProgressTap: true,
                dotsDecorator: DotsDecorator(
                  size: const Size(5.0, 5.0),
                  activeSize: const Size(5.0, 5.0),
                  activeColor: textColor,
                  color: Colors.grey.withOpacity(0.2),
                  spacing: const EdgeInsets.symmetric(horizontal: 10.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
