import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/blocs/snackbar/snackbar_bloc.dart';
import 'package:newsapp/repositories/api/news_api.dart';
import 'package:newsapp/ui/app_screen.dart';
import 'blocs/bottom_navigation/bottom_navigation_bloc.dart';

class App extends StatelessWidget {
  final NewsApiClient apiClient;

  App(this.apiClient);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.indigoAccent,
            unselectedItemColor: Colors.grey),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          actionsIconTheme: IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SnackBarBloc>(
            create: (context) => SnackBarBloc(),
          ),
          BlocProvider<BottomNavigationBloc>(
            create: (BuildContext context) => BottomNavigationBloc(),
          ),
        ],
        child: AppScreen(apiClient),
      ),
    );
  }
}
