import 'dart:convert';

class CityModel {
  String id;
  String name;
  String state_id;
  CityModel({
    required this.id,
    required this.name,
    required this.state_id,
  });

  CityModel copyWith({
    String? id,
    String? name,
    String? state_id,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      state_id: state_id ?? this.state_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'state_id': state_id,
    };
  }

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'],
      name: map['name'],
      state_id: map['state_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CityModel.fromJson(String source) =>
      CityModel.fromMap(json.decode(source));

  @override
  String toString() => 'CityModel(id: $id, name: $name, state_id: $state_id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityModel &&
        other.id == id &&
        other.name == name &&
        other.state_id == state_id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ state_id.hashCode;
}
