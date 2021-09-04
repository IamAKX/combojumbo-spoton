import 'dart:convert';

class AllChargesModel {
  String Service_Charge;
  String Packing_Charge;
  String Table_Booking_Charge;
  String Discount_Amount_Table_Booking;
  String EDining_Charges;
  String max_cod_allowed_for_delivery;
  String min_order_online;
  String min_order_free_shipping;
  String gst;
  AllChargesModel({
    required this.Service_Charge,
    required this.Packing_Charge,
    required this.Table_Booking_Charge,
    required this.Discount_Amount_Table_Booking,
    required this.EDining_Charges,
    required this.max_cod_allowed_for_delivery,
    required this.min_order_online,
    required this.min_order_free_shipping,
    required this.gst,
  });

  AllChargesModel copyWith({
    String? Service_Charge,
    String? Packing_Charge,
    String? Table_Booking_Charge,
    String? Discount_Amount_Table_Booking,
    String? EDining_Charges,
    String? max_cod_allowed_for_delivery,
    String? min_order_online,
    String? min_order_free_shipping,
    String? gst,
  }) {
    return AllChargesModel(
      Service_Charge: Service_Charge ?? this.Service_Charge,
      Packing_Charge: Packing_Charge ?? this.Packing_Charge,
      Table_Booking_Charge: Table_Booking_Charge ?? this.Table_Booking_Charge,
      Discount_Amount_Table_Booking:
          Discount_Amount_Table_Booking ?? this.Discount_Amount_Table_Booking,
      EDining_Charges: EDining_Charges ?? this.EDining_Charges,
      max_cod_allowed_for_delivery:
          max_cod_allowed_for_delivery ?? this.max_cod_allowed_for_delivery,
      min_order_online: min_order_online ?? this.min_order_online,
      min_order_free_shipping:
          min_order_free_shipping ?? this.min_order_free_shipping,
      gst: gst ?? this.gst,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Service_Charge': Service_Charge,
      'Packing_Charge': Packing_Charge,
      'Table_Booking_Charge': Table_Booking_Charge,
      'Discount_Amount_Table_Booking': Discount_Amount_Table_Booking,
      'EDining_Charges': EDining_Charges,
      'max_cod_allowed_for_delivery': max_cod_allowed_for_delivery,
      'min_order_online': min_order_online,
      'min_order_free_shipping': min_order_free_shipping,
      'gst': gst,
    };
  }

  factory AllChargesModel.fromMap(Map<String, dynamic> map) {
    return AllChargesModel(
      Service_Charge: map['Service_Charge'],
      Packing_Charge: map['Packing_Charge'],
      Table_Booking_Charge: map['Table_Booking_Charge'],
      Discount_Amount_Table_Booking: map['Discount_Amount_Table_Booking'],
      EDining_Charges: map['EDining_Charges'],
      max_cod_allowed_for_delivery: map['max_cod_allowed_for_delivery'],
      min_order_online: map['min_order_online'],
      min_order_free_shipping: map['min_order_free_shipping'],
      gst: map['gst'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AllChargesModel.fromJson(String source) =>
      AllChargesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AllChargesModel(Service_Charge: $Service_Charge, Packing_Charge: $Packing_Charge, Table_Booking_Charge: $Table_Booking_Charge, Discount_Amount_Table_Booking: $Discount_Amount_Table_Booking, EDining_Charges: $EDining_Charges, max_cod_allowed_for_delivery: $max_cod_allowed_for_delivery, min_order_online: $min_order_online, min_order_free_shipping: $min_order_free_shipping, gst: $gst)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AllChargesModel &&
        other.Service_Charge == Service_Charge &&
        other.Packing_Charge == Packing_Charge &&
        other.Table_Booking_Charge == Table_Booking_Charge &&
        other.Discount_Amount_Table_Booking == Discount_Amount_Table_Booking &&
        other.EDining_Charges == EDining_Charges &&
        other.max_cod_allowed_for_delivery == max_cod_allowed_for_delivery &&
        other.min_order_online == min_order_online &&
        other.min_order_free_shipping == min_order_free_shipping &&
        other.gst == gst;
  }

  @override
  int get hashCode {
    return Service_Charge.hashCode ^
        Packing_Charge.hashCode ^
        Table_Booking_Charge.hashCode ^
        Discount_Amount_Table_Booking.hashCode ^
        EDining_Charges.hashCode ^
        max_cod_allowed_for_delivery.hashCode ^
        min_order_online.hashCode ^
        min_order_free_shipping.hashCode ^
        gst.hashCode;
  }
}
