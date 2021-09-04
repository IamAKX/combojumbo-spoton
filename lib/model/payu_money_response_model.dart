import 'dart:convert';

class PayUMoneyResponseModel {
  int id;
  String mode;
  String status;
  String unmappedstatus;
  String key;
  String txnid;
  String transactionFee;
  String amount;
  String cardCategory;
  String discount;
  String addedon;
  String productinfo;
  String firstname;
  String email;
  String phone;
  String udf1;
  String udf2;
  String udf3;
  String udf4;
  String udf5;
  String hash;
  String field4;
  String field5;
  String field7;
  String field8;
  String field9;
  String paymentSource;
  String pGTYPE;
  String ibiboCode;
  String errorCode;
  String errorMessage;
  String nameOnCard;
  String cardNo;
  int isSeamless;
  String surl;
  String furl;
  PayUMoneyResponseModel({
    required this.id,
    required this.mode,
    required this.status,
    required this.unmappedstatus,
    required this.key,
    required this.txnid,
    required this.transactionFee,
    required this.amount,
    required this.cardCategory,
    required this.discount,
    required this.addedon,
    required this.productinfo,
    required this.firstname,
    required this.email,
    required this.phone,
    required this.udf1,
    required this.udf2,
    required this.udf3,
    required this.udf4,
    required this.udf5,
    required this.hash,
    required this.field4,
    required this.field5,
    required this.field7,
    required this.field8,
    required this.field9,
    required this.paymentSource,
    required this.pGTYPE,
    required this.ibiboCode,
    required this.errorCode,
    required this.errorMessage,
    required this.nameOnCard,
    required this.cardNo,
    required this.isSeamless,
    required this.surl,
    required this.furl,
  });

  PayUMoneyResponseModel copyWith({
    int? id,
    String? mode,
    String? status,
    String? unmappedstatus,
    String? key,
    String? txnid,
    String? transactionFee,
    String? amount,
    String? cardCategory,
    String? discount,
    String? addedon,
    String? productinfo,
    String? firstname,
    String? email,
    String? phone,
    String? udf1,
    String? udf2,
    String? udf3,
    String? udf4,
    String? udf5,
    String? hash,
    String? field4,
    String? field5,
    String? field7,
    String? field8,
    String? field9,
    String? paymentSource,
    String? pGTYPE,
    String? ibiboCode,
    String? errorCode,
    String? errorMessage,
    String? nameOnCard,
    String? cardNo,
    int? isSeamless,
    String? surl,
    String? furl,
  }) {
    return PayUMoneyResponseModel(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      unmappedstatus: unmappedstatus ?? this.unmappedstatus,
      key: key ?? this.key,
      txnid: txnid ?? this.txnid,
      transactionFee: transactionFee ?? this.transactionFee,
      amount: amount ?? this.amount,
      cardCategory: cardCategory ?? this.cardCategory,
      discount: discount ?? this.discount,
      addedon: addedon ?? this.addedon,
      productinfo: productinfo ?? this.productinfo,
      firstname: firstname ?? this.firstname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      udf1: udf1 ?? this.udf1,
      udf2: udf2 ?? this.udf2,
      udf3: udf3 ?? this.udf3,
      udf4: udf4 ?? this.udf4,
      udf5: udf5 ?? this.udf5,
      hash: hash ?? this.hash,
      field4: field4 ?? this.field4,
      field5: field5 ?? this.field5,
      field7: field7 ?? this.field7,
      field8: field8 ?? this.field8,
      field9: field9 ?? this.field9,
      paymentSource: paymentSource ?? this.paymentSource,
      pGTYPE: pGTYPE ?? this.pGTYPE,
      ibiboCode: ibiboCode ?? this.ibiboCode,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
      nameOnCard: nameOnCard ?? this.nameOnCard,
      cardNo: cardNo ?? this.cardNo,
      isSeamless: isSeamless ?? this.isSeamless,
      surl: surl ?? this.surl,
      furl: furl ?? this.furl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mode': mode,
      'status': status,
      'unmappedstatus': unmappedstatus,
      'key': key,
      'txnid': txnid,
      'transactionFee': transactionFee,
      'amount': amount,
      'cardCategory': cardCategory,
      'discount': discount,
      'addedon': addedon,
      'productinfo': productinfo,
      'firstname': firstname,
      'email': email,
      'phone': phone,
      'udf1': udf1,
      'udf2': udf2,
      'udf3': udf3,
      'udf4': udf4,
      'udf5': udf5,
      'hash': hash,
      'field4': field4,
      'field5': field5,
      'field7': field7,
      'field8': field8,
      'field9': field9,
      'paymentSource': paymentSource,
      'pGTYPE': pGTYPE,
      'ibiboCode': ibiboCode,
      'errorCode': errorCode,
      'errorMessage': errorMessage,
      'nameOnCard': nameOnCard,
      'cardNo': cardNo,
      'isSeamless': isSeamless,
      'surl': surl,
      'furl': furl,
    };
  }

  factory PayUMoneyResponseModel.fromMap(Map<String, dynamic> map) {
    return PayUMoneyResponseModel(
      id: map['id'],
      mode: map['mode'],
      status: map['status'],
      unmappedstatus: map['unmappedstatus'],
      key: map['key'],
      txnid: map['txnid'],
      transactionFee: map['transactionFee'],
      amount: map['amount'],
      cardCategory: map['cardCategory'],
      discount: map['discount'],
      addedon: map['addedon'],
      productinfo: map['productinfo'],
      firstname: map['firstname'],
      email: map['email'],
      phone: map['phone'],
      udf1: map['udf1'],
      udf2: map['udf2'],
      udf3: map['udf3'],
      udf4: map['udf4'],
      udf5: map['udf5'],
      hash: map['hash'],
      field4: map['field4'],
      field5: map['field5'],
      field7: map['field7'],
      field8: map['field8'],
      field9: map['field9'],
      paymentSource: map['paymentSource'],
      pGTYPE: map['pGTYPE'],
      ibiboCode: map['ibiboCode'],
      errorCode: map['errorCode'],
      errorMessage: map['errorMessage'],
      nameOnCard: map['nameOnCard'],
      cardNo: map['cardNo'],
      isSeamless: map['isSeamless'],
      surl: map['surl'],
      furl: map['furl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PayUMoneyResponseModel.fromJson(String source) =>
      PayUMoneyResponseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PayUMoneyResponseModel(id: $id, mode: $mode, status: $status, unmappedstatus: $unmappedstatus, key: $key, txnid: $txnid, transactionFee: $transactionFee, amount: $amount, cardCategory: $cardCategory, discount: $discount, addedon: $addedon, productinfo: $productinfo, firstname: $firstname, email: $email, phone: $phone, udf1: $udf1, udf2: $udf2, udf3: $udf3, udf4: $udf4, udf5: $udf5, hash: $hash, field4: $field4, field5: $field5, field7: $field7, field8: $field8, field9: $field9, paymentSource: $paymentSource, pGTYPE: $pGTYPE, ibiboCode: $ibiboCode, errorCode: $errorCode, errorMessage: $errorMessage, nameOnCard: $nameOnCard, cardNo: $cardNo, isSeamless: $isSeamless, surl: $surl, furl: $furl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PayUMoneyResponseModel &&
        other.id == id &&
        other.mode == mode &&
        other.status == status &&
        other.unmappedstatus == unmappedstatus &&
        other.key == key &&
        other.txnid == txnid &&
        other.transactionFee == transactionFee &&
        other.amount == amount &&
        other.cardCategory == cardCategory &&
        other.discount == discount &&
        other.addedon == addedon &&
        other.productinfo == productinfo &&
        other.firstname == firstname &&
        other.email == email &&
        other.phone == phone &&
        other.udf1 == udf1 &&
        other.udf2 == udf2 &&
        other.udf3 == udf3 &&
        other.udf4 == udf4 &&
        other.udf5 == udf5 &&
        other.hash == hash &&
        other.field4 == field4 &&
        other.field5 == field5 &&
        other.field7 == field7 &&
        other.field8 == field8 &&
        other.field9 == field9 &&
        other.paymentSource == paymentSource &&
        other.pGTYPE == pGTYPE &&
        other.ibiboCode == ibiboCode &&
        other.errorCode == errorCode &&
        other.errorMessage == errorMessage &&
        other.nameOnCard == nameOnCard &&
        other.cardNo == cardNo &&
        other.isSeamless == isSeamless &&
        other.surl == surl &&
        other.furl == furl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        mode.hashCode ^
        status.hashCode ^
        unmappedstatus.hashCode ^
        key.hashCode ^
        txnid.hashCode ^
        transactionFee.hashCode ^
        amount.hashCode ^
        cardCategory.hashCode ^
        discount.hashCode ^
        addedon.hashCode ^
        productinfo.hashCode ^
        firstname.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        udf1.hashCode ^
        udf2.hashCode ^
        udf3.hashCode ^
        udf4.hashCode ^
        udf5.hashCode ^
        hash.hashCode ^
        field4.hashCode ^
        field5.hashCode ^
        field7.hashCode ^
        field8.hashCode ^
        field9.hashCode ^
        paymentSource.hashCode ^
        pGTYPE.hashCode ^
        ibiboCode.hashCode ^
        errorCode.hashCode ^
        errorMessage.hashCode ^
        nameOnCard.hashCode ^
        cardNo.hashCode ^
        isSeamless.hashCode ^
        surl.hashCode ^
        furl.hashCode;
  }
}
