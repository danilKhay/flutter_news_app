import 'package:newsapp/repositories/models/news_viewmodel.dart';

import 'db/db_models.dart';

class BookmarksPageRepository {
  Future<List<NewsViewModel>> fetchData() async {
    final result = await Bookmark().select().orderByDesc("id").toList();
    return result.map(
      (bookmark) => NewsViewModel.mapFromBookmark(bookmark),
    ).toList();
  }
}
