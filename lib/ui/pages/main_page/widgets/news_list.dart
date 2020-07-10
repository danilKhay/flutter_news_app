import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin/koin.dart';
import 'package:newsapp/blocs/news_info/news_info_bloc.dart';
import 'package:newsapp/blocs/news_info/news_info_event.dart';
import 'package:newsapp/blocs/news_list/news_list_bloc.dart';
import 'package:newsapp/blocs/news_list/news_list_event.dart';
import 'package:newsapp/blocs/news_list/news_list_state.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_bloc.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_event.dart';
import 'package:newsapp/blocs/snackbar/snackbar_bloc.dart';
import 'package:newsapp/blocs/top_news/top_news_bloc.dart';
import 'package:newsapp/blocs/top_news/top_news_event.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';
import 'package:newsapp/repositories/news_to_bookmarks_repository.dart';
import 'package:newsapp/ui/widgets/loading_widget.dart';

import 'package:newsapp/utils.dart';
import 'package:newsapp/ui/pages/news_page.dart';
import 'news_item.dart';

class NewsList extends StatelessWidget with KoinComponentMixin {
  @override
  Widget build(BuildContext context) {
    final newsToBookmarksBloc = BlocProvider.of<NewsToBookmarksBloc>(context);
    final topNewsBloc = BlocProvider.of<TopNewsBloc>(context);
    return BlocBuilder<NewsListBloc, NewsListState>(
      builder: (BuildContext context, NewsListState state) {
        if (state is Loading) {
          return Container(
            margin: EdgeInsets.all(16.0),
            child: LoadingWidget(),
          );
        }
        if (state is Loaded) {
          final items = state.data;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () async {
                  var isSaved = item.isSavedToBookmark;
                  var result = await _navigate(context, item);
                  if (isSaved != result) {
                    BlocProvider.of<NewsListBloc>(context)
                        .add(NewsListUpdate());
                    if (index == 0) {
                      topNewsBloc.add(TopNewsCheckInDb());
                    }
                  }
                },
                child: NewsItem(
                  item: item,
                  onBookmarkPressed: (isSaved) async =>
                  await _onBookmarkPressed(
                    context,
                    isSaved,
                    item,
                    newsToBookmarksBloc,
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  Future<bool> _onBookmarkPressed(BuildContext context, bool isSaved,
      NewsViewModel news, NewsToBookmarksBloc newsToBookmarksBloc) async {
    if (isSaved) {
      var result = await showRemoveDialog(context);
      if (result == true) {
        newsToBookmarksBloc.add(RemovingFromBookmarks(news.title));
        return true;
      } else {
        return false;
      }
    } else {
      newsToBookmarksBloc.add(SavingToBookmarks(news));
      return true;
    }
  }

  Future<bool> _navigate(BuildContext context, NewsViewModel news) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SnackBarBloc(),
            ),
            BlocProvider(
              create: (context) => NewsToBookmarksBloc(
                  get<NewsToBookmarksRepository>()),
            ),
            BlocProvider(
                create: (context) => NewsInfoBloc(null)
                  ..add(FetchNewsInfoFromLocal(news))),
          ],
          child: NewsPage(),
        ),
      ),
    );
  }
}
