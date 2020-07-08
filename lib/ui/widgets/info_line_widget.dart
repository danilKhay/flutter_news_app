import 'package:flutter/material.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:newsapp/repositories/models/news.dart';
import 'circle_image.dart';

class InfoLineWidget extends StatefulWidget {
  final NewsViewModel item;
  final Function() onMorePressed;
  final Future<bool> Function(bool isSaved) onBookmarkPressed;
  final EdgeInsetsGeometry margin;

  const InfoLineWidget(
      {@required this.item,
      @required this.onMorePressed,
      @required this.onBookmarkPressed,
      this.margin = const EdgeInsets.only(top: 20)});

  @override
  State createState() =>_InfoLineWidgetState();
}

class _InfoLineWidgetState extends State<InfoLineWidget> {
  NewsViewModel get item => widget.item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleImage(
                imageUrl: News.sourceImageUrl,
                size: 40,
              ),
              Container(
                width: 180,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${item.sourceName} • ${timeago.format(item.time, allowFromNow: true)}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: _buildButtonBloc(item.isSavedToBookmark),
                onPressed: () async {
                  var result = await widget.onBookmarkPressed(item.isSavedToBookmark);
                  if (result == true) {
                    setState(() {
                      item.isSavedToBookmark = !item.isSavedToBookmark;
                    });
                  }
                },
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry>[const PopupMenuItem(child: Text("Info"))],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButtonBloc(bool isSaved) => isSaved
      ? Icon(Icons.bookmark, color: Colors.black)
      : Icon(Icons.bookmark_border, color: Colors.black);

}
