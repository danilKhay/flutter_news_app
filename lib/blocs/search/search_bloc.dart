import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:newsapp/blocs/search/search_event.dart';
import 'package:newsapp/blocs/search/search_state.dart';
import 'package:newsapp/repositories/search_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({@required this.searchRepository})
      : assert(searchRepository != null),
        super(SearchInit());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    final currentState = state;
    if (event is FirstSearching) {
      final searchQuery = event.searchQuery;
      if (searchQuery.isEmpty) {
        yield SearchEmpty();
        return;
      } else {
        yield SearchLoading();
        try {
          final data = await searchRepository.searchNews(searchQuery, 1);
          if (data.isEmpty) {
            yield SearchResultEmpty();
          } else {
            if (data.length < searchRepository.pageSizeInt) {
              yield SearchLoaded(
                data: data,
                page: 0,
                searchQuery: searchQuery,
                hasReachedMax: true,
              );
            } else {
              yield SearchLoaded(
                data: data,
                page: 0,
                searchQuery: searchQuery,
                hasReachedMax: false,
              );
            }

          }
        } catch (e) {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            yield SearchFailed("Network connection is lost");
          } else {
            yield SearchFailed(e.toString());
          }
        }
      }
    }
    if (event is Searching && !_hasReachedMax(currentState)) {
      final searchQuery = event.searchQuery;
      if (currentState is SearchLoaded &&
          currentState.searchQuery == searchQuery) {
        try {
          final nextPage = currentState.page + 1;
          final data = await searchRepository.searchNews(searchQuery, nextPage);
          yield data.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : SearchLoaded(
                  data: currentState.data + data,
                  hasReachedMax: false,
                  searchQuery: searchQuery,
                  page: nextPage,
                );
          return;
        } catch (e) {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            yield SearchFailed("Network connection is lost");
          } else {
            yield currentState.copyWith(hasReachedMax: true);
          }
        }
      }
    }
    if (event is LocalSearching) {
      yield SearchLoading();
      if (event.searchQuery.isEmpty) {
        yield SearchEmpty();
      } else {
        final data = await searchRepository.searchNewsLocal(event.searchQuery);
        if (data.isEmpty) {
          yield SearchResultEmpty();
        } else {
          yield SearchLoaded(
              data: data,
              hasReachedMax: true,
              searchQuery: event.searchQuery,
              page: 1);
        }
      }
    }
    if (event is SearchClean) {
      yield SearchEmpty();
    }
  }

  bool _hasReachedMax(SearchState state) =>
      state is SearchLoaded && state.hasReachedMax;

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events,
      TransitionFunction<SearchEvent, SearchState> transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }
}
