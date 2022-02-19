class ImageResult {
  final int position;
  final String thumbnail;
  final String source;
  final String title;
  final String link;
  final String original;
  bool? isProduct;

  ImageResult({required this.position,
    required this.thumbnail,
    required this.source,
    required this.title,
    required this.link,
    required this.original,
    required this.isProduct});

  factory ImageResult.fromJson(Map<String, dynamic> json) {
    return ImageResult(position: json['position'],
        thumbnail: json['thumbnail'],
        source: json['source'],
        title: json['title'],
        link: json['link'],
        original: json['original'],
        isProduct: json['is_product']);
  }
}
