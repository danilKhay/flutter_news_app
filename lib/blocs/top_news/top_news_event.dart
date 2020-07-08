import 'package:equatable/equatable.dart';

abstract class TopNewsEvent extends Equatable {
  const TopNewsEvent();

  @override
  List<Object> get props => [];
}

class TopNewsFetched extends TopNewsEvent {

  @override
  String toString() => "TopShortNewsFetched";
}
