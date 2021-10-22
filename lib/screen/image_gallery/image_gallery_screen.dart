import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/screen/image_gallery/image_gallery_model.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:gallery_view/gallery_view.dart';
import 'package:provider/provider.dart';

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({Key? key}) : super(key: key);
  static const String IMAGE_GALLERY_ROUTE = '/imageGalleryScreen';

  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  late ProfileManagementService _profileManagementService;
  List<ImageGalleryModel> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _profileManagementService.fetchImageGallery(context).then(
        (value) {
          setState(() {
            list = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _profileManagementService = Provider.of<ProfileManagementService>(context);
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Our Gallery'),
      ),
      body: _profileManagementService.status == ProfileStatus.Ideal
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _profileManagementService.status == ProfileStatus.Failed
              ? Center(
                  child: Text('Gallery is empty'),
                )
              : body(),
    );
  }

  body() {
    List<String> urlList = list.map((e) => e.image.trim()).toList();
    return GalleryView(
      imageUrlList: urlList,
      key: UniqueKey(),
    );
    // return GridView.builder(
    //   padding: EdgeInsets.all(5),
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
    //   itemCount: list.length,
    //   itemBuilder: (context, index) {
    //     return CachedNetworkImage(
    //       imageUrl: list.elementAt(index).image.trim(),
    //       progressIndicatorBuilder: (context, url, downloadProgress) => Center(
    //         child: CircularProgressIndicator(value: downloadProgress.progress),
    //       ),
    //       errorWidget: (context, url, error) => Icon(Icons.error),
    //       width: 100,
    //       height: 100,
    //       fit: BoxFit.cover,
    //     );
    //   },
    // );
  }
}
