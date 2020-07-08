import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class Searching extends SearchEvent {
  final String searchQuery;
  final int page;

  Searching(this.searchQuery, this.page);

  @override
  List<Object> get props => [searchQuery, page];
}

class LocalSearching extends SearchEvent {
  final String searchQuery;

  LocalSearching(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}