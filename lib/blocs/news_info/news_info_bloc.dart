import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:newsapp/blocs/news_info/news_info_event.dart';
import 'package:newsapp/blocs/news_info/news_info_state.dart';
import 'package:newsapp/repositories/news_info_repository.dart';

class NewsInfoBloc extends Bloc<NewsInfoEvent, NewsInfoState> {
  final NewsInfoRepository newsInfoRepository;

  NewsInfoBloc(this.newsInfoRepository) : super(NewsInfoLoading());

  @override
  Stream<NewsInfoState> mapEventToState(NewsInfoEvent event) async* {
    if (event is FetchNewsInfoFromLocal) {
      yield NewsInfoLoaded(event.data, timeAgoEnable: event.timeAgoEnable);
    }
    if (event is FetchNewsInfoFromNetwork) {
      if (newsInfoRepository != null) {
        try {
          final data = await newsInfoRepository.fetchData(event.title);
          yield NewsInfoLoaded(data);
        } catch (e) {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            yield NewsInfoFailed("Network connection is lost");
          } else {
            yield NewsInfoFailed(e.toString());
          }
        }
      }
    }
    if (event is FetchNewsInfoFromDB) {
      if (newsInfoRepository != null) {
        try {
          final data = await newsInfoRepository.fetchDataFromDb(event.title);
          yield NewsInfoLoaded(data, timeAgoEnable: false);
        } catch (e) {
          yield NewsInfoFailed(e.toString());
        }
      }
    }
  }
}