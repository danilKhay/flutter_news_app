import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin/koin.dart';
import 'package:newsapp/blocs/bookmarks/bookmarks_bloc.dart';
import 'package:newsapp/blocs/bookmarks/bookmarks_event.dart';
import 'package:newsapp/blocs/bookmarks/bookmarks_state.dart';
import 'package:newsapp/blocs/news_info/news_info_bloc.dart';
import 'package:newsapp/blocs/news_info/news_info_event.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_bloc.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_event.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_state.dart';
import 'package:newsapp/blocs/snackbar/snackbar_bloc.dart';
import 'package:newsapp/blocs/snackbar/snackbar_event.dart';
import 'package:newsapp/repositories/models/news.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';
import 'package:newsapp/repositories/news_to_bookmarks_repository.dart';
import 'package:newsapp/ui/widgets/circle_image.dart';
import 'package:newsapp/ui/widgets/loading_widget.dart';
import 'package:newsapp/ui/widgets/rounded_image.dart';
import 'package:newsapp/utils.dart';
import 'news_page.dart';

class BookmarksPage extends StatelessWidget with KoinComponentMixin {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewsToBookmarksBloc>(context);
    final snackBarBloc = BlocProvider.of<SnackBarBloc>(context);
    return BlocListener<NewsToBookmarksBloc, NewsToBookmarksState>(
      listener: (context, state) {
        if (state is RemovedFromBookmarks) {
          snackBarBloc.add(SuccessSnackBarEvent("Removed to Bookmarks"));
        }
        if (state is NewsToBookmarksFailed) {
          snackBarBloc.add(FailedSnackBarEvent("Failed"));
        }
      },
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: BlocBuilder<BookmarksBloc, BookmarksState>(
            builder: (BuildContext context, BookmarksState state) {
              if (state is Loading) {
                return LoadingWidget();
              }
              if (state is Loaded) {
                return _loadedWidget(state, (title) async {
                  var result = await showRemoveDialog(context);
                  if (result == true) {
                    bloc.add(RemovingFromBookmarks(title));
                    context.bloc<BookmarksBloc>().add(FetchBookmarks());
                  }
                });
              }
              if (state is BookmarksEmpty) {
                return Center(
                  child: Text("Bookmarks are empty"),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _loadedWidget(Loaded state, Function(String title) onItemBookmark) {
    final data = state.data;
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            var item = data[index];
            var isSaved = item.isSavedToBookmark;
            var result = await _navigate(context, item);
            if (result != isSaved) {
              BlocProvider.of<BookmarksBloc>(context).add(FetchBookmarks());
            }
          },
          child: BookmarkItem(
            data: data[index],
            onPressedBookmark: (title) => onItemBookmark(title),
          ),
        );
      },
    );
  }

  Future<bool> _navigate(BuildContext context, NewsViewModel data) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SnackBarBloc(),
            ),
            BlocProvider(
              create: (context) => NewsToBookmarksBloc(get<NewsToBookmarksRepository>()),
            ),
            BlocProvider(
                create: (context) => NewsInfoBloc(null)
                  ..add(FetchNewsInfoFromLocal(data, timeAgoEnable: false))),
          ],
          child: NewsPage(),
        ),
      ),
    );
  }

}

class BookmarkItem extends StatelessWidget {
  final NewsViewModel data;
  final Function(String title) onPressedBookmark;

  const BookmarkItem({this.data, this.onPressedBookmark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleImage(
                          imageUrl: News.sourceImageUrl,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          data.sourceName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RoundedImage(
                      margin: EdgeInsets.only(right: 8),
                      imageUrl: data.imageUrl,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.bookmark, color: Colors.black),
                          onPressed: () => onPressedBookmark(data.title),
                        ),
                        PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            const PopupMenuItem(child: Text("Info"))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            formatDataTimeForBookmarks(data.time),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
