import 'dart:convert';

class ReviewModel {
  String review;
  String name;
  ReviewModel({
    required this.review,
    required this.name,
  });

  ReviewModel copyWith({
    String? review,
    String? name,
  }) {
    return ReviewModel(
      review: review ?? this.review,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'review': review,
      'name': name,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      review: map['review'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source));

  @override
  String toString() => 'ReviewModel(review: $review, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewModel && other.review == review && other.name == name;
  }

  @override
  int get hashCode => review.hashCode ^ name.hashCode;
}
