import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/screen/menu/menu_screen.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommingSoonScreen extends StatefulWidget {
  const CommingSoonScreen(
      {Key? key, required this.menuScreenNavigatorPayloadModel})
      : super(key: key);
  final MenuScreenNavigatorPayloadModel menuScreenNavigatorPayloadModel;
  static const String COMMING_SOON_ROUTE = '/commingSoon';

  @override
  _CommingSoonScreenState createState() => _CommingSoonScreenState();
}

class _CommingSoonScreenState extends State<CommingSoonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/svg/comming_soon.svg',
              width: 300,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                'Comming soon..',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(fontSize: 20),
              ),
            ),
            SizedBox(
              height: defaultPadding * 2,
            ),
            SizedBox(
              width: 300,
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      MenuScreen.MENU_SCREEN_ROUTE,
                      arguments: MenuScreenNavigatorPayloadModel(
                        categoryId: "0",
                        refreshMainContainerState: widget
                            .menuScreenNavigatorPayloadModel
                            .refreshMainContainerState,
                      ),
                    );
                  },
                  child: Text('Go to Menu')),
            )
          ],
        ),
      ),
    );
  }
}
