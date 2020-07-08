import 'package:json_annotation/json_annotation.dart';

import 'news.dart';
part 'short_news.g.dart';

@JsonSerializable()
class ShortNewsList {
  final String status;
  @JsonKey(name: "articles")
  final List<ShortNews> data;

  ShortNewsList({this.status, this.data});

  factory ShortNewsList.fromJson(Map<String, dynamic> json) => _$ShortNewsListFromJson(json);
}

@JsonSerializable()
class ShortNews {
  final String title;
  @JsonKey(name: "source")
  final Source source;

  ShortNews({this.title, this.source});

  factory ShortNews.fromJson(Map<String, dynamic> json) => _$ShortNewsFromJson(json);
}
