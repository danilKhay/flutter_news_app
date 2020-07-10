import 'package:newsapp/repositories/models/news_viewmodel.dart';

abstract class TopNewsState {
  const TopNewsState();
}

class TopNewsLoading extends TopNewsState {}

class TopNewsLoaded extends TopNewsState {
  final NewsViewModel data;

  TopNewsLoaded(this.data);

  @override
  String toString() => "Loaded: {data : $data}";
}

class TopNewsFailure extends TopNewsState {
  final String text;

  const TopNewsFailure(this.text);

}