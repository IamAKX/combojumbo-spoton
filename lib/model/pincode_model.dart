import 'dart:convert';

class PincodeModel {
  String id;
  String pincode;
  String charge;
  String status;
  String outletid;
  String location;
  PincodeModel({
    required this.id,
    required this.pincode,
    required this.charge,
    required this.status,
    required this.outletid,
    required this.location,
  });

  PincodeModel copyWith({
    String? id,
    String? pincode,
    String? charge,
    String? status,
    String? outletid,
    String? location,
  }) {
    return PincodeModel(
      id: id ?? this.id,
      pincode: pincode ?? this.pincode,
      charge: charge ?? this.charge,
      status: status ?? this.status,
      outletid: outletid ?? this.outletid,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pincode': pincode,
      'charge': charge,
      'status': status,
      'outletid': outletid,
      'location': location,
    };
  }

  factory PincodeModel.fromMap(Map<String, dynamic> map) {
    return PincodeModel(
      id: map['id'],
      pincode: map['pincode'],
      charge: map['charge'],
      status: map['status'],
      outletid: map['outletid'],
      location: map['location'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PincodeModel.fromJson(String source) =>
      PincodeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PincodeModel(id: $id, pincode: $pincode, charge: $charge, status: $status, outletid: $outletid, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PincodeModel &&
        other.id == id &&
        other.pincode == pincode &&
        other.charge == charge &&
        other.status == status &&
        other.outletid == outletid &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pincode.hashCode ^
        charge.hashCode ^
        status.hashCode ^
        outletid.hashCode ^
        location.hashCode;
  }
}
