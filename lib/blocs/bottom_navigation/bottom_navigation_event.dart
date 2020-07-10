import 'package:equatable/equatable.dart';
import 'package:newsapp/repositories/models/bottom_tab.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();
}

class TabUpdated extends BottomNavigationEvent {
  final BottomTab tab;

  const TabUpdated(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => "TabUpdated { tab: $tab }";
}
