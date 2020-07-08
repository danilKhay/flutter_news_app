import 'package:equatable/equatable.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

abstract class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object> get props => [];
}

class Loading extends BookmarksState {

}

class Loaded extends BookmarksState {
  final List<NewsViewModel> data;

  Loaded(this.data);

  @override
  List<Object> get props => [data];
}

class Failed extends BookmarksState {
}

class BookmarksEmpty extends BookmarksState {
}

