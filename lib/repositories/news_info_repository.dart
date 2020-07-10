import 'package:newsapp/repositories/api/news_api.dart';
import 'package:newsapp/repositories/db/db_models.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

class NewsInfoRepository {
  final NewsApiClient apiClient;

  NewsInfoRepository(this.apiClient);

  Future<NewsViewModel> fetchData(String title) async {
    final data = await apiClient.fetchNewsInfo(
        apiKey: NewsApiClient.apiKey, query: "\"$title\"");
    if (data.status != "ok") throw "Status is ${data.status}";
    if (data.list.length != 1)
      throw "Response error: List size is ${data.list.length}";
    final saved = await isSaved(data.list[0].title);
    return NewsViewModel.mapFromNews(data.list[0], saved);
  }

  Future<NewsViewModel> fetchDataFromDb(String title) async {
    final data = await Bookmark().select().title.contains(title).toList();
    if (data.length != 1) throw "Response error: List size is ${data.length}";
    final result = data[0];
    return NewsViewModel.mapFromBookmark(result);
  }

  Future<bool> isSaved(String title) async {
    final result = await Bookmark().select().title.equals(title).toList();
    return result.length != 0;
  }
}
