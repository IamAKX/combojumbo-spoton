import 'dart:convert';

class VideoGalleryModel {
  String image;
  String link;
  VideoGalleryModel({
    required this.image,
    required this.link,
  });

  VideoGalleryModel copyWith({
    String? image,
    String? link,
  }) {
    return VideoGalleryModel(
      image: image ?? this.image,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'link': link,
    };
  }

  factory VideoGalleryModel.fromMap(Map<String, dynamic> map) {
    return VideoGalleryModel(
      image: map['image'],
      link: map['link'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoGalleryModel.fromJson(String source) =>
      VideoGalleryModel.fromMap(json.decode(source));

  @override
  String toString() => 'VideoGalleryModel(image: $image, link: $link)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoGalleryModel &&
        other.image == image &&
        other.link == link;
  }

  @override
  int get hashCode => image.hashCode ^ link.hashCode;
}
