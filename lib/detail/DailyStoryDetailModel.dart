class DailyStoryDetailModel {
  String? body;
  String? imageHue;
  String? title;
  String? url;
  String? image;
  String? shareUrl;
  String? gaPrefix;
  List<String>? images;
  int? type;
  int? id;
  List<String>? css;

  DailyStoryDetailModel(
      {this.body,
      this.imageHue,
      this.title,
      this.url,
      this.image,
      this.shareUrl,
      this.gaPrefix,
      this.images,
      this.type,
      this.id,
      this.css});

  DailyStoryDetailModel.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    imageHue = json['image_hue'];
    title = json['title'];
    url = json['url'];
    image = json['image'];
    shareUrl = json['share_url'];
    gaPrefix = json['ga_prefix'];
    images = json['images'].cast<String>();
    type = json['type'];
    id = json['id'];
    css = json['css'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['image_hue'] = this.imageHue;
    data['title'] = this.title;
    data['url'] = this.url;
    data['image'] = this.image;
    data['share_url'] = this.shareUrl;
    data['ga_prefix'] = this.gaPrefix;
    data['images'] = this.images;
    data['type'] = this.type;
    data['id'] = this.id;
    data['css'] = this.css;
    return data;
  }
}
