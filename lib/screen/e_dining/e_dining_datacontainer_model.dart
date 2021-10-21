import 'dart:convert';

import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_model.dart';

class EDiningDataContainer {
  MenuScreenNavigatorPayloadModel menuScreenNavigatorPayloadModel;
  TableBookingModel tableBookingModel;
  EDiningDataContainer({
    required this.menuScreenNavigatorPayloadModel,
    required this.tableBookingModel,
  });
}
