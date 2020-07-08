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

  SearchLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class SearchFailed extends SearchState {
  final String text;

  const SearchFailed(this.text);
}

class SearchEmpty extends SearchState {}

class SearchResultEmpty extends SearchState {}

class SearchInit extends SearchState {}