import 'package:equatable/equatable.dart';
import 'package:newsapp/repositories/models/news.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

abstract class NewsInfoEvent extends Equatable {
  const NewsInfoEvent();

  @override
  List<Object> get props => [];
}

class FetchNewsInfoFromNetwork extends NewsInfoEvent {
  final String title;

  FetchNewsInfoFromNetwork(this.title);

  @override
  List<Object> get props => [title];
}

class FetchNewsInfoFromDB extends NewsInfoEvent {
  final String title;

  FetchNewsInfoFromDB(this.title);

  @override
  List<Object> get props => [title];
}

class FetchNewsInfoFromLocal extends NewsInfoEvent {
  final NewsViewModel data;
  final bool timeAgoEnable;

  FetchNewsInfoFromLocal(this.data, {this.timeAgoEnable = true});

  @override
  List<Object> get props => [data];
}

class FetchNewsInfoFromDb extends NewsInfoEvent {
  final String title;
  final bool timeAgoEnable;

  FetchNewsInfoFromDb(this.title, {this.timeAgoEnable = true});

  @override
  List<Object> get props => [title];
}