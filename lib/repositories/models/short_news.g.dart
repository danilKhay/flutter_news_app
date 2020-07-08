// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortNewsList _$ShortNewsListFromJson(Map<String, dynamic> json) {
  return ShortNewsList(
    status: json['status'] as String,
    data: (json['articles'] as List)
        ?.map((e) =>
            e == null ? null : ShortNews.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ShortNewsListToJson(ShortNewsList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'articles': instance.data,
    };

ShortNews _$ShortNewsFromJson(Map<String, dynamic> json) {
  return ShortNews(
    title: json['title'] as String,
    source: json['source'] == null
        ? null
        : Source.fromJson(json['source'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ShortNewsToJson(ShortNews instance) => <String, dynamic>{
      'title': instance.title,
      'source': instance.source,
    };
