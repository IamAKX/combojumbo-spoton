import 'dart:convert';

import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/section_model.dart';

class TableBookingModel {
  AllChargesModel? allChargesModel;
  SectionModel section;
  OutletModel outlet;
  String numberOfGuest;
  String bookingSlot;
  TableBookingModel({
    this.allChargesModel,
    required this.section,
    required this.outlet,
    required this.numberOfGuest,
    required this.bookingSlot,
  });

  TableBookingModel copyWith({
    AllChargesModel? allChargesModel,
    SectionModel? section,
    OutletModel? outlet,
    String? numberOfGuest,
    String? bookingSlot,
  }) {
    return TableBookingModel(
      allChargesModel: allChargesModel ?? this.allChargesModel,
      section: section ?? this.section,
      outlet: outlet ?? this.outlet,
      numberOfGuest: numberOfGuest ?? this.numberOfGuest,
      bookingSlot: bookingSlot ?? this.bookingSlot,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allChargesModel': allChargesModel?.toMap(),
      'section': section.toMap(),
      'outlet': outlet.toMap(),
      'numberOfGuest': numberOfGuest,
      'bookingSlot': bookingSlot,
    };
  }

  factory TableBookingModel.fromMap(Map<String, dynamic> map) {
    return TableBookingModel(
      allChargesModel: AllChargesModel.fromMap(map['allChargesModel']),
      section: SectionModel.fromMap(map['section']),
      outlet: OutletModel.fromMap(map['outlet']),
      numberOfGuest: map['numberOfGuest'],
      bookingSlot: map['bookingSlot'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TableBookingModel.fromJson(String source) =>
      TableBookingModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TableBookingModel(allChargesModel: $allChargesModel, section: $section, outlet: $outlet, numberOfGuest: $numberOfGuest, bookingSlot: $bookingSlot)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableBookingModel &&
        other.allChargesModel == allChargesModel &&
        other.section == section &&
        other.outlet == outlet &&
        other.numberOfGuest == numberOfGuest &&
        other.bookingSlot == bookingSlot;
  }

  @override
  int get hashCode {
    return allChargesModel.hashCode ^
        section.hashCode ^
        outlet.hashCode ^
        numberOfGuest.hashCode ^
        bookingSlot.hashCode;
  }
}
