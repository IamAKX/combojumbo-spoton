import 'dart:convert';

class ImageGalleryModel {
  String image;
  String title;
  ImageGalleryModel({
    required this.image,
    required this.title,
  });

  ImageGalleryModel copyWith({
    String? image,
    String? title,
  }) {
    return ImageGalleryModel(
      image: image ?? this.image,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
    };
  }

  factory ImageGalleryModel.fromMap(Map<String, dynamic> map) {
    return ImageGalleryModel(
      image: map['image'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageGalleryModel.fromJson(String source) =>
      ImageGalleryModel.fromMap(json.decode(source));

  @override
  String toString() => 'ImageGalleryModel(image: $image, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageGalleryModel &&
        other.image == image &&
        other.title == title;
  }

  @override
  int get hashCode => image.hashCode ^ title.hashCode;
}
