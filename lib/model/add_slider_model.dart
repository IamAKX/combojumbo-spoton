import 'dart:convert';

import 'package:flutter/material.dart';

class AddSliderCardModel {
  String text1;
  String text2;
  String text3;
  String imageLink;
  String redirection;
  dynamic arguments;
  Color color;
  AddSliderCardModel({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.imageLink,
    required this.redirection,
    required this.arguments,
    required this.color,
  });

  AddSliderCardModel copyWith({
    String? text1,
    String? text2,
    String? text3,
    String? imageLink,
    String? redirection,
    dynamic? arguments,
    Color? color,
  }) {
    return AddSliderCardModel(
      text1: text1 ?? this.text1,
      text2: text2 ?? this.text2,
      text3: text3 ?? this.text3,
      imageLink: imageLink ?? this.imageLink,
      redirection: redirection ?? this.redirection,
      arguments: arguments ?? this.arguments,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text1': text1,
      'text2': text2,
      'text3': text3,
      'imageLink': imageLink,
      'redirection': redirection,
      'arguments': arguments,
      'color': color.value,
    };
  }

  factory AddSliderCardModel.fromMap(Map<String, dynamic> map) {
    return AddSliderCardModel(
      text1: map['text1'],
      text2: map['text2'],
      text3: map['text3'],
      imageLink: map['imageLink'],
      redirection: map['redirection'],
      arguments: map['arguments'],
      color: Color(map['color']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddSliderCardModel.fromJson(String source) =>
      AddSliderCardModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddSliderCardModel(text1: $text1, text2: $text2, text3: $text3, imageLink: $imageLink, redirection: $redirection, arguments: $arguments, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddSliderCardModel &&
        other.text1 == text1 &&
        other.text2 == text2 &&
        other.text3 == text3 &&
        other.imageLink == imageLink &&
        other.redirection == redirection &&
        other.arguments == arguments &&
        other.color == color;
  }

  @override
  int get hashCode {
    return text1.hashCode ^
        text2.hashCode ^
        text3.hashCode ^
        imageLink.hashCode ^
        redirection.hashCode ^
        arguments.hashCode ^
        color.hashCode;
  }
}
