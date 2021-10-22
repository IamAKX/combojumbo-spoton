import 'dart:convert';

class QuesAnsModel {
  String id;
  String ques;
  String ans;
  QuesAnsModel({
    required this.id,
    required this.ques,
    required this.ans,
  });

  QuesAnsModel copyWith({
    String? id,
    String? ques,
    String? ans,
  }) {
    return QuesAnsModel(
      id: id ?? this.id,
      ques: ques ?? this.ques,
      ans: ans ?? this.ans,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ques': ques,
      'ans': ans,
    };
  }

  factory QuesAnsModel.fromMap(Map<String, dynamic> map) {
    return QuesAnsModel(
      id: map['id'],
      ques: map['ques'],
      ans: map['ans'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuesAnsModel.fromJson(String source) => QuesAnsModel.fromMap(json.decode(source));

  @override
  String toString() => 'QuesAnsModel(id: $id, ques: $ques, ans: $ans)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QuesAnsModel &&
      other.id == id &&
      other.ques == ques &&
      other.ans == ans;
  }

  @override
  int get hashCode => id.hashCode ^ ques.hashCode ^ ans.hashCode;
}
