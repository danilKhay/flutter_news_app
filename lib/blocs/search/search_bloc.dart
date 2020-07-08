import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:newsapp/blocs/search/search_event.dart';
import 'package:newsapp/blocs/search/search_state.dart';
import 'package:newsapp/repositories/search_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({@required this.searchRepository}) : assert(searchRepository != null);

  @override
  SearchState get initialState => SearchInit();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is Searching) {
      yield SearchLoading();
      if (event.searchQuery.isEmpty) {
        yield SearchEmpty();
      } else {
        try {
          final data = await searchRepository.searchNews(event.searchQuery, event.page);
          if (data.isEmpty) {
            yield SearchResultEmpty();
          } else {
            yield SearchLoaded(data);
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
    if (event is LocalSearching) {
      yield SearchLoading();
      if (event.searchQuery.isEmpty) {
        yield SearchEmpty();
      } else {
        final data = await searchRepository.searchNewsLocal(event.searchQuery);
        if (data.isEmpty) {
          yield SearchResultEmpty();
        } else {
          yield SearchLoaded(data);
        }
      }
    }
  }

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events,
      TransitionFunction<SearchEvent, SearchState> transitionFn) {
      return super.transformEvents(
          events.debounceTime(Duration(milliseconds: 500)),
          transitionFn
      );
  }
}