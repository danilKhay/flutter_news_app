import 'package:koin/koin.dart';
import 'package:newsapp/repositories/api/news_api.dart';
import 'package:newsapp/repositories/bookmarks_page_repository.dart';
import 'package:newsapp/repositories/news_info_repository.dart';
import 'package:newsapp/repositories/news_list_repository.dart';
import 'package:dio/dio.dart';
import 'package:newsapp/repositories/news_to_bookmarks_repository.dart';
import 'package:newsapp/repositories/search_repository.dart';
import 'package:newsapp/repositories/top_news_repository.dart';

var newsListRepositoryModule = Module()
    ..single((s) => NewsListRepository(apiClient: s.get()))
    ..single((s) => NewsApiClient(s.get()), override: true)
    ..single((s) => Dio(), override: true);

var topNewsRepositoryModule = Module()
    ..single((scope) => TopNewsRepository(apiClient: scope.get()))
    ..single((scope) => NewsApiClient(scope.get()), override: true)
    ..single((scope) => Dio(), override: true);

var searchRepositoryModule = Module()
    ..single((scope) => SearchRepository(scope.get()))
    ..single((scope) => NewsApiClient(scope.get()), override: true)
    ..single((scope) => Dio(), override: true);

var newsInfoRepositoryModule = Module()
    ..single((scope) => NewsInfoRepository(scope.get()))
    ..single((scope) => NewsApiClient(scope.get()), override: true)
    ..single((scope) => Dio(), override: true);

var newsToBookmarksRepositoryModule = Module()
    ..single((scope) => NewsToBookmarksRepository());

var bookmarksPageRepositoryModule = Module()
    ..single((scope) => BookmarksPageRepository());