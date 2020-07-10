import 'package:meta/meta.dart';
import 'package:newsapp/repositories/api/news_api.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

import 'db/db_models.dart';

class TopNewsRepository {
  final NewsApiClient apiClient;

  TopNewsRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<NewsViewModel> getTopNews() async {
    final data = await apiClient.fetchTopNews(apiKey: NewsApiClient.apiKey);
    if (data.status != "ok") throw "Status is ${data.status}";
    if (data.list.length != 1) throw "Response error: List size is ${data.list.length}";
    bool saved = await isSaved(data.list[0].title);
    return NewsViewModel.mapFromNews(data.list[0], saved);
  }

  Future<bool> isSaved(String title) async {
    final result = await Bookmark().select().title.equals(title).toList();
    return result.length != 0;
  }

  Future<NewsViewModel> fetchDataFromCache() async {
    final data = await Cache().select().orderBy("id").toList();
    if (data.length == 0 ) throw "Cache is empty";
    final cache = data[0];
    bool saved = await isSaved(cache.title);
    return NewsViewModel.mapFromCache(cache, saved);
  }
}