import 'dart:convert';

class OutletModel {
  String outletId;
  String outletName;
  OutletModel({
    required this.outletId,
    required this.outletName,
  });

  OutletModel copyWith({
    String? outletId,
    String? outletName,
  }) {
    return OutletModel(
      outletId: outletId ?? this.outletId,
      outletName: outletName ?? this.outletName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'outletId': outletId,
      'outletName': outletName,
    };
  }

  factory OutletModel.fromMap(Map<String, dynamic> map) {
    return OutletModel(
      outletId: map['outletId'],
      outletName: map['outletName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OutletModel.fromJson(String source) =>
      OutletModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'OutletModel(outletId: $outletId, outletName: $outletName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OutletModel &&
        other.outletId == outletId &&
        other.outletName == outletName;
  }

  @override
  int get hashCode => outletId.hashCode ^ outletName.hashCode;
}
