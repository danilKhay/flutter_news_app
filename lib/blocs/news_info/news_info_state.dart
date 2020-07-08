import 'package:equatable/equatable.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

abstract class NewsInfoState extends Equatable {
  const NewsInfoState();

  @override
  List<Object> get props => [];
}

class NewsInfoLoading extends NewsInfoState {}

class NewsInfoLoaded extends NewsInfoState {
  final NewsViewModel data;
  final bool timeAgoEnable;

  NewsInfoLoaded(this.data, {this.timeAgoEnable = true});

  @override
  List<Object> get props => [data];
}

class NewsInfoFailed extends NewsInfoState {
  final String info;

  NewsInfoFailed(this.info);

  @override
  List<Object> get props => [info];
}