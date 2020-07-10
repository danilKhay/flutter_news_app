abstract class NewsListEvent {
  const NewsListEvent();
}

class FirstLoading extends NewsListEvent {

  @override
  String toString() => "FirstLoading";
}

class NewsListUpdate extends NewsListEvent {

  @override
  String toString() => "NewsListUpdate";
}

class NewsListCheckInDb extends NewsListEvent {
  @override
  String toString() => "NewsListCheckInDb";
}
