class ImageOption {
  final String imageId;
  final String imgName;

  ImageOption({required this.imageId, required this.imgName});

  factory ImageOption.fromJson(Map<String, dynamic> json) {
    return ImageOption(
      imageId: json['image_id'],
      imgName: json['img_name'],
    );
  }
}
