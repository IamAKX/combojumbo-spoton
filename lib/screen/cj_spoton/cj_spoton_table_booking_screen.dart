import 'package:cjspoton/screen/cj_spoton/table_model.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CJSpotOnTableBookingScreen extends StatefulWidget {
  const CJSpotOnTableBookingScreen(this.refreshMainContainerState) : super();
  final Function() refreshMainContainerState;

  @override
  _CJSpotOnTableBookingScreenState createState() =>
      _CJSpotOnTableBookingScreenState();
}

class _CJSpotOnTableBookingScreenState
    extends State<CJSpotOnTableBookingScreen> {
  List<TableModel> allTableList = [];
  List<TableModel> selectedTableList = [];
  late CatalogService _catalogService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _catalogService.fetchAllTable(context).then(
        (value) {
          setState(() {
            allTableList = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _catalogService = Provider.of<CatalogService>(context);
    SnackBarService.instance.buildContext = context;
    return _catalogService.status == CartStatus.Loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _catalogService.status == CartStatus.Failed || allTableList.isEmpty
            ? Center(
                child: Text(
                  'No Table available',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: hintColor),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount: allTableList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.8,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5),
                      itemBuilder: (context, index) {
                        TableModel table = allTableList.elementAt(index);
                        return CheckboxListTile(
                          title: Text(
                            'Table ${table.table_name}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: bgColor),
                          ),
                          tileColor: HexColor.fromHex(table.color ?? '#ffffff'),
                          value: selectedTableList.any(
                              (element) => element.table_id == table.table_id),
                          onChanged: (bool? value) {
                            if (value!)
                              selectedTableList
                                  .add(allTableList.elementAt(index));
                            else
                              selectedTableList.removeWhere((element) =>
                                  element.table_id == table.table_id);

                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
  }
}
