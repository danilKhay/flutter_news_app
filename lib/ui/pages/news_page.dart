import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:newsapp/blocs/news_info/news_info_bloc.dart';
import 'package:newsapp/blocs/news_info/news_info_state.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_bloc.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_event.dart';
import 'package:newsapp/blocs/news_to_bookmarks/news_to_bookmarks_state.dart';
import 'package:newsapp/blocs/snackbar/snackbar_bloc.dart';
import 'package:newsapp/blocs/snackbar/snackbar_event.dart';
import 'package:newsapp/blocs/snackbar/snackbar_state.dart';
import 'package:newsapp/repositories/models/news.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';
import 'package:newsapp/ui/widgets/bookmark_icon_button.dart';
import 'package:newsapp/ui/widgets/circle_image.dart';
import 'package:newsapp/ui/widgets/loading_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:newsapp/utils.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final snackBarBloc = BlocProvider.of<SnackBarBloc>(context);
    final newsToBookmarksBloc = BlocProvider.of<NewsToBookmarksBloc>(context);
    return BlocBuilder<NewsInfoBloc, NewsInfoState>(
      builder: (context, state) {
        if (state is NewsInfoLoading) {
          return _loading();
        }
        if (state is NewsInfoLoaded) {
          return _loaded(context, snackBarBloc, newsToBookmarksBloc, state.data,
              state.timeAgoEnable);
        }
        if (state is NewsInfoFailed) {
          return _error(state.info);
        }
        return Container();
      },
    );
  }

  Widget _error(String text) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }

  Widget _loading() {
    return Scaffold(
      body: LoadingWidget(),
    );
  }

  Widget _loaded(
      BuildContext context,
      SnackBarBloc snackBarBloc,
      NewsToBookmarksBloc newsToBookmarksBloc,
      NewsViewModel data,
      bool timeAgoEnable) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, data.isSavedToBookmark),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => share(data.title, data.content),
          ),
          BookmarkIconButton(
            news: data,
            onBookmarkPressed: (isSaved) async {
              if (isSaved) {
                var result = await showRemoveDialog(context);
                if (result == true) {
                  newsToBookmarksBloc.add(RemovingFromBookmarks(data.title));
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
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SnackBarBloc, SnackBarState>(listener: (context, state) {
            if (state is SuccessSnackBar) {
              showSnackBar(context, state.title ?? "No data");
            }
            if (state is FailedSnackBar) {
              showSnackBar(context, state.title ?? "No data",
                  backgroundColor: Colors.redAccent);
            }
          }),
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
            },
          ),
        ],
        child: _newsInfo(data, timeAgoEnable),
      ),
    );
  }

  Widget _newsInfo(NewsViewModel news, bool timeAgoEnable) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleImage(
            imageUrl: News.sourceImageUrl,
            size: 40.0,
            margin: EdgeInsets.only(top: 20),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Text(
              news.title,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Divider(),
          ),
          const Text(
            "Published",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            timeAgoEnable
                ? timeago.format(news.time, allowFromNow: true)
                : formatDataTimeForBookmarks(news.time),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: _image(news.imageUrl),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(news.content ?? "No Data")),
        ],
      ),
    );
  }

  Widget _image(String imageUrl) {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => LoadingWidget(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else {
      return Icon(Icons.error);
    }
  }

  Future<void> share(String title, String content) async {
    await FlutterShare.share(
        title: title,
        text: content,
        linkUrl: 'https://flutter.dev/',
        chooserTitle: null);
  }
}