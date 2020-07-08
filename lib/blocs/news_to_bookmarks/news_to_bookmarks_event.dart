import 'package:equatable/equatable.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

abstract class NewsToBookmarksEvent extends Equatable {
  const NewsToBookmarksEvent();

  @override
  List<Object> get props => [];
}

class SavingToBookmarks extends NewsToBookmarksEvent {
  final NewsViewModel news;

  SavingToBookmarks(this.news) : assert(news != null);

  @override
  List<Object> get props => [news];
}

class RemovingFromBookmarks extends NewsToBookmarksEvent {
  final String title;

  RemovingFromBookmarks(this.title) : assert(title != null);

  @override
  List<Object> get props => [title];
}