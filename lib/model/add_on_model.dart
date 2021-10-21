import 'dart:convert';

import 'package:cjspoton/model/add_on_model_item.dart';
import 'package:flutter/foundation.dart';

class AddOnModel {
  String id;
  String Mainheading;
  String Type;
  String Requirement;
  String Maxqnt;
  List<AddOnItemModel> subaddons;
  AddOnModel({
    required this.id,
    required this.Mainheading,
    required this.Type,
    required this.Requirement,
    required this.Maxqnt,
    required this.subaddons,
  });

  AddOnModel copyWith({
    String? id,
    String? Mainheading,
    String? Type,
    String? Requirement,
    String? Maxqnt,
    List<AddOnItemModel>? subaddons,
  }) {
    return AddOnModel(
      id: id ?? this.id,
      Mainheading: Mainheading ?? this.Mainheading,
      Type: Type ?? this.Type,
      Requirement: Requirement ?? this.Requirement,
      Maxqnt: Maxqnt ?? this.Maxqnt,
      subaddons: subaddons ?? this.subaddons,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Mainheading': Mainheading,
      'Type': Type,
      'Requirement': Requirement,
      'Maxqnt': Maxqnt,
      'subaddons': subaddons.map((x) => x.toMap()).toList(),
    };
  }

  factory AddOnModel.fromMap(Map<String, dynamic> map) {
    return AddOnModel(
      id: map['id'],
      Mainheading: map['Mainheading'],
      Type: map['Type'],
      Requirement: map['Requirement'],
      Maxqnt: map['Maxqnt'],
      subaddons: List<AddOnItemModel>.from(
          map['subaddons']?.map((x) => AddOnItemModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddOnModel.fromJson(String source) =>
      AddOnModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddOnModel(id: $id, Mainheading: $Mainheading, Type: $Type, Requirement: $Requirement, Maxqnt: $Maxqnt, subaddons: $subaddons)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddOnModel &&
        other.id == id &&
        other.Mainheading == Mainheading &&
        other.Type == Type &&
        other.Requirement == Requirement &&
        other.Maxqnt == Maxqnt &&
        listEquals(other.subaddons, subaddons);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        Mainheading.hashCode ^
        Type.hashCode ^
        Requirement.hashCode ^
        Maxqnt.hashCode ^
        subaddons.hashCode;
  }
}
