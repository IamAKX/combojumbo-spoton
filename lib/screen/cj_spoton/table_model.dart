import 'dart:convert';

class TableModel {
  String table_name;
  String table_id;
  String book;
  String? color;
  String? order_id;
  TableModel({
    required this.table_name,
    required this.table_id,
    required this.book,
    this.color,
    this.order_id,
  });

  TableModel copyWith({
    String? table_name,
    String? table_id,
    String? book,
    String? color,
    String? order_id,
  }) {
    return TableModel(
      table_name: table_name ?? this.table_name,
      table_id: table_id ?? this.table_id,
      book: book ?? this.book,
      color: color ?? this.color,
      order_id: order_id ?? this.order_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'table_name': table_name,
      'table_id': table_id,
      'book': book,
      'color': color,
      'order_id': order_id,
    };
  }

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      table_name: map['table_name'],
      table_id: map['table_id'],
      book: map['book'],
      color: map['color'] != null ? map['color'] : null,
      order_id: map['order_id'] != null ? map['order_id'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TableModel.fromJson(String source) =>
      TableModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TableModel(table_name: $table_name, table_id: $table_id, book: $book, color: $color, order_id: $order_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableModel &&
        other.table_name == table_name &&
        other.table_id == table_id &&
        other.book == book &&
        other.color == color &&
        other.order_id == order_id;
  }

  @override
  int get hashCode {
    return table_name.hashCode ^
        table_id.hashCode ^
        book.hashCode ^
        color.hashCode ^
        order_id.hashCode;
  }
}
