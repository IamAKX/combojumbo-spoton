import 'dart:convert';

class CJRouteOptionModel {
  String name;
  String image;
  String redirectionUrl;
  CJRouteOptionModel({
    required this.name,
    required this.image,
    required this.redirectionUrl,
  });

  CJRouteOptionModel copyWith({
    String? name,
    String? image,
    String? redirectionUrl,
  }) {
    return CJRouteOptionModel(
      name: name ?? this.name,
      image: image ?? this.image,
      redirectionUrl: redirectionUrl ?? this.redirectionUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'redirectionUrl': redirectionUrl,
    };
  }

  factory CJRouteOptionModel.fromMap(Map<String, dynamic> map) {
    return CJRouteOptionModel(
      name: map['name'],
      image: map['image'],
      redirectionUrl: map['redirectionUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CJRouteOptionModel.fromJson(String source) =>
      CJRouteOptionModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CJRouteOptionModel(name: $name, image: $image, redirectionUrl: $redirectionUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CJRouteOptionModel &&
        other.name == name &&
        other.image == image &&
        other.redirectionUrl == redirectionUrl;
  }

  @override
  int get hashCode => name.hashCode ^ image.hashCode ^ redirectionUrl.hashCode;
}
