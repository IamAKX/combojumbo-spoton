import 'dart:convert';

import 'package:cjspoton/model/offer_data_model.dart';

class OfferItemModel {
  OfferDataModel? data;
  String? image;
  OfferItemModel({
    this.data,
    this.image,
  });

  OfferItemModel copyWith({
    OfferDataModel? data,
    String? image,
  }) {
    return OfferItemModel(
      data: data ?? this.data,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.toMap(),
      'image': image,
    };
  }

  factory OfferItemModel.fromMap(Map<String, dynamic> map) {
    return OfferItemModel(
      data: map['data'] != null ? OfferDataModel.fromMap(map['data']) : null,
      image: map['image'] != null ? map['image'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferItemModel.fromJson(String source) =>
      OfferItemModel.fromMap(json.decode(source));

  @override
  String toString() => 'OfferItemModel(data: $data, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfferItemModel &&
        other.data == data &&
        other.image == image;
  }

  @override
  int get hashCode => data.hashCode ^ image.hashCode;
}
