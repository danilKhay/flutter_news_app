import 'package:bloc/bloc.dart';
import 'package:newsapp/blocs/bookmarks/bookmarks_event.dart';
import 'package:newsapp/blocs/bookmarks/bookmarks_state.dart';
import 'package:newsapp/repositories/bookmarks_page_repository.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final BookmarksPageRepository bookmarksPageRepository;

  BookmarksBloc(this.bookmarksPageRepository) : super(Loading());

  @override
  Stream<BookmarksState> mapEventToState(BookmarksEvent event) async*{
    if (event is FetchBookmarks) {
      final data = await this.bookmarksPageRepository.fetchData();
      if (data.isNotEmpty) {
        yield Loaded(data);
      } else {
        yield BookmarksEmpty();
      }
    }
  }
}