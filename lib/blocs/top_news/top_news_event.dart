abstract class TopNewsEvent {
  const TopNewsEvent();
}

class TopNewsFetched extends TopNewsEvent {

  @override
  String toString() => "TopShortNewsFetched";
}

class TopNewsCheckInDb extends TopNewsEvent {
  @override
  String toString() => "TopNewsCheckInDb";
}

class TopNewsUpdate extends TopNewsEvent {
}
