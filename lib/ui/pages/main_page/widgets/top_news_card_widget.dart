import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/blocs/news_info/news_info_bloc.dart';
import 'package:newsapp/blocs/news_info/news_info_event.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_bloc.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_event.dart';
import 'package:newsapp/blocs/snackbar/snackbar_bloc.dart';
import 'package:newsapp/blocs/top_news/top_news_bloc.dart';
import 'package:newsapp/blocs/top_news/top_news_state.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';
import 'package:newsapp/repositories/news_to_bookmarks_repository.dart';
import 'package:newsapp/ui/widgets/loading_widget.dart';
import 'package:newsapp/utils.dart';

import '../../news_page.dart';
import 'news_card.dart';

class TopNewsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsToBookmarksBloc = BlocProvider.of<NewsToBookmarksBloc>(context);
    return BlocBuilder<TopNewsBloc, TopNewsState>(
      builder: (BuildContext context, TopNewsState state) {
        if (state is TopNewsLoading) {
          return _loading();
        }
        if (state is TopNewsLoaded) {
          return _loaded(context, state.data, newsToBookmarksBloc);
        }
        if (state is TopNewsFailure) {
          return _error(state.text);
        }
        return Container();
      },
    );
  }

  Widget _loading() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: LoadingWidget(),
    );
  }

  Widget _loaded(BuildContext context, NewsViewModel data,
      NewsToBookmarksBloc newsToBookmarksBloc) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SnackBarBloc(),
              ),
              BlocProvider(
                create: (context) =>
                    NewsToBookmarksBloc(NewsToBookmarksRepository()),
              ),
              BlocProvider(
                  create: (context) =>
                  NewsInfoBloc(null)..add(FetchNewsInfoFromLocal(data))
              ),
            ],
            child: NewsPage(),
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 8,
        ),
        child: NewsCard(
          data: data,
          onBookmarkPressed: (isSaved) async {
            if (isSaved) {
              var result = await showRemoveDialog(context);
              if (result == true) {
                newsToBookmarksBloc
                    .add(RemovingFromBookmarks(data.title));
                return true;
              } else {
                return false;
              }
            } else {
              newsToBookmarksBloc.add(SavingToBookmarks(data));
              return true;
            }
          },
        ),
      ),
    );
  }

  Widget _error(String text) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Center(
        child: Text(text),
      ),
    );
  }
}