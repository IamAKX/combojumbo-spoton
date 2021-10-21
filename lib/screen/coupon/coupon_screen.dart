import 'package:cjspoton/model/coupon_discount_detail_model.dart';
import 'package:cjspoton/model/coupon_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);
  static const String COUPON_ROUTE = '/couponRoute';

  @override
  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  List<CouponModel> couponList = [];
  late CartServices _cartServices;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _cartServices.getAllCoupon(context).then(
            (value) => couponList = value,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _cartServices = Provider.of<CartServices>(context);
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: couponList.isNotEmpty ? greyedBgColor : bgColor,
      appBar: AppBar(
        title: Text('Apply Coupon'),
        backgroundColor: bgColor,
        centerTitle: false,
      ),
      body: _cartServices.status == CartStatus.Loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : couponList.isEmpty
              ? Center(
                  child: Text('No coupon available'),
                )
              : body(),
    );
  }

  body() {
    return ListView.builder(
      itemCount: couponList.length,
      itemBuilder: (context, index) {
        return Container(
          color: bgColor,
          margin: EdgeInsets.only(bottom: 1),
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getCouponCodeLabel('${couponList.elementAt(index).code}'),
                  InkWell(
                    onTap: () async {
                      late CouponDiscountDetailModel discountDetailModel;
                      await _cartServices
                          .verifyCoupon(
                              couponList.elementAt(index).code,
                              CartHelper.getTotalPriceOfCart().toString(),
                              context)
                          .then((value) {
                        discountDetailModel = value!;
                        Navigator.of(_scaffoldKey.currentContext!)
                            .pop(discountDetailModel);
                      });
                    },
                    child: Text(
                      'APPLY',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          ?.copyWith(color: primaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text('${couponList.elementAt(index).description}'),
            ],
          ),
        );
      },
    );
  }

  Container getCouponCodeLabel(String code) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Image.asset(
            'assets/images/notification_icon.png',
            color: primaryColor,
            width: 20,
          ),
          SizedBox(
            width: defaultPadding,
          ),
          Text(
            '$code',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        border: Border.all(
          color: primaryColor,
        ),
      ),
    );
  }
}
