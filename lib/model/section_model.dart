import 'dart:convert';

class SectionModel {
  String id;
  String selectedOutlet;
  String sectionname;
  String guest;
  String image;
  SectionModel({
    required this.id,
    required this.selectedOutlet,
    required this.sectionname,
    required this.guest,
    required this.image,
  });

  SectionModel copyWith({
    String? id,
    String? selectedOutlet,
    String? sectionname,
    String? guest,
    String? image,
  }) {
    return SectionModel(
      id: id ?? this.id,
      selectedOutlet: selectedOutlet ?? this.selectedOutlet,
      sectionname: sectionname ?? this.sectionname,
      guest: guest ?? this.guest,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'selectedOutlet': selectedOutlet,
      'sectionname': sectionname,
      'guest': guest,
      'image': image,
    };
  }

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    return SectionModel(
      id: map['id'],
      selectedOutlet: map['selectedOutlet'],
      sectionname: map['sectionname'],
      guest: map['guest'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SectionModel.fromJson(String source) =>
      SectionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SectionModel(id: $id, selectedOutlet: $selectedOutlet, sectionname: $sectionname, guest: $guest, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SectionModel &&
        other.id == id &&
        other.selectedOutlet == selectedOutlet &&
        other.sectionname == sectionname &&
        other.guest == guest &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        selectedOutlet.hashCode ^
        sectionname.hashCode ^
        guest.hashCode ^
        image.hashCode;
  }
}
