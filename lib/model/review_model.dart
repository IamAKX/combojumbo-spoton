import 'dart:convert';

class ReviewModel {
  String review;
  String name;
  String title;
  ReviewModel({
    required this.review,
    required this.name,
    required this.title,
  });

  ReviewModel copyWith({
    String? review,
    String? name,
    String? title,
  }) {
    return ReviewModel(
      review: review ?? this.review,
      name: name ?? this.name,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'review': review,
      'name': name,
      'title': title,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      review: map['review'],
      name: map['name'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ReviewModel(review: $review, name: $name, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewModel &&
        other.review == review &&
        other.name == name &&
        other.title == title;
  }

  @override
  int get hashCode => review.hashCode ^ name.hashCode ^ title.hashCode;
}
