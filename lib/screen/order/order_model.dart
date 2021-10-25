import 'dart:convert';

class OrderModel {
  String id;
  String trans_id;
  String cust_id;
  String oid;
  String coupon_code;
  String coupon_type;
  String coupon_minimum;
  String coupon_maximum;
  String coupon_orignal_discount;
  String wheelcoupon;
  String coupon_value;
  String subtotal;
  String coupon_discountamount;
  String delivery_charge;
  String gst;
  String gst_amount;
  String service_charge;
  String packging_charge;
  String total_amount;
  String date_creation;
  String genrated_by;
  String payment_type;
  String status;
  String order_status;
  String ordertype;
  String whosorderadd_id;
  String order_addrole;
  String delivery_boy_id;
  String delivery_boy_name;
  String delivery_otp;
  String link_uid;
  String noofpeopletable;
  String tablebook;
  String randpaymeny;
  String outletid;
  String addrecordid;
  String waiter_tip;
  String txnid;
  String cart_id;
  String address_id;
  String delivey_who;
  String uricko_token;
  String uricko_status;
  String table_booking_id;
  String adjust_amount_table;
  String refund_amount;
  String paid_amount;
  String showorderid;
  String app;
  OrderModel({
    required this.id,
    required this.trans_id,
    required this.cust_id,
    required this.oid,
    required this.coupon_code,
    required this.coupon_type,
    required this.coupon_minimum,
    required this.coupon_maximum,
    required this.coupon_orignal_discount,
    required this.wheelcoupon,
    required this.coupon_value,
    required this.subtotal,
    required this.coupon_discountamount,
    required this.delivery_charge,
    required this.gst,
    required this.gst_amount,
    required this.service_charge,
    required this.packging_charge,
    required this.total_amount,
    required this.date_creation,
    required this.genrated_by,
    required this.payment_type,
    required this.status,
    required this.order_status,
    required this.ordertype,
    required this.whosorderadd_id,
    required this.order_addrole,
    required this.delivery_boy_id,
    required this.delivery_boy_name,
    required this.delivery_otp,
    required this.link_uid,
    required this.noofpeopletable,
    required this.tablebook,
    required this.randpaymeny,
    required this.outletid,
    required this.addrecordid,
    required this.waiter_tip,
    required this.txnid,
    required this.cart_id,
    required this.address_id,
    required this.delivey_who,
    required this.uricko_token,
    required this.uricko_status,
    required this.table_booking_id,
    required this.adjust_amount_table,
    required this.refund_amount,
    required this.paid_amount,
    required this.showorderid,
    required this.app,
  });

  OrderModel copyWith({
    String? id,
    String? trans_id,
    String? cust_id,
    String? oid,
    String? coupon_code,
    String? coupon_type,
    String? coupon_minimum,
    String? coupon_maximum,
    String? coupon_orignal_discount,
    String? wheelcoupon,
    String? coupon_value,
    String? subtotal,
    String? coupon_discountamount,
    String? delivery_charge,
    String? gst,
    String? gst_amount,
    String? service_charge,
    String? packging_charge,
    String? total_amount,
    String? date_creation,
    String? genrated_by,
    String? payment_type,
    String? status,
    String? order_status,
    String? ordertype,
    String? whosorderadd_id,
    String? order_addrole,
    String? delivery_boy_id,
    String? delivery_boy_name,
    String? delivery_otp,
    String? link_uid,
    String? noofpeopletable,
    String? tablebook,
    String? randpaymeny,
    String? outletid,
    String? addrecordid,
    String? waiter_tip,
    String? txnid,
    String? cart_id,
    String? address_id,
    String? delivey_who,
    String? uricko_token,
    String? uricko_status,
    String? table_booking_id,
    String? adjust_amount_table,
    String? refund_amount,
    String? paid_amount,
    String? showorderid,
    String? app,
  }) {
    return OrderModel(
      id: id ?? this.id,
      trans_id: trans_id ?? this.trans_id,
      cust_id: cust_id ?? this.cust_id,
      oid: oid ?? this.oid,
      coupon_code: coupon_code ?? this.coupon_code,
      coupon_type: coupon_type ?? this.coupon_type,
      coupon_minimum: coupon_minimum ?? this.coupon_minimum,
      coupon_maximum: coupon_maximum ?? this.coupon_maximum,
      coupon_orignal_discount:
          coupon_orignal_discount ?? this.coupon_orignal_discount,
      wheelcoupon: wheelcoupon ?? this.wheelcoupon,
      coupon_value: coupon_value ?? this.coupon_value,
      subtotal: subtotal ?? this.subtotal,
      coupon_discountamount:
          coupon_discountamount ?? this.coupon_discountamount,
      delivery_charge: delivery_charge ?? this.delivery_charge,
      gst: gst ?? this.gst,
      gst_amount: gst_amount ?? this.gst_amount,
      service_charge: service_charge ?? this.service_charge,
      packging_charge: packging_charge ?? this.packging_charge,
      total_amount: total_amount ?? this.total_amount,
      date_creation: date_creation ?? this.date_creation,
      genrated_by: genrated_by ?? this.genrated_by,
      payment_type: payment_type ?? this.payment_type,
      status: status ?? this.status,
      order_status: order_status ?? this.order_status,
      ordertype: ordertype ?? this.ordertype,
      whosorderadd_id: whosorderadd_id ?? this.whosorderadd_id,
      order_addrole: order_addrole ?? this.order_addrole,
      delivery_boy_id: delivery_boy_id ?? this.delivery_boy_id,
      delivery_boy_name: delivery_boy_name ?? this.delivery_boy_name,
      delivery_otp: delivery_otp ?? this.delivery_otp,
      link_uid: link_uid ?? this.link_uid,
      noofpeopletable: noofpeopletable ?? this.noofpeopletable,
      tablebook: tablebook ?? this.tablebook,
      randpaymeny: randpaymeny ?? this.randpaymeny,
      outletid: outletid ?? this.outletid,
      addrecordid: addrecordid ?? this.addrecordid,
      waiter_tip: waiter_tip ?? this.waiter_tip,
      txnid: txnid ?? this.txnid,
      cart_id: cart_id ?? this.cart_id,
      address_id: address_id ?? this.address_id,
      delivey_who: delivey_who ?? this.delivey_who,
      uricko_token: uricko_token ?? this.uricko_token,
      uricko_status: uricko_status ?? this.uricko_status,
      table_booking_id: table_booking_id ?? this.table_booking_id,
      adjust_amount_table: adjust_amount_table ?? this.adjust_amount_table,
      refund_amount: refund_amount ?? this.refund_amount,
      paid_amount: paid_amount ?? this.paid_amount,
      showorderid: showorderid ?? this.showorderid,
      app: app ?? this.app,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trans_id': trans_id,
      'cust_id': cust_id,
      'oid': oid,
      'coupon_code': coupon_code,
      'coupon_type': coupon_type,
      'coupon_minimum': coupon_minimum,
      'coupon_maximum': coupon_maximum,
      'coupon_orignal_discount': coupon_orignal_discount,
      'wheelcoupon': wheelcoupon,
      'coupon_value': coupon_value,
      'subtotal': subtotal,
      'coupon_discountamount': coupon_discountamount,
      'delivery_charge': delivery_charge,
      'gst': gst,
      'gst_amount': gst_amount,
      'service_charge': service_charge,
      'packging_charge': packging_charge,
      'total_amount': total_amount,
      'date_creation': date_creation,
      'genrated_by': genrated_by,
      'payment_type': payment_type,
      'status': status,
      'order_status': order_status,
      'ordertype': ordertype,
      'whosorderadd_id': whosorderadd_id,
      'order_addrole': order_addrole,
      'delivery_boy_id': delivery_boy_id,
      'delivery_boy_name': delivery_boy_name,
      'delivery_otp': delivery_otp,
      'link_uid': link_uid,
      'noofpeopletable': noofpeopletable,
      'tablebook': tablebook,
      'randpaymeny': randpaymeny,
      'outletid': outletid,
      'addrecordid': addrecordid,
      'waiter_tip': waiter_tip,
      'txnid': txnid,
      'cart_id': cart_id,
      'address_id': address_id,
      'delivey_who': delivey_who,
      'uricko_token': uricko_token,
      'uricko_status': uricko_status,
      'table_booking_id': table_booking_id,
      'adjust_amount_table': adjust_amount_table,
      'refund_amount': refund_amount,
      'paid_amount': paid_amount,
      'showorderid': showorderid,
      'app': app,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      trans_id: map['trans_id'],
      cust_id: map['cust_id'],
      oid: map['oid'],
      coupon_code: map['coupon_code'],
      coupon_type: map['coupon_type'],
      coupon_minimum: map['coupon_minimum'],
      coupon_maximum: map['coupon_maximum'],
      coupon_orignal_discount: map['coupon_orignal_discount'],
      wheelcoupon: map['wheelcoupon'],
      coupon_value: map['coupon_value'],
      subtotal: map['subtotal'],
      coupon_discountamount: map['coupon_discountamount'],
      delivery_charge: map['delivery_charge'],
      gst: map['gst'],
      gst_amount: map['gst_amount'],
      service_charge: map['service_charge'],
      packging_charge: map['packging_charge'],
      total_amount: map['total_amount'],
      date_creation: map['date_creation'],
      genrated_by: map['genrated_by'],
      payment_type: map['payment_type'],
      status: map['status'],
      order_status: map['order_status'],
      ordertype: map['ordertype'],
      whosorderadd_id: map['whosorderadd_id'],
      order_addrole: map['order_addrole'],
      delivery_boy_id: map['delivery_boy_id'],
      delivery_boy_name: map['delivery_boy_name'],
      delivery_otp: map['delivery_otp'],
      link_uid: map['link_uid'],
      noofpeopletable: map['noofpeopletable'],
      tablebook: map['tablebook'],
      randpaymeny: map['randpaymeny'],
      outletid: map['outletid'],
      addrecordid: map['addrecordid'],
      waiter_tip: map['waiter_tip'],
      txnid: map['txnid'],
      cart_id: map['cart_id'],
      address_id: map['address_id'],
      delivey_who: map['delivey_who'],
      uricko_token: map['uricko_token'],
      uricko_status: map['uricko_status'],
      table_booking_id: map['table_booking_id'],
      adjust_amount_table: map['adjust_amount_table'],
      refund_amount: map['refund_amount'],
      paid_amount: map['paid_amount'],
      showorderid: map['showorderid'],
      app: map['app'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(id: $id, trans_id: $trans_id, cust_id: $cust_id, oid: $oid, coupon_code: $coupon_code, coupon_type: $coupon_type, coupon_minimum: $coupon_minimum, coupon_maximum: $coupon_maximum, coupon_orignal_discount: $coupon_orignal_discount, wheelcoupon: $wheelcoupon, coupon_value: $coupon_value, subtotal: $subtotal, coupon_discountamount: $coupon_discountamount, delivery_charge: $delivery_charge, gst: $gst, gst_amount: $gst_amount, service_charge: $service_charge, packging_charge: $packging_charge, total_amount: $total_amount, date_creation: $date_creation, genrated_by: $genrated_by, payment_type: $payment_type, status: $status, order_status: $order_status, ordertype: $ordertype, whosorderadd_id: $whosorderadd_id, order_addrole: $order_addrole, delivery_boy_id: $delivery_boy_id, delivery_boy_name: $delivery_boy_name, delivery_otp: $delivery_otp, link_uid: $link_uid, noofpeopletable: $noofpeopletable, tablebook: $tablebook, randpaymeny: $randpaymeny, outletid: $outletid, addrecordid: $addrecordid, waiter_tip: $waiter_tip, txnid: $txnid, cart_id: $cart_id, address_id: $address_id, delivey_who: $delivey_who, uricko_token: $uricko_token, uricko_status: $uricko_status, table_booking_id: $table_booking_id, adjust_amount_table: $adjust_amount_table, refund_amount: $refund_amount, paid_amount: $paid_amount, showorderid: $showorderid, app: $app)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.id == id &&
        other.trans_id == trans_id &&
        other.cust_id == cust_id &&
        other.oid == oid &&
        other.coupon_code == coupon_code &&
        other.coupon_type == coupon_type &&
        other.coupon_minimum == coupon_minimum &&
        other.coupon_maximum == coupon_maximum &&
        other.coupon_orignal_discount == coupon_orignal_discount &&
        other.wheelcoupon == wheelcoupon &&
        other.coupon_value == coupon_value &&
        other.subtotal == subtotal &&
        other.coupon_discountamount == coupon_discountamount &&
        other.delivery_charge == delivery_charge &&
        other.gst == gst &&
        other.gst_amount == gst_amount &&
        other.service_charge == service_charge &&
        other.packging_charge == packging_charge &&
        other.total_amount == total_amount &&
        other.date_creation == date_creation &&
        other.genrated_by == genrated_by &&
        other.payment_type == payment_type &&
        other.status == status &&
        other.order_status == order_status &&
        other.ordertype == ordertype &&
        other.whosorderadd_id == whosorderadd_id &&
        other.order_addrole == order_addrole &&
        other.delivery_boy_id == delivery_boy_id &&
        other.delivery_boy_name == delivery_boy_name &&
        other.delivery_otp == delivery_otp &&
        other.link_uid == link_uid &&
        other.noofpeopletable == noofpeopletable &&
        other.tablebook == tablebook &&
        other.randpaymeny == randpaymeny &&
        other.outletid == outletid &&
        other.addrecordid == addrecordid &&
        other.waiter_tip == waiter_tip &&
        other.txnid == txnid &&
        other.cart_id == cart_id &&
        other.address_id == address_id &&
        other.delivey_who == delivey_who &&
        other.uricko_token == uricko_token &&
        other.uricko_status == uricko_status &&
        other.table_booking_id == table_booking_id &&
        other.adjust_amount_table == adjust_amount_table &&
        other.refund_amount == refund_amount &&
        other.paid_amount == paid_amount &&
        other.showorderid == showorderid &&
        other.app == app;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        trans_id.hashCode ^
        cust_id.hashCode ^
        oid.hashCode ^
        coupon_code.hashCode ^
        coupon_type.hashCode ^
        coupon_minimum.hashCode ^
        coupon_maximum.hashCode ^
        coupon_orignal_discount.hashCode ^
        wheelcoupon.hashCode ^
        coupon_value.hashCode ^
        subtotal.hashCode ^
        coupon_discountamount.hashCode ^
        delivery_charge.hashCode ^
        gst.hashCode ^
        gst_amount.hashCode ^
        service_charge.hashCode ^
        packging_charge.hashCode ^
        total_amount.hashCode ^
        date_creation.hashCode ^
        genrated_by.hashCode ^
        payment_type.hashCode ^
        status.hashCode ^
        order_status.hashCode ^
        ordertype.hashCode ^
        whosorderadd_id.hashCode ^
        order_addrole.hashCode ^
        delivery_boy_id.hashCode ^
        delivery_boy_name.hashCode ^
        delivery_otp.hashCode ^
        link_uid.hashCode ^
        noofpeopletable.hashCode ^
        tablebook.hashCode ^
        randpaymeny.hashCode ^
        outletid.hashCode ^
        addrecordid.hashCode ^
        waiter_tip.hashCode ^
        txnid.hashCode ^
        cart_id.hashCode ^
        address_id.hashCode ^
        delivey_who.hashCode ^
        uricko_token.hashCode ^
        uricko_status.hashCode ^
        table_booking_id.hashCode ^
        adjust_amount_table.hashCode ^
        refund_amount.hashCode ^
        paid_amount.hashCode ^
        showorderid.hashCode ^
        app.hashCode;
  }
}
