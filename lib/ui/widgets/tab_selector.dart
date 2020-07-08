import 'package:flutter/material.dart';
import 'package:newsapp/repositories/models/bottom_tab.dart';

class TabSelector extends StatelessWidget {
  final BottomTab activeTab;
  final Function(BottomTab) onTabSelected;

  TabSelector({
    @required this.activeTab,
    @required this.onTabSelected
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0.0,
      currentIndex: BottomTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(BottomTab.values[index]),
      items: const[
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          title: Text('Daily News'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          title: Text('Bookmarks'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings')
        ),
      ],
    );
  }
}