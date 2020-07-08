abstract class NewsToBookmarksState {
  const NewsToBookmarksState();
}

class NewsToBookmarksFailed extends NewsToBookmarksState {}
class RemovedFromBookmarks extends NewsToBookmarksState {}
class SavedToBookmarks extends NewsToBookmarksState {}
class Initial extends NewsToBookmarksState {}