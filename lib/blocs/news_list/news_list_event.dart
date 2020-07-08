import 'package:equatable/equatable.dart';
import 'package:newsapp/repositories/models/news.dart';

abstract class NewsListEvent extends Equatable {
  const NewsListEvent();

  @override
  List<Object> get props => [];
}

class FirstLoading extends NewsListEvent {

  @override
  String toString() => "FirstLoading";
}
