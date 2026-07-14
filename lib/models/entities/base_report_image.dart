class BaseReportImage {
  String id;
  String filePath;
  String thumbnailPath;
  String imageUrl;

  BaseReportImage(Map<String, dynamic> json)
      : id = json["id"],
        filePath = json["file"],
        thumbnailPath = json["thumbnail"] ?? json["imageUrl"] ?? json["file"],
        imageUrl = json["imageUrl"] ?? json["file"];
}
