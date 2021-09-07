import 'dart:convert';

import 'package:cjspoton/model/city_model.dart';
import 'package:cjspoton/model/state_model.dart';

class AddressModel {
  String id;
  String pincode;
  String address1;
  String address2;
  String landmark;
  CityModel city;
  StateModel stateModel;
  String deliveryInstruction;
  String addressType; 
  AddressModel({
    required this.id,
    required this.pincode,
    required this.address1,
    required this.address2,
    required this.landmark,
    required this.city,
    required this.stateModel,
    required this.deliveryInstruction,
    required this.addressType,
  });

  AddressModel copyWith({
    String? id,
    String? pincode,
    String? address1,
    String? address2,
    String? landmark,
    CityModel? city,
    StateModel? stateModel,
    String? deliveryInstruction,
    String? addressType,
  }) {
    return AddressModel(
      id: id ?? this.id,
      pincode: pincode ?? this.pincode,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      stateModel: stateModel ?? this.stateModel,
      deliveryInstruction: deliveryInstruction ?? this.deliveryInstruction,
      addressType: addressType ?? this.addressType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pincode': pincode,
      'address1': address1,
      'address2': address2,
      'landmark': landmark,
      'city': city.toMap(),
      'stateModel': stateModel.toMap(),
      'deliveryInstruction': deliveryInstruction,
      'addressType': addressType,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      pincode: map['pincode'],
      address1: map['address1'],
      address2: map['address2'],
      landmark: map['landmark'],
      city: CityModel.fromMap(map['city']),
      stateModel: StateModel.fromMap(map['stateModel']),
      deliveryInstruction: map['deliveryInstruction'],
      addressType: map['addressType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressModel(id: $id, pincode: $pincode, address1: $address1, address2: $address2, landmark: $landmark, city: $city, stateModel: $stateModel, deliveryInstruction: $deliveryInstruction, addressType: $addressType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.id == id &&
        other.pincode == pincode &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.landmark == landmark &&
        other.city == city &&
        other.stateModel == stateModel &&
        other.deliveryInstruction == deliveryInstruction &&
        other.addressType == addressType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pincode.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        landmark.hashCode ^
        city.hashCode ^
        stateModel.hashCode ^
        deliveryInstruction.hashCode ^
        addressType.hashCode;
  }
}
