import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:newsapp/app.dart';

import 'blocs/bloc.dart';
import 'di/modules.dart';

void main() {
  Bloc.observer = SimpleBlocDelegate();
  startKoin((app) {
    app.printLogger(level: Level.debug);
    app.modules([
      newsListRepositoryModule,
      topNewsRepositoryModule,
      searchRepositoryModule,
      newsInfoRepositoryModule,
      newsToBookmarksRepositoryModule,
      bookmarksPageRepositoryModule
    ]);
  });
  runApp(App());
}

