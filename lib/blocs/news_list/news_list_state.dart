import 'package:equatable/equatable.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

abstract class NewsListState {
  const NewsListState();

}

class Loading extends NewsListState {

  @override
  String toString() => "Loading";
}

class Loaded extends NewsListState {
  final List<NewsViewModel> data;

  Loaded(this.data);

  @override
  String toString() => "Loaded: {data : $data}";
}

class Failed extends NewsListState {
  final String text;

  const Failed(this.text);
}