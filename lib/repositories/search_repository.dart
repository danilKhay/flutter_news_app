import 'package:newsapp/repositories/api/news_api.dart';
import 'package:newsapp/repositories/db/db_models.dart';
import 'package:newsapp/repositories/models/short_news.dart';

import 'models/news.dart';

class SearchRepository {
  final NewsApiClient apiClient;
  final int pageSizeInt = int.parse(NewsApiClient.pageSizeForSearchList);

  SearchRepository(this.apiClient);

  Future<List<ShortNews>> searchNews(String query, int page) async {
    if (apiClient == null) throw "ApiClient is null";
    final data = await apiClient.searchNews(
        apiKey: NewsApiClient.apiKey,
        query: query,
        page: page.toString(),
        pageSize: NewsApiClient.pageSizeForSearchList);
    if (data.status != "ok") throw "Status is ${data.status}";
    return data.data;
  }

  Future<List<ShortNews>> searchNewsLocal(String query) async {
    final data = await Bookmark().select().title.contains(query).toList();
    return data
        .map(
          (item) => ShortNews(
            title: item.title,
            source: Source(name: item.sourceName),
          ),
        )
        .toList();
  }
}
