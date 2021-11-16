import 'dart:convert';

class OfferDataModel {
  String? id;
  String? t1;
  String? t2;
  String? t3;
  String? color;
  String? type;
  String? link;
  String? image;
  String? status;
  String? date;
  String? outletid;
  OfferDataModel({
    this.id,
    this.t1,
    this.t2,
    this.t3,
    this.color,
    this.type,
    this.link,
    this.image,
    this.status,
    this.date,
    this.outletid,
  });

  OfferDataModel copyWith({
    String? id,
    String? t1,
    String? t2,
    String? t3,
    String? color,
    String? type,
    String? link,
    String? image,
    String? status,
    String? date,
    String? outletid,
  }) {
    return OfferDataModel(
      id: id ?? this.id,
      t1: t1 ?? this.t1,
      t2: t2 ?? this.t2,
      t3: t3 ?? this.t3,
      color: color ?? this.color,
      type: type ?? this.type,
      link: link ?? this.link,
      image: image ?? this.image,
      status: status ?? this.status,
      date: date ?? this.date,
      outletid: outletid ?? this.outletid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      't1': t1,
      't2': t2,
      't3': t3,
      'color': color,
      'type': type,
      'link': link,
      'image': image,
      'status': status,
      'date': date,
      'outletid': outletid,
    };
  }

  factory OfferDataModel.fromMap(Map<String, dynamic> map) {
    return OfferDataModel(
      id: map['id'] != null ? map['id'] : null,
      t1: map['t1'] != null ? map['t1'] : null,
      t2: map['t2'] != null ? map['t2'] : null,
      t3: map['t3'] != null ? map['t3'] : null,
      color: map['color'] != null ? map['color'] : null,
      type: map['type'] != null ? map['type'] : null,
      link: map['link'] != null ? map['link'] : null,
      image: map['image'] != null ? map['image'] : null,
      status: map['status'] != null ? map['status'] : null,
      date: map['date'] != null ? map['date'] : null,
      outletid: map['outletid'] != null ? map['outletid'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferDataModel.fromJson(String source) =>
      OfferDataModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OfferDataModel(id: $id, t1: $t1, t2: $t2, t3: $t3, color: $color, type: $type, link: $link, image: $image, status: $status, date: $date, outletid: $outletid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfferDataModel &&
        other.id == id &&
        other.t1 == t1 &&
        other.t2 == t2 &&
        other.t3 == t3 &&
        other.color == color &&
        other.type == type &&
        other.link == link &&
        other.image == image &&
        other.status == status &&
        other.date == date &&
        other.outletid == outletid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        t1.hashCode ^
        t2.hashCode ^
        t3.hashCode ^
        color.hashCode ^
        type.hashCode ^
        link.hashCode ^
        image.hashCode ^
        status.hashCode ^
        date.hashCode ^
        outletid.hashCode;
  }
}
