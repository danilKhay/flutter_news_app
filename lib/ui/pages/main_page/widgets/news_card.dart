import 'package:flutter/material.dart';
import 'package:newsapp/repositories/models/news_viewmodel.dart';

import '../../../widgets/Image_with_radius.dart';
import '../../../widgets/info_line_widget.dart';

class NewsCard extends StatelessWidget {
  final NewsViewModel data;
  final Future<bool> Function(bool isSaved) onBookmarkPressed;

  NewsCard({@required this.data, @required this.onBookmarkPressed})
      : assert(data != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(
              right: 8,
            ),
            child: RadiusImage(
              imageUrl: data.imageUrl,
              height: 195,
              radius: 4,
            ),
          ),
        ),
        InfoLineWidget(
          item: data,
          onMorePressed: null,
          onBookmarkPressed: (isSaved) async {
            return onBookmarkPressed(isSaved);
          },
        ),
        Container(
          margin: EdgeInsets.only(top: 16, right: 8),
          child: Text(
            data.title,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
