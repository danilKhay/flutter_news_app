import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDataTimeForBookmarks(DateTime dateTime) {
  var formatter = DateFormat('d MMMM');
  return formatter.format(dateTime);
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

showSnackBar(BuildContext context, String text,
    {Color backgroundColor = Colors.black,
    Duration duration = const Duration(milliseconds: 500)}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      content: Text(text),
      duration: duration,
    ),
  );
}

Future<bool> showRemoveDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Warning'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Would you like to remove this news from bookmarks?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}