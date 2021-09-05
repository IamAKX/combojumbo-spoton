import 'dart:convert';

class AddressModel {
  String pincode;
  String completeAddress;
  String deliveryInstruction;
  String addressType;
  AddressModel({
    required this.pincode,
    required this.completeAddress,
    required this.deliveryInstruction,
    required this.addressType,
  });

  AddressModel copyWith({
    String? pincode,
    String? completeAddress,
    String? deliveryInstruction,
    String? addressType,
  }) {
    return AddressModel(
      pincode: pincode ?? this.pincode,
      completeAddress: completeAddress ?? this.completeAddress,
      deliveryInstruction: deliveryInstruction ?? this.deliveryInstruction,
      addressType: addressType ?? this.addressType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pincode': pincode,
      'completeAddress': completeAddress,
      'deliveryInstruction': deliveryInstruction,
      'addressType': addressType,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      pincode: map['pincode'],
      completeAddress: map['completeAddress'],
      deliveryInstruction: map['deliveryInstruction'],
      addressType: map['addressType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressModel(pincode: $pincode, completeAddress: $completeAddress, deliveryInstruction: $deliveryInstruction, addressType: $addressType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.pincode == pincode &&
        other.completeAddress == completeAddress &&
        other.deliveryInstruction == deliveryInstruction &&
        other.addressType == addressType;
  }

  @override
  int get hashCode {
    return pincode.hashCode ^
        completeAddress.hashCode ^
        deliveryInstruction.hashCode ^
        addressType.hashCode;
  }
}
