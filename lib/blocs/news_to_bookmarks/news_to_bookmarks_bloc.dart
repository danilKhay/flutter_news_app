import 'package:bloc/bloc.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_event.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_state.dart';
import 'package:newsapp/repositories/news_to_bookmarks_repository.dart';

class NewsToBookmarksBloc
    extends Bloc<NewsToBookmarksEvent, NewsToBookmarksState> {
  final NewsToBookmarksRepository _newsToBookmarksRepository;

  NewsToBookmarksBloc(this._newsToBookmarksRepository)
      : assert(_newsToBookmarksRepository != null);

  @override
  NewsToBookmarksState get initialState => Initial();

  @override
  Stream<NewsToBookmarksState> mapEventToState(NewsToBookmarksEvent event) async*{
    if (event is SavingToBookmarks) {
      try {
        await _newsToBookmarksRepository.saveNewsToBookmark(event.news);
        yield SavedToBookmarks();
      } catch (_) {
        yield NewsToBookmarksFailed();
      }
    }
    if (event is RemovingFromBookmarks) {
      try {
        await _newsToBookmarksRepository.removeNewsFromBookmark(event.title);
        yield RemovedFromBookmarks();
      } catch (_) {
        yield NewsToBookmarksFailed();
      }
    }
  }
}
