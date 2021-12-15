import 'dart:io';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:cjspoton/widgets/phone_edittext_with_heading.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);
  static const String UPDATE_PROFILE_ROUTE = '/updateProfileRoute';

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late ProfileManagementService _profileManagementService;

  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  File? imageFile = null;
  late UserModel user;
  final cropKey = GlobalKey<CropState>();

  pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // imageFile = File(image.path);
      // imageFile = await ImageCropper.cropImage(
      //     sourcePath: image.path,
      //     aspectRatioPresets: [
      //       CropAspectRatioPreset.square,

      //       // CropAspectRatioPreset.ratio3x2,
      //       // CropAspectRatioPreset.original,
      //       // CropAspectRatioPreset.ratio4x3,
      //       // CropAspectRatioPreset.ratio16x9
      //     ],
      //     cropStyle: CropStyle.circle,
      //     maxHeight: 100,
      //     maxWidth: 100,
      //     compressQuality: 99,
      //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      //     androidUiSettings: AndroidUiSettings(
      //         toolbarTitle: 'Profile Image',
      //         toolbarColor: bgColor,
      //         toolbarWidgetColor: primaryColor,
      //         initAspectRatio: CropAspectRatioPreset.square,
      //         lockAspectRatio: true),
      //     iosUiSettings: IOSUiSettings(
      //       minimumAspectRatio: 1.0,
      //       aspectRatioLockEnabled: true,
      //       title: 'Profile Image',
      //       resetAspectRatioEnabled: true,
      //       aspectRatioLockDimensionSwapEnabled: true,
      //       aspectRatioPickerButtonHidden: true,
      //     ));
      imageFile = await ImageCrop.sampleImage(
        file: File(image.path),
        preferredSize: context.size!.longestSide.ceil(),
      );

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _profileManagementService = Provider.of<ProfileManagementService>(context);
    SnackBarService.instance.buildContext = context;
    user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    _nameCtrl.text = user.name;
    _emailCtrl.text = user.email;
    _phoneCtrl.text = user.phone;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: ListView(
          children: [
            InkWell(
              onTap: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.storage,
                  Permission.manageExternalStorage,
                ].request();

                await pickProfileImage();
              },
              child: Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageFile == null
                            ? NetworkImage(
                                user.profileImage.isEmpty
                                    ? 'http://www.ansonika.com/fooyes/img/avatar1.jpg'
                                    : user.profileImage,
                                scale: 1,
                              )
                            : FileImage(
                                imageFile!,
                                scale: 1,
                              ) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // child: CircleAvatar(
              //   radius: 60,
              //   backgroundImage: imageFile == null
              //       ? NetworkImage(
              //           user.profileImage.isEmpty
              //               ? 'http://www.ansonika.com/fooyes/img/avatar1.jpg'
              //               : user.profileImage,
              //           scale: 1,
              //         )
              //       : FileImage(
              //           imageFile!,
              //           scale: 5,
              //         ) as ImageProvider,
              // ),
            ),
            CustomTextFieldWithHeading(
              teCtrl: _nameCtrl,
              hint: 'Name',
              inputType: TextInputType.name,
            ),
            CustomTextFieldWithHeading(
              teCtrl: _emailCtrl,
              hint: 'Email',
              inputType: TextInputType.emailAddress,
            ),
            PhoneTextFieldWithHeading(
              phoneCtrl: _phoneCtrl,
              hint: 'Phone Number',
            ),
            SizedBox(
              height: defaultPadding,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed:
                    _profileManagementService.status == ProfileStatus.Loading
                        ? null
                        : () {
                            _profileManagementService.updateProfile(
                                _nameCtrl.text,
                                _emailCtrl.text,
                                _phoneCtrl.text,
                                imageFile,
                                context);
                          },
                child: Text(
                  _profileManagementService.status == ProfileStatus.Loading
                      ? 'Loading...'
                      : 'Update Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
