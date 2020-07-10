import 'package:equatable/equatable.dart';
import 'package:newsapp/repositories/models/short_news.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {
}

class SearchLoaded extends SearchState {
  final List<ShortNews> data;
  final bool hasReachedMax;
  final String searchQuery;
  final int page;

  SearchLoaded({this.data, this.hasReachedMax, this.searchQuery, this.page});

  SearchLoaded copyWith({List<ShortNews> data, bool hasReachedMax, String searchQuery, int page}) {
    return SearchLoaded(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [data, hasReachedMax];
}

class SearchFailed extends SearchState {
  final String text;

  const SearchFailed(this.text);
}

class SearchEmpty extends SearchState {}

class SearchResultEmpty extends SearchState {}

class SearchInit extends SearchState {}