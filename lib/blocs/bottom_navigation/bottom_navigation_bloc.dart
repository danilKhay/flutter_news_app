import 'package:bloc/bloc.dart';
import 'package:newsapp/repositories/models/bottom_tab.dart';

import 'bottom_navigation_event.dart';


class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomTab> {


  @override
  BottomTab get initialState => BottomTab.news;

  @override
  Stream<BottomTab> mapEventToState(BottomNavigationEvent event) async* {
    if (event is TabUpdated) {
      yield event.tab;
    }
  }
}
