class Constants {
  static const String RUPEE = '₹';
}

extension StringExtension on String {
  String toCamelCase() {
    if (this.length == 0) return this;
    if (this.length > 1)
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    else
      return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
