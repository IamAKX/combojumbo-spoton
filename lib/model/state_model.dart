import 'dart:convert';

class StateModel {
  String id;
  String name;
  String country_id;
  StateModel({
    required this.id,
    required this.name,
    required this.country_id,
  });

  StateModel copyWith({
    String? id,
    String? name,
    String? country_id,
  }) {
    return StateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      country_id: country_id ?? this.country_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country_id': country_id,
    };
  }

  factory StateModel.fromMap(Map<String, dynamic> map) {
    return StateModel(
      id: map['id'],
      name: map['name'],
      country_id: map['country_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StateModel.fromJson(String source) =>
      StateModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'StateModel(id: $id, name: $name, country_id: $country_id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StateModel &&
        other.id == id &&
        other.name == name &&
        other.country_id == country_id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ country_id.hashCode;
}
