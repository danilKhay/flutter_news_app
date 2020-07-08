import 'package:flutter/material.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

class BookmarkIconButton extends StatefulWidget {
  final Future<bool> Function(bool isSaved) onBookmarkPressed;
  final NewsViewModel news;

  const BookmarkIconButton(
      {@required this.onBookmarkPressed, @required this.news});

  @override
  State createState() => _BookmarkIconButtonState();
}

class _BookmarkIconButtonState extends State<BookmarkIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _buildBookmarkButtonBloc(),
      onPressed: () async {
        var item = widget.news;
        var result = await widget.onBookmarkPressed(item.isSavedToBookmark);
        if (result == true) {
          setState(() {
            item.isSavedToBookmark = !item.isSavedToBookmark;
          });
        }
      },
    );
  }

  Widget _buildBookmarkButtonBloc() => widget.news.isSavedToBookmark
      ? Icon(Icons.bookmark, color: Colors.black)
      : Icon(Icons.bookmark_border, color: Colors.black);
}