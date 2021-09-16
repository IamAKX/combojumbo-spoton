import 'dart:convert';

class OutletModel {
  String outletId;
  String outletName;
  String? address;
  String? image;
  OutletModel({
    required this.outletId,
    required this.outletName,
    required this.address,
    required this.image,
  });

  OutletModel copyWith({
    String? outletId,
    String? outletName,
    String? address,
    String? image,
  }) {
    return OutletModel(
      outletId: outletId ?? this.outletId,
      outletName: outletName ?? this.outletName,
      address: address ?? this.address,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'outletId': outletId,
      'outletName': outletName,
      'address': address,
      'image': image,
    };
  }

  factory OutletModel.fromMap(Map<String, dynamic> map) {
    return OutletModel(
      outletId: map['outletId'],
      outletName: map['outletName'],
      address: map['address'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OutletModel.fromJson(String source) =>
      OutletModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OutletModel(outletId: $outletId, outletName: $outletName, address: $address, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OutletModel &&
        other.outletId == outletId &&
        other.outletName == outletName &&
        other.address == address &&
        other.image == image;
  }

  @override
  int get hashCode {
    return outletId.hashCode ^
        outletName.hashCode ^
        address.hashCode ^
        image.hashCode;
  }
}
