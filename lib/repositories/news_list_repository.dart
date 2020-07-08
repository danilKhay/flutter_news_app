import 'package:meta/meta.dart';
import 'package:newsapp/repositories/api/news_api.dart';
import 'package:newsapp/repositories/db/db_models.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

import 'models/news.dart';

class NewsListRepository {
  final NewsApiClient apiClient;

  NewsListRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<List<NewsViewModel>> fetchData() async {
    final data = await apiClient.fetchNews();
    if (data.status != "ok") throw "Status is ${data.status}";
    final newsList = data.list;
    final List<NewsViewModel> result = [];
    for (News news in newsList) {
      bool saved = await isSaved(news.title);
      result.add(NewsViewModel.mapFromNews(news, saved));
    }
    await saveToCache(result);
    return result;
  }

  Future<bool> isSaved(String title) async {
    final result = await Bookmark().select().title.equals(title).toList();
    return result.length != 0;
  }

  Future<void> saveToCache(List<NewsViewModel> data) async {
    await Cache().select().delete();
    data.forEach((element) async { 
      await element.mapToCache(element).save();
    });
  }

  Future<List<NewsViewModel>> fetchDataFromCache() async {
    final data = await Cache().select().orderBy("id").toList();
    if (data.length == 0 ) throw "Cache is empty";
    final List<NewsViewModel> result = [];
    for (Cache cache in data) {
      bool saved = await isSaved(cache.title);
      result.add(NewsViewModel.mapFromCache(cache, saved));
    }
    return result;
  }
}
