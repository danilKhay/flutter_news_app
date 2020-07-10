import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/blocs/blocs.dart';
import 'package:newsapp/blocs/bookmarks/bookmarks_bloc.dart';
import 'package:newsapp/blocs/bookmarks/bookmarks_event.dart';
import 'package:newsapp/blocs/news_list/news_list_bloc.dart';
import 'package:newsapp/blocs/news_list/news_list_event.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_bloc.dart';
import 'package:newsapp/blocs/search/search_bloc.dart';
import 'package:newsapp/blocs/snackbar/snackbar_bloc.dart';
import 'package:newsapp/blocs/snackbar/snackbar_state.dart';
import 'package:newsapp/blocs/top_news/top_news_bloc.dart';
import 'package:newsapp/blocs/top_news/top_news_event.dart';
import 'package:newsapp/repositories/news_to_bookmarks_repository.dart';
import 'package:newsapp/repositories/bookmarks_page_repository.dart';
import 'package:newsapp/repositories/models/bottom_tab.dart';
import 'package:newsapp/repositories/news_list_repository.dart';
import 'package:newsapp/repositories/search_repository.dart';
import 'package:newsapp/repositories/top_news_repository.dart';
import 'package:newsapp/ui/pages/bookmarks_page.dart';
import 'package:newsapp/ui/pages/main_page/main_page.dart';
import 'package:newsapp/ui/pages/search_page.dart';
import 'package:newsapp/ui/pages/settings_page.dart';
import 'package:newsapp/ui/widgets/tab_selector.dart';
import 'package:newsapp/utils.dart';
import 'package:koin/koin.dart';

class AppScreen extends StatelessWidget with KoinComponentMixin{

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: _appBarSelecting(context, activeTab),
          body: BlocListener<SnackBarBloc, SnackBarState>(
              listener: (context, state) {
                if (state is SuccessSnackBar) {
                  showSnackBar(context, state.title ?? "No data");
                }
                if (state is FailedSnackBar) {
                  showSnackBar(context, state.title ?? "No data",
                      backgroundColor: Colors.redAccent,
                      duration: const Duration(milliseconds: 1000));
                }
              },
              child: _bodySelecting(activeTab)),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<BottomNavigationBloc>(context)
                    .add(TabUpdated(tab)),
          ),
        );
      },
    );
  }

  Widget _bodySelecting(BottomTab tab) {
    if (tab == BottomTab.bookmarks) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => BookmarksBloc(get<BookmarksPageRepository>())
                ..add(FetchBookmarks())),
          BlocProvider(
            create: (context) =>
                NewsToBookmarksBloc(get<NewsToBookmarksRepository>()),
          ),
        ],
        child: BookmarksPage(),
      );
    }
    if (tab == BottomTab.settings) {
      return SettingsPage();
    }
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => NewsToBookmarksBloc(get<NewsToBookmarksRepository>()),
      ),
      BlocProvider(
        create: (context) => TopNewsBloc(
            topNewsRepository: get<TopNewsRepository>())
          ..add(TopNewsFetched()),
      ),
      BlocProvider(
        create: (context) => NewsListBloc(
            newsListRepository: get<NewsListRepository>())
          ..add(FirstLoading()),
      ),
    ], child: MainPage());
  }

  Widget _appBarSelecting(BuildContext context, BottomTab tab) {
    if (tab == BottomTab.bookmarks) {
      return AppBar(
        title: Text("Bookmarks"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SearchBloc(
                      searchRepository: get<SearchRepository>(),
                    ),
                    child: SearchPage(
                      isLocal: true,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    }
    if (tab == BottomTab.settings) {
      return AppBar(
        title: Text("Settings"),
      );
    }
    return AppBar(
      title: Text("Daily News"),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SearchBloc(
                    searchRepository: get<SearchRepository>(),
                  ),
                  child: SearchPage(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
