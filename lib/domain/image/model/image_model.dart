class ImageModel {
  final String url;

  ImageModel({
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      ImageModel(url: json['filename']);

  Map<String, dynamic> toJson() => {'url': url};
}
