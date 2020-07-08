import 'package:equatable/equatable.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

abstract class TopNewsState extends Equatable {
  const TopNewsState();

  @override
  List<Object> get props => [];
}

class TopNewsLoading extends TopNewsState {}

class TopNewsLoaded extends TopNewsState {
  final NewsViewModel data;

  TopNewsLoaded(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => "Loaded: {data : $data}";
}

class TopNewsFailure extends TopNewsState {
  final String text;

  const TopNewsFailure(this.text);

}