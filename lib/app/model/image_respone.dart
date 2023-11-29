class ImageResponse {
  final String? base64Image;
  final List<String> textList;

  ImageResponse({this.base64Image, required this.textList});

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(
      base64Image: json['images'] as String?,
      textList: List<String>.from(json['list_text'] ?? []),
    );
  }
}
