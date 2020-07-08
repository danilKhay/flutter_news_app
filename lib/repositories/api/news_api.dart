import 'package:newsapp/repositories/models/news.dart';
import 'package:newsapp/repositories/models/short_news.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'news_api.g.dart';

@RestApi(baseUrl: "https://newsapi.org/v2/")
abstract class NewsApiClient {
  factory NewsApiClient(Dio dio, {String baseUrl}) = _NewsApiClient;

  @GET("/top-headlines")
  Future<NewsList> fetchNews({
    @Query("apiKey") String apiKey = "9f59bb670abb412aa415169c133b8146",
    @Query("country") String country = "us",
    @Query("pageSize") String pageSize = "10",
  });

  @GET("/top-headlines")
  Future<NewsList> fetchTopNews({
    @Query("apiKey") String apiKey = "9f59bb670abb412aa415169c133b8146",
    @Query("country") String country = "us",
    @Query("pageSize") String pageSize = "1",
  });

  @GET("/everything")
  Future<ShortNewsList> searchNews({
    @Query("apiKey") String apiKey = "9f59bb670abb412aa415169c133b8146",
    @Query("qInTitle") String query,
    @Query("pageSize") String pageSize = "20",
    @Query("page") String page = "1",
  });

  @GET("/everything")
  Future<NewsList> fetchNewsInfo({
    @Query("apiKey") String apiKey = "9f59bb670abb412aa415169c133b8146",
    @Query("qInTitle") String query,
    @Query("pageSize") String pageSize = "1",
  });
}
