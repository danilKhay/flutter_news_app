import 'package:flutter/material.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';
import 'package:newsapp/ui/widgets/rounded_image.dart';

import '../../../widgets/info_line_widget.dart';

class NewsItem extends StatelessWidget {
  final NewsViewModel item;
  final Future<bool> Function(bool isSaved) onBookmarkPressed;

  NewsItem({@required this.item, @required this.onBookmarkPressed}) : assert(item != null);

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Text(
                    item.title,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: RoundedImage(
                  margin: EdgeInsets.only(right: 8),
                  imageUrl: item.imageUrl,
                ),
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
