import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/blocs/news_info/news_info_bloc.dart';
import 'package:newsapp/blocs/news_info/news_info_event.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_bloc.dart';
import 'package:newsapp/blocs/search/search_bloc.dart';
import 'package:newsapp/blocs/search/search_event.dart';
import 'package:newsapp/blocs/search/search_state.dart';
import 'package:newsapp/blocs/snackbar/snackbar_bloc.dart';
import 'package:newsapp/repositories/api/news_api.dart';
import 'package:newsapp/repositories/news_info_repository.dart';
import 'package:newsapp/repositories/news_to_bookmarks_repository.dart';
import 'package:newsapp/ui/widgets/loading_widget.dart';

import '../../utils.dart';
import 'news_page.dart';

class SearchPage extends StatefulWidget {
  final NewsApiClient apiClient;
  final bool isLocal;

  const SearchPage({this.apiClient, this.isLocal = false});

  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: TextField(
          autofocus: true,
          controller: _controller,
          onChanged: (String str) {
            BlocProvider.of<SearchBloc>(context)
                .add(widget.isLocal ? LocalSearching(str) : Searching(str, 1));
          },
          decoration: InputDecoration(
            hintText: "Search Here...",
            border: UnderlineInputBorder(borderSide: BorderSide.none),
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
                onPressed: () => _controller.clear()),
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
          if (state is SearchEmpty){
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
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              onTap: () {
                hideKeyboard(context);
                return Navigator.push(
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
                          create: (context) {
                            if (widget.isLocal) {
                              return NewsInfoBloc(
                                NewsInfoRepository(null),
                              )..add(
                                  FetchNewsInfoFromDB(
                                    data[index].title,
                                  ),
                                );
                            } else {
                              return NewsInfoBloc(
                                NewsInfoRepository(widget.apiClient),
                              )..add(
                                  FetchNewsInfoFromNetwork(
                                    data[index].title,
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
              },
              title: Text(
                data[index].title,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                data[index].source.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
