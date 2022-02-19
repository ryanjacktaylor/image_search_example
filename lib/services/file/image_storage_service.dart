import 'package:gallery_saver/gallery_saver.dart';

class ImageStorageService {

  ImageStorageService._privateConstructor();

  static final ImageStorageService _instance = ImageStorageService._privateConstructor();

  static ImageStorageService get instance => _instance;

  Future<bool?> saveNetworkImage(String imageUrl) async {
    return await GallerySaver.saveImage(imageUrl);
  }
}