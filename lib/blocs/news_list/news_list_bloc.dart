import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';
import 'package:newsapp/repositories/news_list_repository.dart';

import 'news_list_event.dart';
import 'news_list_state.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  final NewsListRepository newsListRepository;

  NewsListBloc({this.newsListRepository}) : assert(newsListRepository != null);

  @override
  NewsListState get initialState => Loading();

  @override
  Stream<NewsListState> mapEventToState(NewsListEvent event) async* {
    if (event is FirstLoading) {
      try {
        yield Loading();
        List<NewsViewModel> data = await this.newsListRepository.fetchData();
        yield Loaded(data);
      } catch (e) {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          try {
            List<NewsViewModel> data = await this.newsListRepository.fetchDataFromCache();
            yield Failed("Network connection is lost");
            yield Loaded(data);
          } catch (e) {
            yield Failed(e.toString());
          }
        } else {
          yield Failed(e.toString());
        }
      }
    }
  }
}