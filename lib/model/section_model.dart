import 'dart:convert';

class SectionModel {
  String id;
  String selectedOutlet;
  String sectionname;
  String guest;
  SectionModel({
    required this.id,
    required this.selectedOutlet,
    required this.sectionname,
    required this.guest,
  });

  SectionModel copyWith({
    String? id,
    String? selectedOutlet,
    String? sectionname,
    String? guest,
  }) {
    return SectionModel(
      id: id ?? this.id,
      selectedOutlet: selectedOutlet ?? this.selectedOutlet,
      sectionname: sectionname ?? this.sectionname,
      guest: guest ?? this.guest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'selectedOutlet': selectedOutlet,
      'sectionname': sectionname,
      'guest': guest,
    };
  }

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    return SectionModel(
      id: map['id'],
      selectedOutlet: map['selectedOutlet'],
      sectionname: map['sectionname'],
      guest: map['guest'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SectionModel.fromJson(String source) =>
      SectionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SectionModel(id: $id, selectedOutlet: $selectedOutlet, sectionname: $sectionname, guest: $guest)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SectionModel &&
        other.id == id &&
        other.selectedOutlet == selectedOutlet &&
        other.sectionname == sectionname &&
        other.guest == guest;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        selectedOutlet.hashCode ^
        sectionname.hashCode ^
        guest.hashCode;
  }
}
