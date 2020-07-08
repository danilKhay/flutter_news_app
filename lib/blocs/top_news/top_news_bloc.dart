import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:newsapp/blocs/top_news/top_news_event.dart';
import 'package:newsapp/blocs/top_news/top_news_state.dart';
import 'package:newsapp/repositories/top_news_repository.dart';

class TopNewsBloc extends Bloc<TopNewsEvent, TopNewsState> {
  final TopNewsRepository topNewsRepository;

  TopNewsBloc({@required this.topNewsRepository}) : assert(topNewsRepository != null);

  @override
  TopNewsState get initialState => TopNewsLoading();

  @override
  Stream<TopNewsState> mapEventToState(TopNewsEvent event) async*{
    if (event is TopNewsFetched) {
      try {
        yield TopNewsLoading();
        final data = await this.topNewsRepository.getTopNews();
        yield TopNewsLoaded(data);
      } catch(e) {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          try {
            final data = await this.topNewsRepository.fetchDataFromCache();
            yield TopNewsLoaded(data);
          } catch (e) {
            yield TopNewsFailure(e.toString());
          }
        } else {
          yield TopNewsFailure(e.toString());
        }
      }
    }
  }
}