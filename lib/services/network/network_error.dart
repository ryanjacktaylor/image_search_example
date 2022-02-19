class NetworkError {
  NetworkError(this.message);

  NetworkError.server()
      : message = 'Server not found';

  factory NetworkError.fromJson(Map<String, dynamic> json) {
    return NetworkError(json['error'] ?? 'Unknown Error');
  }

  String message;
}
