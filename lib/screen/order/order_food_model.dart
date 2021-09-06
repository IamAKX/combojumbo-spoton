import 'dart:convert';

class OrderFoodModel {
  String id;
  String relid;
  String oid;
  String pro_id;
  String qty;
  String price;
  String discountprice;
  String calculateprice;
  String productname;
  String status;
  String cust_id;
  String combooffer;
  String remark;
  String outletid;
  String addrecordid;
  String date;
  String addons;
  String addonsfoodrelated;
  String sequenceid;
  String foodidrelatedaddons;
  String kotid;
  String addonsrelation;
  String payment_id;
  String type;
  String addonslebel;
  String addonslebelid;
  String partypacks;
  String app;
  OrderFoodModel({
    required this.id,
    required this.relid,
    required this.oid,
    required this.pro_id,
    required this.qty,
    required this.price,
    required this.discountprice,
    required this.calculateprice,
    required this.productname,
    required this.status,
    required this.cust_id,
    required this.combooffer,
    required this.remark,
    required this.outletid,
    required this.addrecordid,
    required this.date,
    required this.addons,
    required this.addonsfoodrelated,
    required this.sequenceid,
    required this.foodidrelatedaddons,
    required this.kotid,
    required this.addonsrelation,
    required this.payment_id,
    required this.type,
    required this.addonslebel,
    required this.addonslebelid,
    required this.partypacks,
    required this.app,
  });

  OrderFoodModel copyWith({
    String? id,
    String? relid,
    String? oid,
    String? pro_id,
    String? qty,
    String? price,
    String? discountprice,
    String? calculateprice,
    String? productname,
    String? status,
    String? cust_id,
    String? combooffer,
    String? remark,
    String? outletid,
    String? addrecordid,
    String? date,
    String? addons,
    String? addonsfoodrelated,
    String? sequenceid,
    String? foodidrelatedaddons,
    String? kotid,
    String? addonsrelation,
    String? payment_id,
    String? type,
    String? addonslebel,
    String? addonslebelid,
    String? partypacks,
    String? app,
  }) {
    return OrderFoodModel(
      id: id ?? this.id,
      relid: relid ?? this.relid,
      oid: oid ?? this.oid,
      pro_id: pro_id ?? this.pro_id,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      discountprice: discountprice ?? this.discountprice,
      calculateprice: calculateprice ?? this.calculateprice,
      productname: productname ?? this.productname,
      status: status ?? this.status,
      cust_id: cust_id ?? this.cust_id,
      combooffer: combooffer ?? this.combooffer,
      remark: remark ?? this.remark,
      outletid: outletid ?? this.outletid,
      addrecordid: addrecordid ?? this.addrecordid,
      date: date ?? this.date,
      addons: addons ?? this.addons,
      addonsfoodrelated: addonsfoodrelated ?? this.addonsfoodrelated,
      sequenceid: sequenceid ?? this.sequenceid,
      foodidrelatedaddons: foodidrelatedaddons ?? this.foodidrelatedaddons,
      kotid: kotid ?? this.kotid,
      addonsrelation: addonsrelation ?? this.addonsrelation,
      payment_id: payment_id ?? this.payment_id,
      type: type ?? this.type,
      addonslebel: addonslebel ?? this.addonslebel,
      addonslebelid: addonslebelid ?? this.addonslebelid,
      partypacks: partypacks ?? this.partypacks,
      app: app ?? this.app,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'relid': relid,
      'oid': oid,
      'pro_id': pro_id,
      'qty': qty,
      'price': price,
      'discountprice': discountprice,
      'calculateprice': calculateprice,
      'productname': productname,
      'status': status,
      'cust_id': cust_id,
      'combooffer': combooffer,
      'remark': remark,
      'outletid': outletid,
      'addrecordid': addrecordid,
      'date': date,
      'addons': addons,
      'addonsfoodrelated': addonsfoodrelated,
      'sequenceid': sequenceid,
      'foodidrelatedaddons': foodidrelatedaddons,
      'kotid': kotid,
      'addonsrelation': addonsrelation,
      'payment_id': payment_id,
      'type': type,
      'addonslebel': addonslebel,
      'addonslebelid': addonslebelid,
      'partypacks': partypacks,
      'app': app,
    };
  }

  factory OrderFoodModel.fromMap(Map<String, dynamic> map) {
    return OrderFoodModel(
      id: map['id'],
      relid: map['relid'],
      oid: map['oid'],
      pro_id: map['pro_id'],
      qty: map['qty'],
      price: map['price'],
      discountprice: map['discountprice'],
      calculateprice: map['calculateprice'],
      productname: map['productname'],
      status: map['status'],
      cust_id: map['cust_id'],
      combooffer: map['combooffer'],
      remark: map['remark'],
      outletid: map['outletid'],
      addrecordid: map['addrecordid'],
      date: map['date'],
      addons: map['addons'],
      addonsfoodrelated: map['addonsfoodrelated'],
      sequenceid: map['sequenceid'],
      foodidrelatedaddons: map['foodidrelatedaddons'],
      kotid: map['kotid'],
      addonsrelation: map['addonsrelation'],
      payment_id: map['payment_id'],
      type: map['type'],
      addonslebel: map['addonslebel'],
      addonslebelid: map['addonslebelid'],
      partypacks: map['partypacks'],
      app: map['app'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderFoodModel.fromJson(String source) =>
      OrderFoodModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderFoodModel(id: $id, relid: $relid, oid: $oid, pro_id: $pro_id, qty: $qty, price: $price, discountprice: $discountprice, calculateprice: $calculateprice, productname: $productname, status: $status, cust_id: $cust_id, combooffer: $combooffer, remark: $remark, outletid: $outletid, addrecordid: $addrecordid, date: $date, addons: $addons, addonsfoodrelated: $addonsfoodrelated, sequenceid: $sequenceid, foodidrelatedaddons: $foodidrelatedaddons, kotid: $kotid, addonsrelation: $addonsrelation, payment_id: $payment_id, type: $type, addonslebel: $addonslebel, addonslebelid: $addonslebelid, partypacks: $partypacks, app: $app)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderFoodModel &&
        other.id == id &&
        other.relid == relid &&
        other.oid == oid &&
        other.pro_id == pro_id &&
        other.qty == qty &&
        other.price == price &&
        other.discountprice == discountprice &&
        other.calculateprice == calculateprice &&
        other.productname == productname &&
        other.status == status &&
        other.cust_id == cust_id &&
        other.combooffer == combooffer &&
        other.remark == remark &&
        other.outletid == outletid &&
        other.addrecordid == addrecordid &&
        other.date == date &&
        other.addons == addons &&
        other.addonsfoodrelated == addonsfoodrelated &&
        other.sequenceid == sequenceid &&
        other.foodidrelatedaddons == foodidrelatedaddons &&
        other.kotid == kotid &&
        other.addonsrelation == addonsrelation &&
        other.payment_id == payment_id &&
        other.type == type &&
        other.addonslebel == addonslebel &&
        other.addonslebelid == addonslebelid &&
        other.partypacks == partypacks &&
        other.app == app;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        relid.hashCode ^
        oid.hashCode ^
        pro_id.hashCode ^
        qty.hashCode ^
        price.hashCode ^
        discountprice.hashCode ^
        calculateprice.hashCode ^
        productname.hashCode ^
        status.hashCode ^
        cust_id.hashCode ^
        combooffer.hashCode ^
        remark.hashCode ^
        outletid.hashCode ^
        addrecordid.hashCode ^
        date.hashCode ^
        addons.hashCode ^
        addonsfoodrelated.hashCode ^
        sequenceid.hashCode ^
        foodidrelatedaddons.hashCode ^
        kotid.hashCode ^
        addonsrelation.hashCode ^
        payment_id.hashCode ^
        type.hashCode ^
        addonslebel.hashCode ^
        addonslebelid.hashCode ^
        partypacks.hashCode ^
        app.hashCode;
  }
}
