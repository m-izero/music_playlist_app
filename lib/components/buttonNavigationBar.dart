import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_playlist/PAGES/home.dart';
import '../PAGES/playlist.dart';
import '../PAGES/settings.dart';

class ButtonBar extends StatefulWidget {
  const ButtonBar({super.key});

  @override
  State<ButtonBar> createState() => _ButtonBarState();
}

class _ButtonBarState extends State<ButtonBar> {
  int myIndex = 0;
  List<Widget> widgetList = const [
    Screen1(),
    Screen3(),
    Screen4(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetList[myIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add),
              label: 'Playlist',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.blue),
        ],
        currentIndex: myIndex,
        selectedItemColor: Colors.blue[800],
        onTap: (int index) {
          setState(() {
            myIndex = index;
          });
        },
      ),
    );
  }
}
