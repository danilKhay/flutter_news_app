import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class Searching extends SearchEvent {
  final String searchQuery;

  Searching(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}

class FirstSearching extends SearchEvent {
  final String searchQuery;

  FirstSearching(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}

class LocalSearching extends SearchEvent {
  final String searchQuery;

  LocalSearching(this.searchQuery);

  @override
  List<Object> get props => [searchQuery];
}

class SearchClean extends SearchEvent {

}