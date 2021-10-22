import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cjspoton/screen/faq/ques_ans_model.dart';

class FAQModel {
  String catid;
  String categoryname;
  List<QuesAnsModel> faqlist;
  FAQModel({
    required this.catid,
    required this.categoryname,
    required this.faqlist,
  });

  FAQModel copyWith({
    String? catid,
    String? categoryname,
    List<QuesAnsModel>? faqlist,
  }) {
    return FAQModel(
      catid: catid ?? this.catid,
      categoryname: categoryname ?? this.categoryname,
      faqlist: faqlist ?? this.faqlist,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'catid': catid,
      'categoryname': categoryname,
      'faqlist': faqlist.map((x) => x.toMap()).toList(),
    };
  }

  factory FAQModel.fromMap(Map<String, dynamic> map) {
    return FAQModel(
      catid: map['catid'],
      categoryname: map['categoryname'],
      faqlist: List<QuesAnsModel>.from(
          map['faqlist']?.map((x) => QuesAnsModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FAQModel.fromJson(String source) =>
      FAQModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FAQModel(catid: $catid, categoryname: $categoryname, faqlist: $faqlist)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FAQModel &&
        other.catid == catid &&
        other.categoryname == categoryname &&
        listEquals(other.faqlist, faqlist);
  }

  @override
  int get hashCode => catid.hashCode ^ categoryname.hashCode ^ faqlist.hashCode;
}
