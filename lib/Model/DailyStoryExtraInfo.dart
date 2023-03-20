class DailyStoryExtraInfo {
  Count? count;
  int? voteStatus;
  bool? favorite;

  DailyStoryExtraInfo({this.count, this.voteStatus, this.favorite});

  DailyStoryExtraInfo.fromJson(Map<String, dynamic> json) {
    count = json['count'] != null ? new Count.fromJson(json['count']) : null;
    voteStatus = json['vote_status'];
    favorite = json['favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.count != null) {
      data['count'] = this.count!.toJson();
    }
    data['vote_status'] = this.voteStatus;
    data['favorite'] = this.favorite;
    return data;
  }
}

class Count {
  int? longComments;
  int? shortComments;
  int? comments;
  int? likes;

  Count({this.longComments, this.shortComments, this.comments, this.likes});

  Count.fromJson(Map<String, dynamic> json) {
    longComments = json['long_comments'];
    shortComments = json['short_comments'];
    comments = json['comments'];
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['long_comments'] = this.longComments;
    data['short_comments'] = this.shortComments;
    data['comments'] = this.comments;
    data['likes'] = this.likes;
    return data;
  }
}