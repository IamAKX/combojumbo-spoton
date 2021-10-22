import 'dart:io';

import 'package:cjspoton/screen/order/order_detail.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:reviews_slider/reviews_slider.dart';

class OrderFeedback extends StatefulWidget {
  const OrderFeedback({Key? key, required this.orderDetailModel})
      : super(key: key);
  static const String ORDER_FEEDBACK_ROUTE = '/orderFeedbackScreen';
  final OrderDetailModel orderDetailModel;

  @override
  _OrderFeedbackState createState() => _OrderFeedbackState();
}

class _OrderFeedbackState extends State<OrderFeedback> {
  int quality = 2;
  int service = 2;
  int punctuality = 2;
  int price = 2;
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController reviewCtrl = TextEditingController();
  TextEditingController _imageAttachment = TextEditingController();
  File? imageFile = null;
  late CartServices _cartServices;

  @override
  Widget build(BuildContext context) {
    _cartServices = Provider.of<CartServices>(context);
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: bgColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Write a Review',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              'ORDER #${widget.orderDetailModel.order.id}',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      backgroundColor: bgColor,
      body: body(),
    );
  }

  body() {
    return ListView(
      padding: EdgeInsets.all(defaultPadding),
      children: [
        Text(
          '    Food Quality : ${quality + 1}',
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        ReviewSlider(
          circleDiameter: 55,
          onChange: (index) {
            setState(() {
              quality = index;
            });
          },
        ),
        Text(
          '    Service : ${service + 1}',
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        ReviewSlider(
          circleDiameter: 55,
          onChange: (index) {
            setState(() {
              service = index;
            });
          },
        ),
        Text(
          '    Punctuality : ${punctuality + 1}',
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        ReviewSlider(
          circleDiameter: 55,
          onChange: (index) {
            setState(() {
              punctuality = index;
            });
          },
        ),
        Text(
          '    Price : ${price + 1}',
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        ReviewSlider(
          circleDiameter: 55,
          onChange: (index) {
            setState(() {
              price = index;
            });
          },
        ),
        CustomTextFieldWithHeading(
            teCtrl: titleCtrl,
            hint: 'Title of your review',
            inputType: TextInputType.text),
        Text(
          'Your review',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
        TextField(
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          autocorrect: true,
          controller: reviewCtrl,
          decoration: InputDecoration(
            hintText:
                'Write your review to help others learn about this online business.',
            focusColor: primaryColor,
            alignLabelWithHint: false,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            hoverColor: primaryColor,
            hintStyle: TextStyle(color: hintColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
            ),
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        InkWell(
          onTap: () async {
            if (await Permission.storage.request().isGranted) {
              // Either the permission was already granted before or the user just granted it.
              pickImage();
            } else {
              SnackBarService.instance.showSnackBarError(
                  'Please grant storage permission to access gallery image');
            }
          },
          child: CustomTextFieldWithHeading(
            teCtrl: _imageAttachment,
            hint: 'Attach Image (Optional)',
            inputType: TextInputType.text,
            enabled: false,
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        TextButton(
          onPressed: _cartServices.status == CartStatus.Loading
              ? null
              : () {
                  _cartServices.sendOrderReview(
                      quality,
                      service,
                      punctuality,
                      price,
                      titleCtrl.text,
                      reviewCtrl.text,
                      context,
                      imageFile,
                      widget.orderDetailModel);
                },
          child: Text(
            _cartServices.status == CartStatus.Loading
                ? 'Loading...'
                : 'Submit',
            style: Theme.of(context).textTheme.button?.copyWith(color: bgColor),
          ),
        ),
        SizedBox(
          height: defaultPadding * 2,
        ),
      ],
    );
  }

  String formatOrderTime(String? date_creation) {
    String formatedTimestamp = '';
    DateTime dateTime = DateTime.parse(date_creation!);
    formatedTimestamp = DateFormat('MMMM dd, hh:mm a').format(dateTime);
    return formatedTimestamp;
  }

  pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      _imageAttachment.text = image.path.split('/').last;
    }
  }
}
