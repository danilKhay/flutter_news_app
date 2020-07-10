import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin/koin.dart';
import 'package:newsapp/blocs/news_info/news_info_bloc.dart';
import 'package:newsapp/blocs/news_info/news_info_event.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_bloc.dart';
import 'package:newsapp/blocs/search/search_bloc.dart';
import 'package:newsapp/blocs/search/search_event.dart';
import 'package:newsapp/blocs/search/search_state.dart';
import 'package:newsapp/blocs/snackbar/snackbar_bloc.dart';
import 'package:newsapp/repositories/models/short_news.dart';
import 'package:newsapp/repositories/news_info_repository.dart';
import 'package:newsapp/repositories/news_to_bookmarks_repository.dart';
import 'package:newsapp/ui/widgets/bottom_loader.dart';
import 'package:newsapp/ui/widgets/loading_widget.dart';

import '../../utils.dart';
import 'news_page.dart';

class SearchPage extends StatefulWidget {
  final bool isLocal;

  const SearchPage({this.isLocal = false});

  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with KoinComponentMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  SearchBloc _searchBloc;
  String _searchQuery;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchBloc = BlocProvider.of<SearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: TextField(
          autofocus: true,
          controller: _controller,
          onChanged: (String str) {
            _searchQuery = str;
            _searchBloc.add(
                widget.isLocal ? LocalSearching(str) : FirstSearching(str));
          },
          decoration: InputDecoration(
            hintText: "Search Here...",
            border: UnderlineInputBorder(borderSide: BorderSide.none),
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _controller.clear();
                  _searchBloc.add(SearchClean());
                }),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return LoadingWidget();
          }
          if (state is SearchLoaded) {
            return _buildListView(state);
          }
          if (state is SearchResultEmpty) {
            return _noResult();
          }
          if (state is SearchEmpty) {
            return _emptySearchLine();
          }
          if (state is SearchFailed) {
            return _error(state.text);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _noResult() {
    return Container(
      child: Center(
        child: Text("No results."),
      ),
    );
  }

  Widget _emptySearchLine() {
    return Container(
      child: Center(
        child: Text("Search line is empty. Input some info."),
      ),
    );
  }

  Widget _error(String error) {
    return Container(
      child: Center(
        child: Text(error),
      ),
    );
  }

  Widget _buildListView(SearchLoaded state) {
    final data = state.data;
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.hasReachedMax ? data.length : data.length + 1,
      itemBuilder: (context, index) {
        return index >= state.data.length
            ? BottomLoader()
            : _searchItem(data[index]);
      },
    );
  }

  Widget _searchItem(ShortNews news) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            hideKeyboard(context);
            _navigate(news.title);
          },
          title: _textWithOverflow(news.title),
          subtitle: _textWithOverflow(news.source.name),
        ),
        Divider(),
      ],
    );
  }

  Widget _textWithOverflow(String text) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _navigate(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SnackBarBloc(),
            ),
            BlocProvider(
              create: (context) =>
                  NewsToBookmarksBloc(get<NewsToBookmarksRepository>()),
            ),
            BlocProvider(
              create: (context) {
                if (widget.isLocal) {
                  return NewsInfoBloc(
                    NewsInfoRepository(null),
                  )..add(
                      FetchNewsInfoFromDB(
                        title,
                      ),
                    );
                } else {
                  return NewsInfoBloc(
                    get<NewsInfoRepository>(),
                  )..add(
                      FetchNewsInfoFromNetwork(
                        title,
                      ),
                    );
                }
              },
            ),
          ],
          child: NewsPage(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (_searchQuery != null) {
        _searchBloc.add(Searching(_searchQuery));
      }
    }
  }
}
