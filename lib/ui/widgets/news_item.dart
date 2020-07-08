import 'package:flutter/material.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';
import 'package:newsapp/ui/widgets/rounded_image.dart';

import 'info_line_widget.dart';

class NewsItem extends StatelessWidget {
  final NewsViewModel item;
  final Future<bool> Function(bool isSaved) onBookmarkPressed;

  NewsItem({@required this.item, @required this.onBookmarkPressed}) : assert(item != null);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: 8, left: 16, top: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.7,
                child: Text(
                  item.title,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              RoundedImage(
                margin: EdgeInsets.only(right: 8),
                imageUrl: item.imageUrl,
              ),
            ],
          ),
          InfoLineWidget(
            item: item,
            onMorePressed: null,
            onBookmarkPressed: (isSaved) async {
              return onBookmarkPressed(isSaved);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
