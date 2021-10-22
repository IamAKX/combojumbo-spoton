import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/screen/video_gallery/video_fullscreen.dart';
import 'package:cjspoton/screen/video_gallery/video_gallery_model.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoGalleryScreen extends StatefulWidget {
  const VideoGalleryScreen({Key? key}) : super(key: key);
  static const String VIDEO_GALLERY_ROUTE = '/videoGalleryScreen';

  @override
  _VideoGalleryScreenState createState() => _VideoGalleryScreenState();
}

class _VideoGalleryScreenState extends State<VideoGalleryScreen> {
  late ProfileManagementService _profileManagementService;
  List<VideoGalleryModel> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _profileManagementService.fetchVideoGallery(context).then(
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
        title: Text('Videos'),
      ),
      body: _profileManagementService.status == ProfileStatus.Ideal
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _profileManagementService.status == ProfileStatus.Failed
              ? Center(
                  child: Text('Video Gallery is empty'),
                )
              : body(),
    );
  }

  body() {
    return GridView.builder(
      padding: EdgeInsets.all(5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            String vID = Utilities()
                .getYoutubeVideoId(list.elementAt(index).link.trim());
            Navigator.of(context).pushNamed(
                VideoPlayerScreen.VIDEO_PLAYER_ROUTE,
                arguments: vID);
          },
          child: Hero(
            tag: Utilities()
                .getYoutubeVideoId(list.elementAt(index).link.trim()),
            child: CachedNetworkImage(
              imageUrl: list.elementAt(index).image.trim(),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
