import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/app.dart';
import 'package:dio/dio.dart';
import 'package:newsapp/repositories/api/news_api.dart';

import 'blocs/bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final dio = Dio();
  runApp(App(NewsApiClient(dio)));
}

