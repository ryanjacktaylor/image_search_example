

import 'package:image_search_example/services/network/network_error.dart';
import 'package:image_search_example/services/network/search_service/models/image_result.dart';

class SearchResponse{
  List<ImageResult>? imageResults;
  NetworkError? error;

  SearchResponse({required this.imageResults});

  SearchResponse.error(this.error);

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    if (json["images_results"] == null) {
      return SearchResponse(imageResults: []);
    }
    List<ImageResult> imageResults = json["images_results"].map<ImageResult>((e) => ImageResult.fromJson(e)).toList();
    return SearchResponse(imageResults: imageResults);
  }
}