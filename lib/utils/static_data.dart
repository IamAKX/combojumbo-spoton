// This class contains dummy data.
// To be deleted before pushing the app to prod

import 'package:cjspoton/model/cj_route_option_model.dart';

List<CJRouteOptionModel> getCJRouteOptions() {
  return [
    CJRouteOptionModel(
        name: 'Table Booking',
        image: 'https://www.combojumbo.in/img/mini-banquet.png',
        redirectionUrl: ''),
    CJRouteOptionModel(
        name: 'E-Dining',
        image: 'https://www.combojumbo.in/img/tbl-booking.png',
        redirectionUrl: ''),
    CJRouteOptionModel(
        name: 'Home Delivery',
        image: 'https://www.combojumbo.in/img/delivery.png',
        redirectionUrl: ''),
    CJRouteOptionModel(
        name: 'Take Away',
        image: 'https://www.combojumbo.in/img/Take%20away.png',
        redirectionUrl: ''),
    CJRouteOptionModel(
        name: 'Mini Banquet',
        image: 'https://www.combojumbo.in/img/e-dining.png',
        redirectionUrl: ''),
    CJRouteOptionModel(
        name: 'Party Packs',
        image: 'https://www.combojumbo.in/img/party-packs.png',
        redirectionUrl: ''),
  ];
}
