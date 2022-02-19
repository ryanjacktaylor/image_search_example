
import 'package:flutter/material.dart';
import 'package:image_search_example/constants/app_colors.dart';
import 'package:image_search_example/services/file/image_storage_service.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({required this.imageUrl, Key? key}) : super(key: key);

  final String imageUrl;

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  bool showDownloadButton = true;
  bool mounted = true;

  @override
  void dispose() {
    mounted = false;
    super.dispose();
  }

  void saveImage(BuildContext context, String imgUrl) async {
    setState(() {
      showDownloadButton = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Saving Image..."),
    ));
    bool? success = await ImageStorageService.instance.saveNetworkImage(imgUrl);
    String message = 'Failed to save image';
    if (success != null && success) message = 'Image saved';
    await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    )).closed;
    if (mounted) {
      setState(() {
        showDownloadButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: showDownloadButton,
        child: FloatingActionButton(
          onPressed: () {
            saveImage(context, widget.imageUrl);
          },
          backgroundColor: AppColors.orange,
          child: const Icon(Icons.download),
        ),
      ),
      backgroundColor: AppColors.grey900,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: 40,
              height: 40,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                elevation: 0.0,
                fillColor: Colors.white,
                child: const Icon(
                  Icons.arrow_back,
                ),
                shape: const CircleBorder(),
              ),
            ),
            Center(
              child: Image.network(
                widget.imageUrl,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
