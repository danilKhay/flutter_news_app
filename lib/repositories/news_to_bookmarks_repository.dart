import 'package:newsapp/repositories/models/news_viewmodel.dart';

import 'db/db_models.dart';
import 'models/news.dart';

class NewsToBookmarksRepository {

  Future<void> saveNewsToBookmark(NewsViewModel news) async {
    final result = await Bookmark(
        title: news.title,
        imageUrl: news.imageUrl,
        sourceName: news.sourceName,
        sourceImageUrl: News.sourceImageUrl,
        content: news.content,
        dateTime: news.time)
        .save();

    if (result <= 0) {
      throw "Error. Saving was failed";
    }
  }

  Future<void> removeNewsFromBookmark(String title) async {
    final result = await Bookmark().select().title.equals(title).delete();
    if (!result.success) {
      throw "Error. Can't delete";
    }
  }
}