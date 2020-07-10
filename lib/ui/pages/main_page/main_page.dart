import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/blocs/news_list/news_list_bloc.dart';
import 'package:newsapp/blocs/news_list/news_list_event.dart';
import 'package:newsapp/blocs/news_list/news_list_state.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_bloc.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_state.dart';
import 'package:newsapp/blocs/snackbar/snackbar_bloc.dart';
import 'package:newsapp/blocs/snackbar/snackbar_event.dart';
import 'package:newsapp/blocs/top_news/top_news_bloc.dart';
import 'package:newsapp/blocs/top_news/top_news_event.dart';
import 'package:newsapp/ui/pages/main_page/widgets/news_list.dart';
import 'package:newsapp/ui/pages/main_page/widgets/top_news_card_widget.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final snackBarBloc = BlocProvider.of<SnackBarBloc>(context);
    final topNewsBloc = BlocProvider.of<TopNewsBloc>(context);
    final newsListBloc = BlocProvider.of<NewsListBloc>(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<NewsToBookmarksBloc, NewsToBookmarksState>(
            listener: (context, state) {
          if (state is SavedToBookmarks) {
            snackBarBloc.add(SuccessSnackBarEvent("Saved to Bookmarks"));
          }
          if (state is RemovedFromBookmarks) {
            snackBarBloc.add(SuccessSnackBarEvent("Removed to Bookmarks"));
          }
          if (state is NewsToBookmarksFailed) {
            snackBarBloc.add(FailedSnackBarEvent("Failed"));
          }
        }),
        BlocListener<NewsListBloc, NewsListState>(
          listener: (context, state) {
            if (state is Failed) {
              snackBarBloc.add(FailedSnackBarEvent(state.text));
            }
          },
        ),
      ],
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            topNewsBloc.add(TopNewsFetched());
            newsListBloc.add(FirstLoading());
          },
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(
                  title: "Top Stories",
                  buttonTitle: "more",
                  onPressed: null,
                  margin: const EdgeInsets.only(
                      top: 18, right: 8, left: 16, bottom: 14),
                ),
                TopNewsCard(),
                _header(
                  title: "Latest News",
                  buttonTitle: "see all",
                  onPressed: null,
                  margin: const EdgeInsets.only(top: 30, right: 8, left: 16),
                ),
                Container(
                  child: NewsList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(
      {@required String title,
      @required String buttonTitle,
      @required Function onPressed,
      @required EdgeInsetsGeometry margin,
      Color buttonTextColor = Colors.indigoAccent}) {
    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              )),
          FlatButton(
            onPressed: onPressed,
            child: Text(
              buttonTitle.toUpperCase(),
              style: TextStyle(color: buttonTextColor),
            ),
          )
        ],
      ),
    );
  }
}
