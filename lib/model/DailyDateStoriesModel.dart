class DailyDateStoriesModel {
  String? date;
  List<Stories>? stories;
  List<TopStories>? topStories;

  DailyDateStoriesModel({this.date, this.stories, this.topStories});

  DailyDateStoriesModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['stories'] != null) {
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories!.add(new Stories.fromJson(v));
      });
    }
    if (json['top_stories'] != null) {
      topStories = <TopStories>[];
      json['top_stories'].forEach((v) {
        topStories!.add(new TopStories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.stories != null) {
      data['stories'] = this.stories!.map((v) => v.toJson()).toList();
    }
    if (this.topStories != null) {
      data['top_stories'] = this.topStories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stories {
  String? imageHue;
  String? title;
  String? url;
  String? hint;
  String? gaPrefix;
  List<String>? images;
  int? type;
  int? id;

  Stories(
      {this.imageHue,
      this.title,
      this.url,
      this.hint,
      this.gaPrefix,
      this.images,
      this.type,
      this.id});

  String image() {
    final _images = images ?? [];
    if (_images.length > 0) {
      return _images.first;
    }
    return "";
  }
   
  Stories.fromJson(Map<String, dynamic> json) {
    imageHue = json['image_hue'];
    title = json['title'];
    url = json['url'];
    hint = json['hint'];
    gaPrefix = json['ga_prefix'];
    images = json['images'].cast<String>();
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_hue'] = this.imageHue;
    data['title'] = this.title;
    data['url'] = this.url;
    data['hint'] = this.hint;
    data['ga_prefix'] = this.gaPrefix;
    data['images'] = this.images;
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

class TopStories {
  String? imageHue;
  String? hint;
  String? url;
  String? image;
  String? title;
  String? gaPrefix;
  int? type;
  int? id;

  TopStories(
      {this.imageHue,
      this.hint,
      this.url,
      this.image,
      this.title,
      this.gaPrefix,
      this.type,
      this.id});

  TopStories.fromJson(Map<String, dynamic> json) {
    imageHue = json['image_hue'];
    hint = json['hint'];
    url = json['url'];
    image = json['image'];
    title = json['title'];
    gaPrefix = json['ga_prefix'];
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_hue'] = this.imageHue;
    data['hint'] = this.hint;
    data['url'] = this.url;
    data['image'] = this.image;
    data['title'] = this.title;
    data['ga_prefix'] = this.gaPrefix;
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}
