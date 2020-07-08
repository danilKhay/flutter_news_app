import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class NewsList {
  final String status;
  @JsonKey(name: "articles")
  final List<News> list;

  NewsList({this.status, this.list});

  factory NewsList.fromJson(Map<String, dynamic> json) => _$NewsListFromJson(json);
}

@JsonSerializable()
class News extends Equatable {
  final Source source;
  final String title;
  @JsonKey(name: "urlToImage")
  final String imageUrl;
  @JsonKey(name: "publishedAt")
  final DateTime time;
  final String content;
  static const String sourceImageUrl = "https://auto.mail.ru/img/common/share/news_1200x630.png";

  News({this.title, this.imageUrl, this.time, this.source, this.content});

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  @override
  List<Object> get props => [imageUrl, title, time];
}

@JsonSerializable()
class Source {
  final String name;

  Source({this.name});

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}