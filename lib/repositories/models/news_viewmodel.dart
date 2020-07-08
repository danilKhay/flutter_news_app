import 'package:newsapp/repositories/db/db_models.dart';
import 'package:newsapp/repositories/models/news.dart';

class NewsViewModel {
  final String title;
  final String imageUrl;
  final String content;
  final DateTime time;
  final String sourceName;
  bool isSavedToBookmark;

  NewsViewModel(
      this.title, this.imageUrl, this.content, this.time, this.sourceName,
      {this.isSavedToBookmark = false});

  factory NewsViewModel.mapFromNews(News news, bool isSavedToBookmark) {
    return NewsViewModel(
        news.title, news.imageUrl, news.content, news.time, news.source.name,
        isSavedToBookmark: isSavedToBookmark);
  }

  factory NewsViewModel.mapFromBookmark(Bookmark bookmark) {
    return NewsViewModel(
      bookmark.title, bookmark.imageUrl, bookmark.content, bookmark.dateTime,
      bookmark.sourceName, isSavedToBookmark: true);
  }

  factory NewsViewModel.mapFromCache(Cache cache, bool isSavedToBookmark) {
    return NewsViewModel(
        cache.title, cache.imageUrl, cache.content, cache.dateTime,
        cache.sourceName, isSavedToBookmark: isSavedToBookmark
    );
  }

  Cache mapToCache(NewsViewModel newsViewModel) =>
      Cache(
        title: newsViewModel.title,
        imageUrl: newsViewModel.imageUrl,
        content: newsViewModel.content,
        dateTime: newsViewModel.time,
        sourceName: newsViewModel.sourceName,
        sourceImageUrl: newsViewModel.imageUrl
      );
}
