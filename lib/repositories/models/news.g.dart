// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsList _$NewsListFromJson(Map<String, dynamic> json) {
  return NewsList(
    status: json['status'] as String,
    list: (json['articles'] as List)
        ?.map(
            (e) => e == null ? null : News.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NewsListToJson(NewsList instance) => <String, dynamic>{
      'status': instance.status,
      'articles': instance.list,
    };

News _$NewsFromJson(Map<String, dynamic> json) {
  return News(
    title: json['title'] as String,
    imageUrl: json['urlToImage'] as String,
    time: json['publishedAt'] == null
        ? null
        : DateTime.parse(json['publishedAt'] as String),
    source: json['source'] == null
        ? null
        : Source.fromJson(json['source'] as Map<String, dynamic>),
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'source': instance.source,
      'title': instance.title,
      'urlToImage': instance.imageUrl,
      'publishedAt': instance.time?.toIso8601String(),
      'content': instance.content,
    };

Source _$SourceFromJson(Map<String, dynamic> json) {
  return Source(
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
      'name': instance.name,
    };
